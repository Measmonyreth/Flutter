class UserResponse {
  User? user;

  UserResponse({this.user});

  UserResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? cityOrProvince;
  String? country;
  String? sex;
  String? emailVerifiedAt;
  String? avatar;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.cityOrProvince,
    this.country,
    this.sex,
    this.emailVerifiedAt,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    cityOrProvince = json['cityOrProvince'];
    country = json['country'];
    sex = json['sex'];
    emailVerifiedAt = json['email_verified_at'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['cityOrProvince'] = this.cityOrProvince;
    data['country'] = this.country;
    data['sex'] = this.sex;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['avatar'] = this.avatar;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
