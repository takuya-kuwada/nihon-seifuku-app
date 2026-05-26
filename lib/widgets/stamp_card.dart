import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/prefecture_data.dart';
import '../models/visited_area.dart';

class StampCard extends StatelessWidget {
  final VisitedArea area;
  final bool isNew;

  const StampCard({super.key, required this.area, this.isNew = false});

  @override
  Widget build(BuildContext context) {
    final info = prefectureData[area.prefecture];
    final color = info?.color ?? const Color(0xFF455A64);
    final emoji = info?.stampEmoji ?? '📍';
    final dateStr = DateFormat('yyyy.MM.dd').format(area.visitedAt);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  area.municipality,
                  style: GoogleFonts.notoSerif(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  area.prefecture,
                  style: GoogleFonts.notoSerif(fontSize: 9, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dateStr,
                    style: GoogleFonts.notoSerif(fontSize: 9, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          if (isNew)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'NEW',
                  style: GoogleFonts.notoSerif(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PrefectureStampCard extends StatelessWidget {
  final String prefecture;
  final int visitedCount;
  final bool isUnlocked;

  const PrefectureStampCard({
    super.key,
    required this.prefecture,
    required this.visitedCount,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final info = prefectureData[prefecture];
    final color = info?.color ?? const Color(0xFF455A64);
    final emoji = info?.stampEmoji ?? '📍';
    final cardNum = prefectureData.keys.toList().indexOf(prefecture) + 1;

    if (!isUnlocked) {
      return _LockedCard(prefecture: prefecture, cardNum: cardNum);
    }

    return _UnlockedCard(
      prefecture: prefecture,
      info: info!,
      emoji: emoji,
      color: color,
      cardNum: cardNum,
    );
  }
}

class _LockedCard extends StatelessWidget {
  final String prefecture;
  final int cardNum;
  const _LockedCard({required this.prefecture, required this.cardNum});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF15151F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔒', style: TextStyle(fontSize: 22, color: Colors.white24)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              prefecture,
              style: GoogleFonts.notoSerif(fontSize: 8, color: Colors.white24),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$cardNum/47',
            style: GoogleFonts.notoSerif(fontSize: 7, color: Colors.white12),
          ),
        ],
      ),
    );
  }
}

class _UnlockedCard extends StatelessWidget {
  final String prefecture;
  final PrefectureInfo info;
  final String emoji;
  final Color color;
  final int cardNum;

  const _UnlockedCard({
    required this.prefecture,
    required this.info,
    required this.emoji,
    required this.color,
    required this.cardNum,
  });

  @override
  Widget build(BuildContext context) {
    final assetName = info.englishName.toLowerCase();
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFF9C4),
            Color(0xFFFFD700),
            Color(0xFFDAA520),
            Color(0xFFFFF8DC),
            Color(0xFFDAA520),
          ],
          stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              prefecture: prefecture,
              englishName: info.englishName,
              cardNum: cardNum,
            ),
            Expanded(child: _CardArt(emoji: emoji, color: color, assetName: assetName)),
            _CardInfo(
              specialty: info.specialty,
              specialMove: info.specialMove,
              cardNum: cardNum,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String prefecture;
  final String englishName;
  final int cardNum;
  const _CardHeader({
    required this.prefecture,
    required this.englishName,
    required this.cardNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 5, 4),
      color: const Color(0xFF1A1A3A),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  prefecture,
                  style: GoogleFonts.notoSerif(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  englishName,
                  style: GoogleFonts.notoSerif(
                    fontSize: 6,
                    color: const Color(0xFFFFD700),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFFD700), width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$cardNum/47',
              style: GoogleFonts.notoSerif(
                fontSize: 6,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFD700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardArt extends StatelessWidget {
  final String emoji;
  final Color color;
  final String assetName;
  const _CardArt({required this.emoji, required this.color, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.75), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -8, left: -8,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -10, right: -10,
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // 画像があれば表示、なければ絵文字フォールバック
          Positioned.fill(
            child: Image.asset(
              'assets/cards/$assetName.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Center(
                child: Text(emoji, style: const TextStyle(fontSize: 38)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final String specialty;
  final String specialMove;
  final int cardNum;
  const _CardInfo({
    required this.specialty,
    required this.specialMove,
    required this.cardNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 6, 4),
      color: const Color(0xFFFAF8F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoLine(label: '特産品', value: specialty),
          const SizedBox(height: 2),
          _InfoLine(label: '必殺技', value: specialMove),
          const SizedBox(height: 4),
          Center(
            child: Text(
              '$cardNum/47',
              style: GoogleFonts.notoSerif(
                fontSize: 7,
                color: Colors.black38,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: GoogleFonts.notoSerif(
              fontSize: 6.5,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.notoSerif(
              fontSize: 6.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
