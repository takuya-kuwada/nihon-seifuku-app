import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'database_service.dart';

class StepService {
  StepService._();
  static final instance = StepService._();

  final _db = DatabaseService.instance;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  int _baseSteps = 0;
  int _todaySteps = 0;
  String _today = '';
  bool _initialized = false;

  Stream<int>? _stepStream;

  int get todaySteps => _todaySteps;

  Stream<int> startCounting() {
    _stepStream ??= _buildStream();
    return _stepStream!;
  }

  Stream<int> _buildStream() async* {
    final rawStream = Pedometer.stepCountStream;
    await for (final event in rawStream) {
      final today = _dateFormat.format(DateTime.now());
      final totalSteps = event.steps;

      if (!_initialized || _today != today) {
        _today = today;
        _baseSteps = totalSteps - await _db.getSteps(today);
        _initialized = true;
      }

      _todaySteps = (totalSteps - _baseSteps).clamp(0, 999999);
      await _db.saveSteps(today, _todaySteps);
      yield _todaySteps;
    }
  }
}
