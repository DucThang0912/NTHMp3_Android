import 'base_model.dart';
import 'user.dart';

class Playlist extends BaseModel {
  String? name;
  String? description;
  bool? isPublic;
  User? user;

  Playlist({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.name,
    this.description,
    this.isPublic,
    this.user,
  });

  Playlist.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['name'];
    description = json['description'];
    isPublic = json['isPublic'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    data['description'] = description;
    data['isPublic'] = isPublic;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}