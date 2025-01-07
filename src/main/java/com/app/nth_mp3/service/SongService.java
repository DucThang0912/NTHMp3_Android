package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Song;

public interface SongService {
    Song findBySpotifyId(String spotifyId);
    Song incrementPlayCount(String spotifyId);
    Song saveSong(Song song);
}
