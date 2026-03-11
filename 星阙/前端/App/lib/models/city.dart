class City {
  final int id;
  final String name;
  final int stateId;
  final String stateCode;
  final int countryId;
  final String countryCode;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int flag;
  final String wikiDataId;

  City({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateCode,
    required this.countryId,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.flag,
    required this.wikiDataId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
      stateCode: json['state_code'],
      countryId: json['country_id'],
      countryCode: json['country_code'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      flag: json['flag'],
      wikiDataId: json['wikiDataId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state_id': stateId,
      'state_code': stateCode,
      'country_id': countryId,
      'country_code': countryCode,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'flag': flag,
      'wikiDataId': wikiDataId,
    };
  }
}
