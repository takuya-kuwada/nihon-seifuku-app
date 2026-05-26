import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/step_service.dart';
import '../services/database_service.dart';

String _fmtNum(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

enum _Period { day, week, month, total }

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  final _stepService = StepService.instance;
  final _db = DatabaseService.instance;

  _Period _period = _Period.day;
  int _todaySteps = 0;
  int _totalSteps = 0;
  int _activeDays = 0;
  List<Map<String, dynamic>> _weekData = [];
  List<Map<String, dynamic>> _monthData = [];
  bool _hasError = false;

  static const _goal = 8000;

  @override
  void initState() {
    super.initState();
    _loadAll();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _hasError = true);
      });
    } else {
      _startCounting();
    }
  }

  Future<void> _loadAll() async {
    final now = DateTime.now();
    final weekly = await _db.getRecentSteps(7);
    final monthly = await _db.getMonthSteps(now.year, now.month);
    final total = await _db.getTotalSteps();
    final active = await _db.getActiveDays();
    if (mounted) {
      setState(() {
        _weekData = weekly;
        _monthData = monthly;
        _totalSteps = total;
        _activeDays = active;
      });
    }
  }

  void _startCounting() {
    try {
      _stepService.startCounting().listen(
        (steps) {
          if (mounted) {
            setState(() {
              _todaySteps = steps;
              _hasError = false;
            });
            _loadAll();
          }
        },
        onError: (_) {
          if (mounted) setState(() => _hasError = true);
        },
      );
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Text('🚶', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text('歩数カウンター',
                      style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFB300))),
                ],
              ),
            ),
            // セグメント切り替え
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SegmentedSelector(
                selected: _period,
                onChanged: (p) => setState(() => _period = p),
              ),
            ),
            const SizedBox(height: 16),
            // コンテンツ
            Expanded(
              child: _hasError
                  ? _ErrorCard()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: _buildContent(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_period) {
      case _Period.day:
        return _DayView(steps: _todaySteps, goal: _goal);
      case _Period.week:
        return _WeekView(data: _weekData, goal: _goal);
      case _Period.month:
        return _MonthView(data: _monthData, goal: _goal);
      case _Period.total:
        return _TotalView(
          totalSteps: _totalSteps,
          activeDays: _activeDays,
          weekData: _weekData,
        );
    }
  }
}

// ─── セグメントセレクター ───
class _SegmentedSelector extends StatelessWidget {
  final _Period selected;
  final ValueChanged<_Period> onChanged;

