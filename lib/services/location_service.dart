import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../data/prefecture_data.dart';
import '../models/visited_area.dart';
import 'database_service.dart';

class LocationResult {
  final String prefecture;
  final String municipality;
  final double lat;
  final double lng;
  final bool isNew;

  const LocationResult({
    required this.prefecture,
    required this.municipality,
    required this.lat,
    required this.lng,
    required this.isNew,
  });
}

class LocationService {
  LocationService._();
  static final instance = LocationService._();

  final _db = DatabaseService.instance;

  Stream<Position>? _positionStream;
  String? _lastMunicipality;
  DateTime? _lastGeocodeTime;

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Stream<Position> startTracking() {
    _positionStream ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 150,
      ),
    );
    return _positionStream!;
  }

  Future<LocationResult?> checkAndSaveLocation(Position pos) async {
    final now = DateTime.now();
    if (_lastGeocodeTime != null &&
        now.difference(_lastGeocodeTime!).inSeconds < 5) {
      return null;
    }
    _lastGeocodeTime = now;

    final addr = await _reverseGeocode(pos.latitude, pos.longitude);
    if (addr == null) return null;

    final prefecture = addr['prefecture'];
    final municipality = addr['municipality'];
    if (prefecture == null || municipality == null) return null;
    if (municipality == _lastMunicipality) return null;

    _lastMunicipality = municipality;

    final alreadyVisited = await _db.isVisited(prefecture, municipality);
    if (!alreadyVisited) {
      await _db.addVisitedArea(VisitedArea(
        prefecture: prefecture,
        municipality: municipality,
        latitude: pos.latitude,
        longitude: pos.longitude,
        visitedAt: now,
      ));
    }

    return LocationResult(
      prefecture: prefecture,
      municipality: municipality,
      lat: pos.latitude,
      lng: pos.longitude,
      isNew: !alreadyVisited,
    );
  }

  Future<Map<String, String>?> _reverseGeocode(double lat, double lng) async {
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&accept-language=ja');
      final res = await http.get(uri, headers: {
        'User-Agent': 'NihonSeifukuApp/1.0',
      }).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>?;
      if (address == null) return null;

      final rawPref = address['state'] as String? ?? '';
      final prefecture = normalizePrefecture(rawPref);

      String? municipality;
      final cityDistrict = address['city_district'] as String?;
      final city = address['city'] as String?;
      final town = address['town'] as String?;
      final village = address['village'] as String?;
      final county = address['county'] as String?;

      if (cityDistrict != null) {
        municipality = cityDistrict;
      } else if (city != null && !_isPrefectureName(city)) {
        municipality = city;
      } else if (town != null) {
        municipality = town;
      } else if (village != null) {
        municipality = village;
      } else if (county != null) {
        municipality = county;
      }

      if (municipality == null || prefecture.isEmpty) return null;
      return {'prefecture': prefecture, 'municipality': municipality};
    } catch (_) {
      return null;
    }
  }

  bool _isPrefectureName(String name) {
    return name.endsWith('都') ||
        name.endsWith('道') ||
        name.endsWith('府') ||
        name.endsWith('県');
  }
}
