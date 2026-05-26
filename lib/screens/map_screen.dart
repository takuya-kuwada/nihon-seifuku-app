import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/location_service.dart';
import '../services/database_service.dart';
import '../models/visited_area.dart';
import '../data/prefecture_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _locationService = LocationService.instance;
  final _db = DatabaseService.instance;
  final _mapController = MapController();

  Position? _currentPosition;
  List<VisitedArea> _visited = [];
  String? _newAreaName;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _visited = await _db.getAllVisited();
    setState(() {});
    _startTracking();
  }

  Future<void> _startTracking() async {
    final granted = await _locationService.requestPermission();
    if (!granted) {
      setState(() => _permissionDenied = true);
      return;
    }


    final pos = await _locationService.getCurrentPosition();
    if (pos != null && mounted) {
      setState(() => _currentPosition = pos);
      _mapController.move(LatLng(pos.latitude, pos.longitude), 12);
    }

    _locationService.startTracking().listen((position) async {
      if (!mounted) return;
      setState(() => _currentPosition = position);

      final result = await _locationService.checkAndSaveLocation(position);
      if (result != null && mounted) {
        _visited = await _db.getAllVisited();
        setState(() {
          if (result.isNew) _newAreaName = result.municipality;
        });
        if (result.isNew) {
          Future.delayed(const Duration(seconds: 4),
              () => mounted ? setState(() => _newAreaName = null) : null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(36.2048, 138.2529),
              initialZoom: 5.5,
              minZoom: 3,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.nihon_seifuku',
              ),
              CircleLayer(
                circles: _visited.map((a) {
                  final info = prefectureData[a.prefecture];
                  final color = info?.color ?? const Color(0xFF4CAF50);
                  return CircleMarker(
                    point: LatLng(a.latitude, a.longitude),
                    radius: 18,
                    color: color.withValues(alpha: 0.5),
                    borderColor: color,
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 40,
                      height: 40,
                      child: _PulsingDot(),
                    ),
                  ],
                ),
            ],
          ),
          // ヘッダー
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F1923).withValues(alpha: 0.95),
                    const Color(0xFF0F1923).withValues(alpha: 0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Text('🗾',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ニッポン制覇',
                          style: GoogleFonts.notoSerif(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFB300))),
                      Text('${_visited.length}市区町村 制覇済み',
                          style: GoogleFonts.notoSerif(
                              fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 新エリア解放通知
          if (_newAreaName != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 72,
              left: 16,
              right: 16,
              child: _NewAreaBanner(areaName: _newAreaName!),
            ),
          // 権限エラー
          if (_permissionDenied)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '📍 位置情報の許可が必要です。設定から許可してください。',
                  style: GoogleFonts.notoSerif(
                      fontSize: 13, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // 現在地ボタン
          Positioned(
            right: 16,
            bottom: 24,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF1E3A5F),
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController.move(
                    LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    14,
                  );
                }
              },
              child: const Icon(Icons.my_location,
                  color: Color(0xFFFFB300)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(seconds: 1), vsync: this)
      ..repeat(reverse: true);
    _scale = Tween(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF4FC3F7),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF4FC3F7).withValues(alpha: 0.6),
                  blurRadius: 8)
            ],
          ),
        ),
      ),
    );
  }
}

class _NewAreaBanner extends StatelessWidget {
  final String areaName;
  const _NewAreaBanner({required this.areaName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('新エリア解放！',
                    style: GoogleFonts.notoSerif(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70)),
                Text(areaName,
                    style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ],
            ),
          ),
          const Text('⭐', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
