import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/genre.dart';

class SpotifyService {
  static const String baseUrl = 'https://api.spotify.com/v1';
  final String clientId;
  final String clientSecret;
  String? _accessToken;

  SpotifyService({
    required this.clientId,
    required this.clientSecret,
  });

  Future<void> _getAccessToken() async {
    final bytes = utf8.encode('$clientId:$clientSecret');
    final base64Credentials = base64.encode(bytes);

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $base64Credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<List<Song>> searchSongs(String query, {String market = 'VN'}) async {
    if (_accessToken == null) await _getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/search?q=$query&type=track&market=$market&limit=20'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List;
      
      return tracks.map((track) => Song(
        id: int.tryParse(track['id']) ?? 0,
        title: track['name'],
        artistName: track['artists'][0]['name'],
        artistId: int.tryParse(track['artists'][0]['id']) ?? 0,
        albumTitle: track['album']['name'],
        albumId: int.tryParse(track['album']['id']) ?? 0,
        genreName: track['album']['genres']?.first ?? 'Unknown',
        genreId: 0,
        duration: track['duration_ms'] ~/ 1000,
        filePath: 'https://open.spotify.com/embed/track/${track['id']}',
        imageUrl: track['album']['images']?.isNotEmpty == true ? track['album']['images'][0]['url'] : '',
        lyrics: null,
      )).toList();
    } else {
      throw Exception('Failed to search songs');
    }
  }

