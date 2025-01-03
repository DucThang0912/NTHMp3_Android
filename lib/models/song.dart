import 'album.dart';
import 'artist.dart';
import 'base_model.dart';
import 'genre.dart';

class Song extends BaseModel {
  String? title;
  Artist? artist;
  Album? album;
  Genre? genre;
  int? duration;
  String? filePath;
  String? lyrics;
  int? playCount;

  Song({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.duration,
    this.filePath,
    this.lyrics,
    this.playCount,
  });

  Song.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    genre = json['genre'] != null ? Genre.fromJson(json['genre']) : null;
    duration = json['duration'];
    filePath = json['filePath'];
    lyrics = json['lyrics'];
    playCount = json['playCount'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['title'] = title;
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    if (album != null) {
      data['album'] = album!.toJson();
    }
    if (genre != null) {
      data['genre'] = genre!.toJson();
    }
    data['duration'] = duration;
    data['filePath'] = filePath;
    data['lyrics'] = lyrics;
    data['playCount'] = playCount;
    return data;
  }
}