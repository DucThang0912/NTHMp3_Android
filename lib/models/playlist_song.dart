import 'base_model.dart';
import 'playlist.dart';
import 'song.dart';

class PlaylistSong extends BaseModel {
  Playlist? playlist;
  Song? song;

  PlaylistSong({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.playlist,
    this.song,
  });

  PlaylistSong.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    playlist = json['playlist'] != null ? Playlist.fromJson(json['playlist']) : null;
    song = json['song'] != null ? Song.fromJson(json['song']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (playlist != null) {
      data['playlist'] = playlist!.toJson();
    }
    if (song != null) {
      data['song'] = song!.toJson();
    }
    return data;
  }
}