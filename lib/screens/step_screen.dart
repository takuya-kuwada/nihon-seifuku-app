import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/step_service.dart';
import '../services/database_service.dart';

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  final _stepService = StepService.instance;
  final _db = DatabaseService.instance;

  int _todaySteps = 0;
  int _totalSteps = 0;
  List<Map<String, dynamic>> _weeklyData = [];
  bool _hasError = false;

  static const _goal = 8000;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _startCounting();
  }

  Future<void> _loadHistory() async {
    final weekly = await _db.getRecentSteps(7);
    final total = await _db.getTotalSteps();
    if (mounted) {
      setState(() {
        _weeklyData = weekly;
        _totalSteps = total;
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
            _loadHistory();
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
    final progress = (_todaySteps / _goal).clamp(0.0, 1.0);
    final km = (_todaySteps * 0.75 / 1000).toStringAsFixed(1);
    final kcal = (_todaySteps * 0.04).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text('🚶',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text('歩数カウンター',
                      style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFB300))),
                ],
              ),
              const SizedBox(height: 24),
              if (_hasError)
                _ErrorCard()
              else ...[
                // 今日の歩数リング
                _StepRing(steps: _todaySteps, progress: progress, goal: _goal),
                const SizedBox(height: 20),
                // 統計
                Row(
                  children: [
                    Expanded(
                        child: _StatCard(
                            emoji: '📏',
                            label: '距離',
                            value: '$km km')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatCard(
                            emoji: '🔥',
                            label: 'カロリー',
                            value: '$kcal kcal')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _StatCard(
                            emoji: '👣',
                            label: '累計',
                            value: '${NumberFormat('#,###').format(_totalSteps)}歩')),
                  ],
                ),
                const SizedBox(height: 24),
                // 週間グラフ
                _WeeklyChart(data: _weeklyData, goal: _goal),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRing extends StatelessWidget {
  final int steps;
  final double progress;
  final int goal;

  const _StepRing(
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
                      NumberFormat('#,###').format(steps),
                      style: GoogleFonts.notoSerif(
                          fontSize: 32,
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
          const SizedBox(height: 16),
          Text(
            '目標: ${NumberFormat('#,###').format(goal)}歩  (${(progress * 100).toStringAsFixed(0)}%)',
            style: GoogleFonts.notoSerif(
                fontSize: 13, color: const Color(0xFFFFB300)),
          ),
          if (progress >= 1.0) ...[
            const SizedBox(height: 8),
            Text('🎉 目標達成！',
                style: GoogleFonts.notoSerif(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatCard(
      {required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
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
              style: GoogleFonts.notoSerif(
                  fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int goal;

  const _WeeklyChart({required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxSteps =
        data.fold<int>(goal, (m, r) => (r['steps'] as int) > m ? r['steps'] as int : m);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('週間歩数',
              style: GoogleFonts.notoSerif(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFB300))),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.reversed.map((r) {
                final steps = r['steps'] as int;
                final date = r['date'] as String;
                final ratio = maxSteps > 0 ? steps / maxSteps : 0.0;
                final day = date.substring(8);
                final reached = steps >= goal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (100 * ratio).clamp(4.0, 100.0),
                          decoration: BoxDecoration(
                            color: reached
                                ? const Color(0xFFFFB300)
                                : const Color(0xFF4FC3F7)
                                    .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('$day日',
                            style: GoogleFonts.notoSerif(
                                fontSize: 9, color: Colors.white54)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
    );
  }
}
