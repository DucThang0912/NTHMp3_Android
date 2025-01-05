import 'album.dart';
import 'artist.dart';
import 'base_model.dart';
import 'genre.dart';

class Song extends BaseModel {
  late String title;
  late String artistName;
  late int artistId;
  String? albumTitle;
  int? albumId;
  late String genreName;
  late int genreId;
  late int duration;
  late String filePath;
  String? lyrics;
  int? playCount;

  Song({
    super.id,
    super.createdDate,
    super.updatedDate,
    required this.title,
    required this.artistName,
    required this.artistId,
    this.albumTitle,
    this.albumId,
    required this.genreName,
    required this.genreId,
    required this.duration,
    required this.filePath,
    this.lyrics,
    this.playCount,
  });

  Song.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    artistName = json['artistName'];
    artistId = json['artistId'];
    albumTitle = json['albumTitle'];
    albumId = json['albumId'];
    genreName = json['genreName'];
    genreId = json['genreId'];
    duration = json['duration'];
    filePath = json['filePath'];
    lyrics = json['lyrics'];
    playCount = json['playCount'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['title'] = title;
    data['artistName'] = artistName;
    data['artistId'] = artistId;
    data['albumTitle'] = albumTitle;
    data['albumId'] = albumId;
    data['genreName'] = genreName;
    data['genreId'] = genreId;
    data['duration'] = duration;
    data['filePath'] = filePath;
    data['lyrics'] = lyrics;
    data['playCount'] = playCount;
    return data;
  }
}
