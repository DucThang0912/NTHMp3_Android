import 'base_model.dart';
import 'album.dart';
import 'song.dart';

class Artist extends BaseModel {
  @override
  int? get id => int.tryParse(_id);
  final String _id;
  String? name;
  String? bio;
  String? avatarUrl;
  List<Album>? albums;
  List<Song>? songs;
  int? totalSongs;
  int? totalAlbums;

  Artist({
    required String id,
    super.createdDate,
    super.updatedDate,
    this.name,
    this.bio,
    this.avatarUrl,
    this.albums,
    this.songs,
    this.totalSongs,
    this.totalAlbums,
  }) : _id = id;

  Artist.fromJson(Map<String, dynamic> json) : 
    _id = json['id']?.toString() ?? '0',
    super.fromJson(json) {
      name = json['name'];
      bio = json['bio'];
      avatarUrl = json['avatarUrl'];
      totalSongs = json['totalSongs'];
      totalAlbums = json['totalAlbums'];
      if (json['albums'] != null) {
        albums = <Album>[];
        json['albums'].forEach((v) {
          albums!.add(Album.fromJson(v));
        });
      }
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
    data['bio'] = bio;
    data['avatarUrl'] = avatarUrl;
    data['totalSongs'] = totalSongs;
    data['totalAlbums'] = totalAlbums;
    if (albums != null) {
      data['albums'] = albums!.map((v) => v.toJson()).toList();
    }
    if (songs != null) {
      data['songs'] = songs!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get spotifyId => _id;
}