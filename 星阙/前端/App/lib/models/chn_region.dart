class CHNRegion {
  int adcode;
  String name;
  String abbr;
  double lng;
  double lat;
  List<CHNRegion> children;

  CHNRegion({
    required this.adcode,
    required this.name,
    required this.abbr,
    required this.lng,
    required this.lat,
    required this.children,
  });

  // 从JSON转换为Location对象
  factory CHNRegion.fromJson(Map<String, dynamic> json) {
    return CHNRegion(
      adcode: json['adcode'],
      name: json['name'],
      abbr: json['abbr'],
      lng: json['lng'],
      lat: json['lat'],
      children: (json['children'] as List)
          .map((child) => CHNRegion.fromJson(child))
          .toList(),
    );
  }

  // 将Location对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'adcode': adcode,
      'name': name,
      'abbr': abbr,
      'lng': lng,
      'lat': lat,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}
