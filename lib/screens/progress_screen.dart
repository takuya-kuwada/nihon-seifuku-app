import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';
import '../data/prefecture_data.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, this.refreshTrigger = 0});
  final int refreshTrigger;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _db = DatabaseService.instance;

  int _totalVisited = 0;
  Map<String, int> _prefCounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ProgressScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshTrigger != oldWidget.refreshTrigger) _load();
  }

  Future<void> _load() async {
    final total = await _db.getVisitedCount();
    final counts = await _db.getPrefectureVisitCounts();
    if (mounted) {
      setState(() {
        _totalVisited = total;
        _prefCounts = counts;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefVisited = _prefCounts.length;
    final overallPct = prefVisited / 47 * 100;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFFFB300)))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🏯',
                                  style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Text('制覇の進捗',
                                  style: GoogleFonts.notoSerif(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFFB300))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // サマリーカード
                          _SummaryCard(
                            totalVisited: _totalVisited,
                            prefVisited: prefVisited,
                            overallPct: overallPct,
                          ),
                          const SizedBox(height: 20),
                          // ランクバッジ
                          _RankBadge(prefVisited: prefVisited),
                          const SizedBox(height: 20),
                          Text('都道府県別の進捗',
                              style: GoogleFonts.notoSerif(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final pref = prefectureData.keys.toList()[i];
                        final count = _prefCounts[pref] ?? 0;
                        final info = prefectureData[pref]!;
                        return _PrefectureRow(
                          prefecture: pref,
                          count: count,
                          info: info,
                        );
                      },
                      childCount: prefectureData.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalVisited;
  final int prefVisited;
  final double overallPct;

  const _SummaryCard({
    required this.totalVisited,
    required this.prefVisited,
    required this.overallPct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BigStat(
                  value: '$totalVisited',
                  label: '市区町村制覇',
                  emoji: '📍'),
              Container(
                  width: 1,
                  height: 50,
                  color: Colors.white12),
              _BigStat(
                  value: '$prefVisited/47',
                  label: '都道府県制覇',
                  emoji: '🏯'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('全国制覇度',
                  style: GoogleFonts.notoSerif(
                      fontSize: 12, color: Colors.white70)),
              const Spacer(),
              Text('${overallPct.toStringAsFixed(1)}%',
                  style: GoogleFonts.notoSerif(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFFB300))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallPct / 100,
              minHeight: 8,
              backgroundColor:
                  const Color(0xFFFFB300).withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFFFB300)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;

  const _BigStat(
      {required this.value, required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.notoSerif(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.notoSerif(
                fontSize: 10, color: Colors.white54)),
      ],
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int prefVisited;
  const _RankBadge({required this.prefVisited});

  static const _ranks = [
    (0, '🌱', '旅立ちの冒険者', '旅を始めたばかり'),
    (5, '🗺️', '地図収集家', '5都道府県制覇'),
    (10, '⛩️', '街道を行く者', '10都道府県制覇'),
    (20, '🏔️', '風来坊', '20都道府県制覇'),
    (35, '🦅', '日本一周者', '35都道府県制覇'),
    (47, '👑', '全国制覇！', '日本完全制覇'),
  ];

  @override
  Widget build(BuildContext context) {
    final rank = _ranks.lastWhere((r) => prefVisited >= r.$1);
    final next = _ranks.firstWhere(
        (r) => r.$1 > prefVisited,
        orElse: () => _ranks.last);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(rank.$2, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('現在のランク',
                    style: GoogleFonts.notoSerif(
                        fontSize: 10, color: Colors.white54)),
                Text(rank.$3,
                    style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFB300))),
                Text(rank.$4,
                    style: GoogleFonts.notoSerif(
                        fontSize: 11, color: Colors.white70)),
                if (prefVisited < 47) ...[
                  const SizedBox(height: 4),
                  Text(
                    '次のランク: ${next.$3}（あと${next.$1 - prefVisited}都道府県）',
                    style: GoogleFonts.notoSerif(
                        fontSize: 10, color: Colors.white38),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrefectureRow extends StatelessWidget {
  final String prefecture;
  final int count;
  final PrefectureInfo info;

  const _PrefectureRow({
    required this.prefecture,
    required this.count,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    final visited = count > 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: visited
            ? info.color.withValues(alpha: 0.12)
            : const Color(0xFF1E2D3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: visited
              ? info.color.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Text(visited ? info.stampEmoji : '🔒',
              style: TextStyle(
                  fontSize: 20,
                  color: visited ? null : Colors.white24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prefecture,
                    style: GoogleFonts.notoSerif(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: visited ? Colors.white : Colors.white38)),
                if (visited)
                  Text(info.specialty,
                      style: GoogleFonts.notoSerif(
                          fontSize: 10, color: Colors.white54)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: visited
                  ? info.color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              visited ? '$count市区町村' : '未訪問',
              style: GoogleFonts.notoSerif(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: visited ? Colors.white : Colors.white24),
            ),
          ),
        ],
      ),
    );
  }
}
