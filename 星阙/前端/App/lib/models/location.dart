class Location {
  String? parent;
  String? address;
  String? distance;
  String? pcode;
  String? adcode;
  String? pname;
  String? cityname;
  String? type;
  String? typecode;
  String? adname;
  String? citycode;
  String? name;
  double? longitude;
  double? latitude;
  String? id;

  Location({
    this.parent,
    this.address,
    this.distance,
    this.pcode,
    this.adcode,
    this.pname,
    this.cityname,
    this.type,
    this.typecode,
    this.adname,
    this.citycode,
    this.name,
    this.longitude,
    this.latitude,
    this.id,
  });

  // Factory method to create an instance from a Map
  factory Location.fromJson(Map<String, dynamic> json) {
    List<String> location = json['location']?.split(',') ?? [];
    double? longitude = location.isNotEmpty ? double.tryParse(location[0]) : null;
    double? latitude = location.length > 1 ? double.tryParse(location[1]) : null;

    return Location(
      parent: json['parent'] as String?,
      address: json['address'] as String?,
      distance: json['distance'] as String?,
      pcode: json['pcode'] as String?,
      adcode: json['adcode'] as String?,
      pname: json['pname'] as String?,
      cityname: json['cityname'] as String?,
      type: json['type'] as String?,
      typecode: json['typecode'] as String?,
      adname: json['adname'] as String?,
      citycode: json['citycode'] as String?,
      name: json['name'] as String?,
      longitude: longitude,
      latitude: latitude,
      id: json['id'] as String?,
    );
  }

  // Method to convert the instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'parent': parent,
      'address': address,
      'distance': distance,
      'pcode': pcode,
      'adcode': adcode,
      'pname': pname,
      'cityname': cityname,
      'type': type,
      'typecode': typecode,
      'adname': adname,
      'citycode': citycode,
      'name': name,
      'location': longitude != null && latitude != null
          ? '$longitude,$latitude'
          : null,
      'id': id,
    };
  }
}
