import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visited_area.dart';

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();

  SharedPreferences? _prefs;

  static const _keyVisited = 'visited_areas';
  static const _keySteps = 'step_records';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<VisitedArea> _loadVisited() {
    final raw = _prefs!.getString(_keyVisited);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => VisitedArea.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> _saveVisited(List<VisitedArea> areas) async {
    await _prefs!.setString(
        _keyVisited, jsonEncode(areas.map((a) => a.toMap()).toList()));
  }

  Map<String, int> _loadSteps() {
    final raw = _prefs!.getString(_keySteps);
    if (raw == null) return {};
    return (jsonDecode(raw) as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v as int));
  }

  Future<void> _saveStepsMap(Map<String, int> steps) async {
    await _prefs!.setString(_keySteps, jsonEncode(steps));
  }

  Future<bool> isVisited(String prefecture, String municipality) async {
    final areas = _loadVisited();
    return areas.any(
        (a) => a.prefecture == prefecture && a.municipality == municipality);
  }

  Future<bool> addVisitedArea(VisitedArea area) async {
    final areas = _loadVisited();
    final exists = areas.any((a) =>
        a.prefecture == area.prefecture &&
        a.municipality == area.municipality);
    if (exists) return false;
    areas.insert(0, area);
    await _saveVisited(areas);
    return true;
  }

  Future<List<VisitedArea>> getAllVisited() async {
    return _loadVisited();
  }

  Future<int> getVisitedCount() async {
    return _loadVisited().length;
  }

  Future<Map<String, int>> getPrefectureVisitCounts() async {
    final areas = _loadVisited();
    final counts = <String, int>{};
    for (final a in areas) {
      counts[a.prefecture] = (counts[a.prefecture] ?? 0) + 1;
    }
    return counts;
  }

  Future<List<VisitedArea>> getVisitedByPrefecture(String prefecture) async {
    return _loadVisited().where((a) => a.prefecture == prefecture).toList();
  }

  Future<void> saveSteps(String date, int steps) async {
    final map = _loadSteps();
    map[date] = steps;
    await _saveStepsMap(map);
  }

  Future<int> getSteps(String date) async {
    return _loadSteps()[date] ?? 0;
  }

  Future<List<Map<String, dynamic>>> getRecentSteps(int days) async {
    final map = _loadSteps();
    final sorted = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return sorted
        .take(days)
        .map((e) => {'date': e.key, 'steps': e.value})
        .toList();
  }

  Future<int> getTotalSteps() async {
    return _loadSteps().values.fold<int>(0, (sum, v) => sum + v);
  }

  Future<int> getActiveDays() async {
    return _loadSteps().values.where((v) => v > 0).length;
  }

  Future<List<Map<String, dynamic>>> getMonthSteps(int year, int month) async {
    final prefix = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    final map = _loadSteps();
    final result = <Map<String, dynamic>>[];
    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (int d = 1; d <= daysInMonth; d++) {
      final dateStr = '$prefix-${d.toString().padLeft(2, '0')}';
      result.add({'date': dateStr, 'steps': map[dateStr] ?? 0});
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getWeeklyAggregates(int weeks) async {
    final now = DateTime.now();
    final map = _loadSteps();
    final result = <Map<String, dynamic>>[];
    for (int w = weeks - 1; w >= 0; w--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + w * 7));
      int total = 0;
      for (int d = 0; d < 7; d++) {
        final day = weekStart.add(Duration(days: d));
        final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
        total += map[key] ?? 0;
      }
      result.add({'week': weeks - w, 'steps': total, 'start': weekStart});
    }
    return result;
  }
}
