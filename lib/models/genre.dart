import 'base_model.dart';
import 'song.dart';

class Genre extends BaseModel {
  String? name;
  List<Song>? songs;

  Genre({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.name,
    this.songs,
  });

  Genre.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['name'];
    if (json['songs'] != null) {
      songs = <Song>[];
      json['songs'].forEach((v) {
        songs!.add(Song.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['name'] = name;
    if (songs != null) {
      data['songs'] = songs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}