import 'base_model.dart';

class Song extends BaseModel {
  String _spotifyId;
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
  String? imageUrl;

  @override
  int? get id => super.id;

  String get spotifyId => _spotifyId;

  Song({
    required String id,
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
    this.imageUrl,
  }) : _spotifyId = id;

  Song.fromJson(Map<String, dynamic> json)
      : _spotifyId = json['spotifyId'] as String? ?? '' {
    id = json['id'] as int?;
    title = json['title'] as String? ?? 'Unknown Title';
    artistName = json['artistName'] as String? ?? 'Unknown Artist';
    artistId = json['artistId'] as int? ?? 0;
    albumTitle = json['albumTitle'] as String?;
    albumId = json['albumId'] as int?;
    genreName = json['genreName'] as String? ?? 'Unknown Genre';
    genreId = json['genreId'] as int? ?? 0;
    duration = json['duration'] as int? ?? 0;
    filePath = json['previewUrl'] as String? ?? '';
    imageUrl = json['imageUrl'] as String?;
    lyrics = json['lyrics'] as String?;
    playCount = json['playCount'] as int?;
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

  Song copyWith({
    String? id,
    String? title,
    String? artistName,
    int? artistId,
    String? albumTitle,
    int? albumId,
    String? genreName,
    int? genreId,
    int? duration,
    String? filePath,
    String? imageUrl,
    String? lyrics,
    DateTime? createdDate,
  }) {
    return Song(
      id: id ?? _spotifyId,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      artistId: artistId ?? this.artistId,
      albumTitle: albumTitle ?? this.albumTitle,
      albumId: albumId ?? this.albumId,
      genreName: genreName ?? this.genreName,
      genreId: genreId ?? this.genreId,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      imageUrl: imageUrl ?? this.imageUrl,
      lyrics: lyrics ?? this.lyrics,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
