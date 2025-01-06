import 'base_model.dart';
import 'user.dart';

class Role extends BaseModel {
  String? name;
  List<User>? users;

  Role({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.name,
    this.users,
  });

  Role.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['name'];
    if (json['users'] != null) {
      users = <User>[];
      json['users'].forEach((v) {
        users!.add(User.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
