import 'dart:convert';
import 'base_model.dart';
import 'user.dart';

class Playlist extends BaseModel {
  String? name;
  String? description;
  bool? isPublic;
  dynamic user;

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
    name = _decodeUtf8(json['name']);
    description = _decodeUtf8(json['description']);
    isPublic = json['public'];
    user = json['user'];
  }

  String? _decodeUtf8(dynamic text) {
    if (text == null) return null;
    try {
      return utf8.decode(latin1.encode(text.toString()));
    } catch (e) {
      return text.toString();
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    data['description'] = description;
    data['public'] = isPublic;
    data['user'] = user;
    return data;
  }
}
