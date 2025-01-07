import 'package:flutter/material.dart';
import '../services/spotify_service.dart';

class SpotifyProvider extends ChangeNotifier {
  late SpotifyService spotifyService;

  SpotifyProvider({required String clientId, required String clientSecret}) {
    spotifyService = SpotifyService(
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }
} 