  const _SegmentedSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const items = [
      (_Period.day, '今日'),
      (_Period.week, '週'),
      (_Period.month, '月'),
      (_Period.total, '累計'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: items.map((item) {
          final isSelected = selected == item.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFB300)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  item.$2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? const Color(0xFF0F1923)
                        : Colors.white54,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── 日ビュー ───
class _DayView extends StatelessWidget {
  final int steps;
  final int goal;
  const _DayView({required this.steps, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);
    final km = (steps * 0.75 / 1000).toStringAsFixed(2);
    final kcal = (steps * 0.04).toStringAsFixed(0);
    final now = DateTime.now();
    const wd = ['月','火','水','木','金','土','日'];
    final today = '${now.month}月${now.day}日（${wd[now.weekday - 1]}）';

    return Column(
      children: [
        Text(today,
            style: GoogleFonts.notoSerif(
                fontSize: 13, color: Colors.white54)),
        const SizedBox(height: 16),
        _RingProgress(steps: steps, progress: progress, goal: goal),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _StatCard(emoji: '📏', label: '距離', value: '$km km')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(emoji: '🔥', label: 'カロリー', value: '$kcal kcal')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(emoji: '🎯', label: '目標まで',
                value: steps >= goal ? '達成！' : '${_fmtNum(goal - steps)}歩')),
          ],
        ),
        if (progress >= 1.0) ...[
          const SizedBox(height: 16),
          _AchieveBanner(),
        ],
      ],
    );
  }
}

// ─── 週ビュー ───
class _WeekView extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int goal;
  const _WeekView({required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart();
    final weekTotal = data.fold<int>(0, (s, r) => s + (r['steps'] as int));
    final goalDays = data.where((r) => (r['steps'] as int) >= goal).length;

    return Column(
      children: [
        _PeriodSummary(
          label: '今週の合計',
          steps: weekTotal,
          sub: '目標達成: $goalDays日',
        ),
        const SizedBox(height: 16),
        _BarChart(
          data: data.reversed.toList(),
          goal: goal,
          labelBuilder: (r) {
            final dt = DateTime.parse(r['date'] as String);
            const wd = ['月','火','水','木','金','土','日'];
            return wd[dt.weekday - 1];
          },
        ),
      ],
    );
  }
}

// ─── 月ビュー ───
class _MonthView extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int goal;
  const _MonthView({required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart();
    final monthTotal = data.fold<int>(0, (s, r) => s + (r['steps'] as int));
    final goalDays = data.where((r) => (r['steps'] as int) >= goal).length;
    final now = DateTime.now();
    final monthLabel = '${now.year}年${now.month}月';

    // 週ごとに集計
    final weekAgg = <Map<String, dynamic>>[];
    for (int w = 0; w < 5; w++) {
      final start = w * 7 + 1;
      final end = ((w + 1) * 7).clamp(0, data.length);
      if (start > data.length) break;
      final slice = data.sublist(start - 1, end);
      final total = slice.fold<int>(0, (s, r) => s + (r['steps'] as int));
      weekAgg.add({'label': '第${w + 1}週', 'steps': total});
    }

    return Column(
      children: [
        Text(monthLabel,
            style: GoogleFonts.notoSerif(fontSize: 13, color: Colors.white54)),
        const SizedBox(height: 8),
        _PeriodSummary(
          label: '今月の合計',
          steps: monthTotal,
          sub: '目標達成: $goalDays日',
        ),
        const SizedBox(height: 16),
        _BarChart(
          data: weekAgg,
          goal: goal * 7,
          labelBuilder: (r) => r['label'] as String,
        ),
        const SizedBox(height: 16),
        _MonthCalendar(data: data, goal: goal),
      ],
    );
  }
}

// ─── 累計ビュー ───
class _TotalView extends StatelessWidget {
  final int totalSteps;
  final int activeDays;
  final List<Map<String, dynamic>> weekData;

  const _TotalView({
    required this.totalSteps,
    required this.activeDays,
    required this.weekData,
  });

  @override
  Widget build(BuildContext context) {
    final km = (totalSteps * 0.75 / 1000).toStringAsFixed(1);
    final kcal = (totalSteps * 0.04).toStringAsFixed(0);
    final avgPerDay = activeDays > 0
        ? _fmtNum(totalSteps ~/ activeDays)
        : '0';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A5F), Color(0xFF0D2137)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFFFFB300).withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              const Text('👣', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(_fmtNum(totalSteps),
                  style: GoogleFonts.notoSerif(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text('歩 累計',
                  style: GoogleFonts.notoSerif(
                      fontSize: 14, color: const Color(0xFFFFB300))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _StatCard(emoji: '📏', label: '総距離', value: '$km km')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(emoji: '🔥', label: '総カロリー', value: '$kcal kcal')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _StatCard(emoji: '📅', label: '記録日数', value: '$activeDays 日')),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(emoji: '📊', label: '1日平均', value: '$avgPerDay 歩')),
          ],
        ),
        const SizedBox(height: 16),
        _MilestoneCard(steps: totalSteps),
      ],
    );
  }
}

// ─── 共通ウィジェット ───

class _RingProgress extends StatelessWidget {
  final int steps;
  final double progress;
  final int goal;
  const _RingProgress(
      {required this.steps, required this.progress, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor:
                        const Color(0xFFFFB300).withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFFB300)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _fmtNum(steps),
                      style: GoogleFonts.notoSerif(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    Text('歩',
                        style: GoogleFonts.notoSerif(
                            fontSize: 16, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '目標: ${_fmtNum(goal)}歩  (${(progress * 100).toStringAsFixed(0)}%)',
            style: GoogleFonts.notoSerif(
                fontSize: 13, color: const Color(0xFFFFB300)),
          ),
        ],
      ),
    );
  }
}

