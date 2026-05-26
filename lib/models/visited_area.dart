class VisitedArea {
  final int? id;
  final String prefecture;
  final String municipality;
  final double latitude;
  final double longitude;
  final DateTime visitedAt;

  const VisitedArea({
    this.id,
    required this.prefecture,
    required this.municipality,
    required this.latitude,
    required this.longitude,
    required this.visitedAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'prefecture': prefecture,
        'municipality': municipality,
        'latitude': latitude,
        'longitude': longitude,
        'visited_at': visitedAt.toIso8601String(),
      };

  factory VisitedArea.fromMap(Map<String, dynamic> m) => VisitedArea(
        id: m['id'] as int?,
        prefecture: m['prefecture'] as String,
        municipality: m['municipality'] as String,
        latitude: m['latitude'] as double,
        longitude: m['longitude'] as double,
        visitedAt: DateTime.parse(m['visited_at'] as String),
      );
}
