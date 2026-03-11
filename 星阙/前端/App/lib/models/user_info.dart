class UserInfo {
  int? id;
  String avatar;
  String name;
  int sex;
  String birthday;
  int residenceProvinceId;
  int residenceCityId;
  int residenceDistrictId;
  int birthProvinceId;
  int birthCityId;
  int birthDistrictId;
  String? wxOpenid;
  String? wxUnionid;

  UserInfo({
    this.id,
    required this.avatar,
    required this.name,
    required this.sex,
    required this.birthday,
    required this.residenceProvinceId,
    required this.residenceCityId,
    required this.residenceDistrictId,
    required this.birthProvinceId,
    required this.birthCityId,
    required this.birthDistrictId,
    this.wxOpenid,
    this.wxUnionid,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
      sex: json['sex'],
      birthday: json['birthday'],
      residenceProvinceId: json['residence_province_id'],
      residenceCityId: json['residence_city_id'],
      residenceDistrictId: json['residence_district_id'],
      birthProvinceId: json['birth_province_id'],
      birthCityId: json['birth_city_id'],
      birthDistrictId: json['birth_district_id'],
      wxOpenid: json['wx_openid'],
      wxUnionid: json['wx_unionid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'sex': sex,
      'birthday': birthday,
      'residence_province_id': residenceProvinceId,
      'residence_city_id': residenceCityId,
      'residence_district_id': residenceDistrictId,
      'birth_province_id': birthProvinceId,
      'birth_city_id': birthCityId,
      'birth_district_id': birthDistrictId,
    };
  }
}

class Relation {
  int? id;
  int birthCityId;
  int birthDistrictId;
  int birthProvinceId;
  String birthday;
  String name;

  ///关系
  String relation;
  int residenceCityId;
  int residenceDistrictId;
  int residenceProvinceId;
  int sex;

  Relation({
    this.id,
    required this.birthCityId,
    required this.birthDistrictId,
    required this.birthProvinceId,
    required this.birthday,
    required this.name,
    required this.relation,
    required this.residenceCityId,
    required this.residenceDistrictId,
    required this.residenceProvinceId,
    required this.sex,
  });

  factory Relation.fromJson(Map<String, dynamic> json) {
    return Relation(
      id: json['id'],
      birthCityId: json['birth_city_id'],
      birthDistrictId: json['birth_district_id'],
      birthProvinceId: json['birth_province_id'],
      birthday: json['birthday'],
      name: json['name'],
      relation: json['relation'],
      residenceCityId: json['residence_city_id'],
      residenceDistrictId: json['residence_district_id'],
      residenceProvinceId: json['residence_province_id'],
      sex: json['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birth_city_id': birthCityId,
      'birth_district_id': birthDistrictId,
      'birth_province_id': birthProvinceId,
      'birthday': birthday,
      'name': name,
      'relation': relation,
      'residence_city_id': residenceCityId,
      'residence_district_id': residenceDistrictId,
      'residence_province_id': residenceProvinceId,
      'sex': sex,
    };
  }
}