class _PeriodSummary extends StatelessWidget {
  final String label;
  final int steps;
  final String sub;
  const _PeriodSummary(
      {required this.label, required this.steps, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('👣', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.notoSerif(
                      fontSize: 11, color: Colors.white54)),
              Text(_fmtNum(steps),
                  style: GoogleFonts.notoSerif(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text(sub,
                  style: GoogleFonts.notoSerif(
                      fontSize: 11, color: const Color(0xFFFFB300))),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int goal;
  final String Function(Map<String, dynamic>) labelBuilder;

  const _BarChart(
      {required this.data, required this.goal, required this.labelBuilder});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _EmptyChart();
    final maxSteps = data.fold<int>(
        goal, (m, r) => (r['steps'] as int) > m ? r['steps'] as int : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: data.map((r) {
            final steps = r['steps'] as int;
            final ratio = maxSteps > 0 ? steps / maxSteps : 0.0;
            final reached = steps >= goal;
            final label = labelBuilder(r);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (steps > 0)
                      Text(
                        _shortNum(steps),
                        style: GoogleFonts.notoSerif(
                            fontSize: 8, color: Colors.white54),
                      ),
                    const SizedBox(height: 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: (110 * ratio).clamp(4.0, 110.0),
                      decoration: BoxDecoration(
                        color: reached
                            ? const Color(0xFFFFB300)
                            : const Color(0xFF4FC3F7).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(label,
                        style: GoogleFonts.notoSerif(
                            fontSize: 9, color: Colors.white54)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _shortNum(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _MonthCalendar extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int goal;
  const _MonthCalendar({required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('日別ヒートマップ',
              style: GoogleFonts.notoSerif(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFB300))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: data.map((r) {
              final steps = r['steps'] as int;
              final date = r['date'] as String;
              final day = int.parse(date.substring(8));
              final ratio = steps > 0 ? (steps / goal).clamp(0.1, 1.0) : 0.0;
              final reached = steps >= goal;

              return Tooltip(
                message: '$day日: ${_fmtNum(steps)}歩',
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: steps == 0
                        ? Colors.white.withValues(alpha: 0.05)
                        : reached
                            ? const Color(0xFFFFB300).withValues(alpha: ratio)
                            : const Color(0xFF4FC3F7).withValues(alpha: ratio),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text('$day',
                        style: GoogleFonts.notoSerif(
                            fontSize: 9,
                            color: steps > 0 ? Colors.white : Colors.white24)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 12, height: 12,
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Text('目標達成', style: GoogleFonts.notoSerif(fontSize: 9, color: Colors.white54)),
              const SizedBox(width: 10),
              Container(width: 12, height: 12,
                  decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Text('記録あり', style: GoogleFonts.notoSerif(fontSize: 9, color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final int steps;
  const _MilestoneCard({required this.steps});

  static const _milestones = [
    (10000, '🌟', '一万歩の旅人'),
    (100000, '🗾', '十万歩の冒険者'),
    (500000, '🏃', '五十万歩の走者'),
    (1000000, '🏔️', '百万歩の登山家'),
    (5000000, '🦅', '五百万歩の鷹'),
    (10000000, '👑', '千万歩の覇者'),
  ];

  @override
  Widget build(BuildContext context) {
    final next = _milestones.firstWhere(
      (m) => steps < m.$1,
      orElse: () => _milestones.last,
    );
    final prev = _milestones.lastWhere(
      (m) => steps >= m.$1,
      orElse: () => (0, '🌱', 'スタート'),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('マイルストーン',
              style: GoogleFonts.notoSerif(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFB300))),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(prev.$2, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('現在: ${prev.$3}',
                        style: GoogleFonts.notoSerif(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    if (steps < next.$1) ...[
                      const SizedBox(height: 4),
                      Text(
                        '次: ${next.$3}まで あと${_fmtNum(next.$1 - steps)}歩',
                        style: GoogleFonts.notoSerif(
                            fontSize: 11, color: Colors.white54),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: steps / next.$1,
                          minHeight: 6,
                          backgroundColor:
                              const Color(0xFFFFB300).withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFFB300)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _StatCard({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.notoSerif(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              textAlign: TextAlign.center),
          Text(label,
              style: GoogleFonts.notoSerif(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}

class _AchieveBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('🎉 本日の目標達成！おめでとうございます！',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white)),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('まだ記録がありません',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(fontSize: 13, color: Colors.white38)),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👣', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('歩数センサーを利用できません',
                style: GoogleFonts.notoSerif(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              '設定からモーションと体力トレーニングの\nアクセスを許可してください。',
              style: GoogleFonts.notoSerif(
                  fontSize: 12, color: Colors.white54, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
