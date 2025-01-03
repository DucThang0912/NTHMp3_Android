import 'base_model.dart';
import 'user.dart';
import 'song.dart';

class PlayHistory extends BaseModel {
  User? user;
  Song? song;

  PlayHistory({
    super.id,
    super.createdDate,
    super.updatedDate,
    this.user,
    this.song,
  });

  PlayHistory.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    song = json['song'] != null ? Song.fromJson(json['song']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (song != null) {
      data['song'] = song!.toJson();
    }
    return data;
  }
}