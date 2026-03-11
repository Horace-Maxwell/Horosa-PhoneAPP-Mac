class TimeZone {
  final String zoneName;
  final int gmtOffset;
  final String gmtOffsetName;
  final String abbreviation;
  final String tzName;

  TimeZone({
    required this.zoneName,
    required this.gmtOffset,
    required this.gmtOffsetName,
    required this.abbreviation,
    required this.tzName,
  });

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone(
      zoneName: json['zoneName'],
      gmtOffset: json['gmtOffset'],
      gmtOffsetName: json['gmtOffsetName'],
      abbreviation: json['abbreviation'],
      tzName: json['tzName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoneName': zoneName,
      'gmtOffset': gmtOffset,
      'gmtOffsetName': gmtOffsetName,
      'abbreviation': abbreviation,
      'tzName': tzName,
    };
  }
}