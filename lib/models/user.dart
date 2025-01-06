import 'base_model.dart';
import 'role.dart';

class User extends BaseModel {
  late String username;
  late String password;
  String? fullName;
  late String email;
  String? avatar;
  String? phone;
  String? location;
  Role? role;

  User({
    super.id,
    super.createdDate,
    super.updatedDate,
    required this.username,
    required this.password,
    this.fullName,
    required this.email,
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
    if (json['role'] != null) {
      if (json['role'] is int) {
        role = Role(id: json['role']);
      } else if (json['role'] is Map) {
        role = Role.fromJson(json['role']);
      }
    }
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

  User copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
  }) {
    return User(
      id: id,
      username: username,
      password: password,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }
}
