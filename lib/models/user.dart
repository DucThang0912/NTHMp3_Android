import 'base_model.dart';
import 'role.dart';

class User extends BaseModel {
  String? username;
  String? password;
  String? fullName;
  String? email;
  String? avatar;
  String? phone;
  String? location;
  Role? role;

  User({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.username,
    this.password,
    this.fullName,
    this.email,
    this.avatar,
    this.phone,
    this.location,
    this.role,
  });

  User.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    username = json['username'];
    password = json['password'];
    fullName = json['fullName'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
    location = json['location'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['username'] = username;
    data['password'] = password;
    data['fullName'] = fullName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['location'] = location;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}
