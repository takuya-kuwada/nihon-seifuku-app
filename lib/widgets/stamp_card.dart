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
                  style: GoogleFonts.notoSerif(
                    fontSize: 9,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dateStr,
                    style: GoogleFonts.notoSerif(
                        fontSize: 9, color: Colors.white70),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('NEW',
                    style: GoogleFonts.notoSerif(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
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
    final specialty = info?.specialty ?? '';

    return Container(
      decoration: BoxDecoration(
        gradient: isUnlocked
            ? LinearGradient(
                colors: [
                  color.withValues(alpha: 0.9),
                  color.withValues(alpha: 0.6)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isUnlocked ? null : const Color(0xFF2A2A3A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white12,
          width: 1.5,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isUnlocked ? emoji : '🔒',
              style: TextStyle(
                  fontSize: 28,
                  color: isUnlocked ? null : Colors.white24),
            ),
            const SizedBox(height: 6),
            Text(
              prefecture,
              style: GoogleFonts.notoSerif(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? Colors.white : Colors.white38,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 2),
              Text(
                specialty,
                style: GoogleFonts.notoSerif(
                    fontSize: 9, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$visitedCount市区町村',
                style: GoogleFonts.notoSerif(
                  fontSize: 9,
                  color: isUnlocked ? Colors.white70 : Colors.white24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
