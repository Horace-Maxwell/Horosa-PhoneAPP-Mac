import 'dart:convert';
import 'timezone.dart';

class Country {
  final int id;
  final String name;
  final String iso3;
  final int numericCode;
  final String iso2;
  final String phoneCode;
  final String capital;
  final String currency;
  final String currencyName;
  final String currencySymbol;
  final String tld;
  final String nativeName;
  final String cnName;
  final String region;
  final double regionId;
  final String subregion;
  final double subregionId;
  final String nationality;
  final List<TimeZone> timezones;
  final double latitude;
  final double longitude;
  final String emoji;
  final String emojiU;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int flag;
  final String wikiDataId;
  final String defaultTimezone;

  Country({
    required this.id,
    required this.name,
    required this.iso3,
    required this.numericCode,
    required this.iso2,
    required this.phoneCode,
    required this.capital,
    required this.currency,
    required this.currencyName,
    required this.currencySymbol,
    required this.tld,
    required this.nativeName,
    required this.cnName,
    required this.region,
    required this.regionId,
    required this.subregion,
    required this.subregionId,
    required this.nationality,
    required this.timezones,
    required this.latitude,
    required this.longitude,
    required this.emoji,
    required this.emojiU,
    required this.createdAt,
    required this.updatedAt,
    required this.flag,
    required this.wikiDataId,
    required this.defaultTimezone,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'] ?? '',
      iso3: json['iso3'] ?? '',
      numericCode: json['numeric_code'] ?? 0,
      iso2: json['iso2'] ?? '',
      phoneCode: json['phonecode'] ?? '',
      capital: json['capital'] ?? '',
      currency: json['currency'] ?? '',
      currencyName: json['currency_name'] ?? '',
      currencySymbol: json['currency_symbol'] ?? '',
      tld: json['tld'] ?? '',
      nativeName: json['native'] ?? '',
      cnName: json['cn_name'] ?? '',
      region: json['region'] ?? '',
      regionId: (json['region_id'] ?? 0).toDouble(),
      subregion: json['subregion'] ?? '',
      subregionId: (json['subregion_id'] ?? 0).toDouble(),
      nationality: json['nationality'] ?? '',
      timezones: jsonDecode(json['timezones']) is List
          ? (jsonDecode(json['timezones']) as List<dynamic>).map((e) => TimeZone.fromJson(e)).toList()
          : [],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      emoji: json['emoji'] ?? '',
      emojiU: json['emojiU'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updated_at'] ?? '1970-01-01T00:00:00Z'),
      flag: json['flag'] ?? 0,
      wikiDataId: json['wikiDataId'] ?? '',
      defaultTimezone: json['default_timezone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iso3': iso3,
      'numeric_code': numericCode,
      'iso2': iso2,
      'phonecode': phoneCode,
      'capital': capital,
      'currency': currency,
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'tld': tld,
      'native': nativeName,
      'cn_name': cnName,
      'region': region,
      'region_id': regionId,
      'subregion': subregion,
      'subregion_id': subregionId,
      'nationality': nationality,
      'timezones': timezones.map((e) => e.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'emoji': emoji,
      'emojiU': emojiU,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'flag': flag,
      'wikiDataId': wikiDataId,
      'default_timezone': defaultTimezone,
    };
  }
}