  Future<List<Genre>> getGenres() async {
    if (_accessToken == null) await _getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/browse/categories'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categories = data['categories']['items'] as List;
      
      return categories.map((category) => Genre(
        id: int.tryParse(category['id']) ?? 0,
        name: category['name'],
      )).toList();
    } else {
      throw Exception('Failed to get genres');
    }
  }

  Future<List<Song>> getNewReleases() async {
    if (_accessToken == null) await _getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/browse/new-releases?country=VN&limit=20'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final albums = data['albums']['items'] as List;
      
      return albums.map((album) => Song(
        id: int.tryParse(album['id']) ?? 0,
        title: album['name'],
        artistName: album['artists'][0]['name'],
        artistId: int.tryParse(album['artists'][0]['id']) ?? 0,
        albumTitle: album['name'],
        albumId: int.tryParse(album['id']) ?? 0,
        genreName: 'New Release',
        genreId: 0,
        duration: 0,
        filePath: 'https://open.spotify.com/embed/album/${album['id']}',
        imageUrl: album['images']?.isNotEmpty == true ? album['images'][0]['url'] : '',
        createdDate: DateTime.parse(album['release_date']),
      )).toList();
    } else {
      throw Exception('Failed to get new releases');
    }
  }

  Future<List<Artist>> getTopArtists() async {
    if (_accessToken == null) await _getAccessToken();

    final response = await http.get(
      Uri.parse('$baseUrl/search?q=genre:v-pop&type=artist&market=VN&limit=10'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final artists = data['artists']['items'] as List;
      
      return artists.map((artist) => Artist(
        id: artist['id'],
        name: artist['name'],
        avatarUrl: artist['images']?.isNotEmpty == true ? artist['images'][0]['url'] : '',
      )).toList();
    } else {
      throw Exception('Failed to get top artists');
    }
  }

  Future<String> _getLyrics(String artistName, String title) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.lyrics.ovh/v1/$artistName/$title'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['lyrics'] ?? 'Chưa có lời bài hát';
      }
      return 'Chưa có lời bài hát';
    } catch (e) {
      return 'Chưa có lời bài hát';
    }
  }

  Future<Song> loadSongDetails(Song song) async {
    if (_accessToken == null) await _getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tracks/${song.id}'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );

      if (response.statusCode == 200) {
        final track = json.decode(response.body);
        print('Track data: $track'); // Debug log
        
        final previewUrl = track['preview_url'];
        if (previewUrl == null) {
          throw Exception('No preview available');
        }
        
        // Load lyrics
        String lyrics = await _getLyrics(song.artistName, song.title);
        
        return song.copyWith(
          duration: track['duration_ms'] ~/ 1000,
          filePath: previewUrl,
          lyrics: lyrics,
        );
      }
      throw Exception('Failed to load song details');
    } catch (e) {
      print('Error in loadSongDetails: $e');
      rethrow;
    }
  }

  Future<List<Song>> searchSongsByRegion(String query, String market) async {
    return searchSongs('top hits vietnam', market: 'VN');
  }

  Future<List<Song>> searchSongsByGenre(String genre, {String market = 'VN'}) async {
    if (genre.toLowerCase() == 'vpop') {
      return searchSongs('genre:v-pop vietnamese pop', market: market);
    } else if (genre.toLowerCase() == 'k-pop') {
      return searchSongs('genre:k-pop korean pop', market: market);
    }
    return searchSongs('genre:$genre', market: market);
  }

  Future<Artist> getArtistDetails(String artistId) async {
    try {
      if (_accessToken == null) await _getAccessToken();
      
      // Get artist info
      final artistResponse = await http.get(
        Uri.parse('$baseUrl/artists/$artistId'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      
      if (artistResponse.statusCode != 200) {
        throw Exception('Failed to fetch artist details');
      }
      final artistData = json.decode(artistResponse.body);
      
      // Get artist's albums
      final albumsResponse = await http.get(
        Uri.parse('$baseUrl/artists/$artistId/albums?market=VN&include_groups=album&limit=10'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      final albumsData = json.decode(albumsResponse.body);
      
      // Get artist's top tracks
      final tracksResponse = await http.get(
        Uri.parse('$baseUrl/artists/$artistId/top-tracks?market=VN'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      final tracksData = json.decode(tracksResponse.body);
      
      final artist = Artist(
        id: artistId,
        name: artistData['name'] as String? ?? 'Unknown Artist',
        avatarUrl: artistData['images']?.isNotEmpty == true ? artistData['images'][0]['url'] as String : null,
        totalSongs: tracksData['tracks']?.length ?? 0,
        totalAlbums: albumsData['items']?.length ?? 0,
        songs: tracksData['tracks'] != null ? _mapSongsFromTracks(tracksData['tracks'] as List) : [],
        albums: albumsData['items'] != null ? await _mapAlbumsWithTracks(albumsData['items'] as List) : [],
      );
      
      return artist;
    } catch (e) {
      print('Error in getArtistDetails: $e');
      rethrow;
    }
  }

  Future<List<Album>> _mapAlbumsWithTracks(List<dynamic> albums) async {
    final List<Album> mappedAlbums = [];
    
    for (var album in albums) {
      // Get album tracks
      final tracksResponse = await http.get(
        Uri.parse('$baseUrl/albums/${album['id']}/tracks?market=VN'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      final tracksData = json.decode(tracksResponse.body);
      
      mappedAlbums.add(Album(
        id: int.tryParse(album['id']?.toString() ?? '0') ?? 0,
        title: album['name']?.toString() ?? 'Unknown Album',
        coverImageUrl: album['images']?[0]?['url']?.toString(),
        releaseYear: album['release_date']?.toString() != null 
            ? DateTime.parse(album['release_date'].toString()).year 
            : null,
        songs: tracksData['items'] != null ? _mapSongsFromAlbumTracks(tracksData['items'] as List, album) : [],
        artist: Artist(
          id: album['artists']?[0]?['id']?.toString() ?? '0',
          name: album['artists']?[0]?['name']?.toString(),
        ),
      ));
    }
    
    return mappedAlbums;
  }

  List<Song> _mapSongsFromAlbumTracks(List<dynamic> tracks, dynamic albumData) {
    return tracks.map((track) => Song(
      id: int.tryParse(track['id']?.toString() ?? '0') ?? 0,
      title: track['name']?.toString() ?? 'Unknown Title',
      artistName: track['artists']?[0]?['name']?.toString() ?? 'Unknown Artist',
      artistId: int.tryParse(track['artists']?[0]?['id']?.toString() ?? '0') ?? 0,
      albumTitle: albumData['name']?.toString() ?? 'Unknown Album',
      albumId: int.tryParse(albumData['id']?.toString() ?? '0') ?? 0,
      duration: (track['duration_ms'] ?? 0) ~/ 1000,
      imageUrl: albumData['images']?[0]?['url']?.toString(),
      genreName: 'Unknown',
      genreId: 0,
      filePath: track['preview_url']?.toString() ?? '',
    )).toList();
  }

  List<Song> _mapSongsFromTracks(List<dynamic> tracks) {
    return tracks.map((track) => Song(
      id: int.tryParse(track['id'].toString()) ?? 0,
      title: track['name']?.toString() ?? 'Unknown Title',
      artistName: track['artists']?[0]?['name']?.toString() ?? 'Unknown Artist',
      artistId: int.tryParse(track['artists']?[0]?['id']?.toString() ?? '0') ?? 0,
      albumTitle: track['album']?['name']?.toString() ?? 'Unknown Album',
      albumId: int.tryParse(track['album']?['id']?.toString() ?? '0') ?? 0,
      duration: (track['duration_ms'] ?? 0) ~/ 1000,
      imageUrl: track['album']?['images']?[0]?['url']?.toString(),
      genreName: 'Unknown',
      genreId: 0,
      filePath: track['preview_url']?.toString() ?? '',
    )).toList();
  }
} 