import 'package:flutter/material.dart';
import '../services/spotify_service.dart';

class SpotifyProvider extends ChangeNotifier {
  late final SpotifyService spotifyService;

  SpotifyProvider() {
    spotifyService = SpotifyService(
      clientId: '24dfc57421d5444ab08ca1c434f30935',
      clientSecret: '03f0ecd3b5c2412a893e3fdfbb4da647',
    );
  }
} 