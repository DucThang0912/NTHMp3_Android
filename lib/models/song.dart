import 'album.dart';
import 'artist.dart';
import 'base_model.dart';
import 'genre.dart';

class Song extends BaseModel {
  late String title;
  late Artist artist;
  Album? album;
  late Genre genre;
  late int duration;
  late String filePath;
  String? lyrics;
  int? playCount;

  Song({
    super.id,
    super.createdDate,
    super.updatedDate,
    required this.title,
    required this.artist,
    this.album,
    required this.genre,
    required this.duration,
    required this.filePath,
    this.lyrics,
    this.playCount,
  });

  Song.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    artist = Artist.fromJson(json['artist']);
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    genre = Genre.fromJson(json['genre']);
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
