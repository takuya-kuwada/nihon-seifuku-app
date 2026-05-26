import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';
import '../models/visited_area.dart';
import '../data/prefecture_data.dart';
import '../widgets/stamp_card.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with SingleTickerProviderStateMixin {
  final _db = DatabaseService.instance;
  late final TabController _tabController;

  List<VisitedArea> _municipalityStamps = [];
  Map<String, int> _prefCounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final visited = await _db.getAllVisited();
    final counts = await _db.getPrefectureVisitCounts();
    if (mounted) {
      setState(() {
        _municipalityStamps = visited;
        _prefCounts = counts;
        _loading = false;
      });
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text('⭐',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text('スタンプコレクション',
                      style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFB300))),
                ],
              ),
            ),
            // タブ
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D3D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: const Color(0xFF0F1923),
                unselectedLabelColor: Colors.white54,
                labelStyle: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.w700, fontSize: 13),
                tabs: [
                  Tab(text: '市区町村 ${_municipalityStamps.length}'),
                  Tab(text: '都道府県 ${_prefCounts.length}/47'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFFFB300)))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _MunicipalityTab(stamps: _municipalityStamps),
                        _PrefectureTab(counts: _prefCounts),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MunicipalityTab extends StatelessWidget {
  final List<VisitedArea> stamps;
  const _MunicipalityTab({required this.stamps});

  @override
  Widget build(BuildContext context) {
    if (stamps.isEmpty) {
      return _EmptyState(
        emoji: '🗺️',
        message: 'まだ市区町村を訪れていません。\n外に出かけてスタンプを集めよう！',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: stamps.length,
      itemBuilder: (_, i) => StampCard(area: stamps[i]),
    );
  }
}

class _PrefectureTab extends StatelessWidget {
  final Map<String, int> counts;
  const _PrefectureTab({required this.counts});

  @override
  Widget build(BuildContext context) {
    final allPrefectures = prefectureData.keys.toList();
    if (counts.isEmpty) {
      return _EmptyState(
        emoji: '🏯',
        message: '都道府県スタンプはまだありません。\n各都道府県を訪れて解放しよう！',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: allPrefectures.length,
      itemBuilder: (_, i) {
        final pref = allPrefectures[i];
        final count = counts[pref] ?? 0;
        return PrefectureStampCard(
          prefecture: pref,
          visitedCount: count,
          isUnlocked: count > 0,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String message;
  const _EmptyState({required this.emoji, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.notoSerif(
                fontSize: 14, color: Colors.white54, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
