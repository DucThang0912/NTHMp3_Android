import 'base_model.dart';
import 'artist.dart';
import 'song.dart';

class Album extends BaseModel {
  String? title;
  Artist? artist;
  int? releaseYear;
  String? coverImageUrl;
  List<Song>? songs;

  Album({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.title,
    this.artist,
    this.releaseYear,
    this.coverImageUrl,
    this.songs,
  });

  Album.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
    releaseYear = json['releaseYear'];
    coverImageUrl = json['coverImageUrl'];
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
    data['title'] = title;
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    data['releaseYear'] = releaseYear;
    data['coverImageUrl'] = coverImageUrl;
    if (songs != null) {
      data['songs'] = songs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
