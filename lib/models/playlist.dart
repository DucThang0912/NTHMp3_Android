import 'dart:convert';
import 'package:nthmusicmp3/models/song.dart';

import 'base_model.dart';
import 'user.dart';

class Playlist extends BaseModel {
  String? name;
  String? description;
  bool? isPublic;
  dynamic user;
  String? imageUrl;
  List<Song>? songs;
  String? username;

  Playlist({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.name,
    this.description,
    this.isPublic,
    this.user,
    this.imageUrl,
    this.songs,
    this.username,
  });

  Playlist.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = _decodeUtf8(json['name']);
    description = _decodeUtf8(json['description']);
    isPublic = json['public'];
    user = json['user'];
    imageUrl = json['imageUrl'];
    songs = json['songs'] != null
        ? (json['songs'] as List).map((s) => Song.fromJson(s)).toList()
        : null;
    username = json['username'];
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
    data['imageUrl'] = imageUrl;
    data['songs'] = songs;
    data['username'] = username;
    return data;
  }
}
