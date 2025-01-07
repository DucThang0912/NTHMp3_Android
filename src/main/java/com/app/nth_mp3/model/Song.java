package com.app.nth_mp3.model;

import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.util.HashSet;
import java.util.Set;
import com.fasterxml.jackson.annotation.JsonManagedReference;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "song")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Song extends Base {

    private String spotifyId;  // ID của bài hát trên Spotify
    private String title;
    private String artistName; // Tên nghệ sĩ
    private String albumName;  // Tên album
    private String genreName;  // Thể loại
    private int duration;
    private String filePath;
    private String imageUrl;
    private String lyrics;
    private int playCount;     // Số lần phát trong ứng dụng của bạn

    @OneToMany(mappedBy = "song")
    @JsonManagedReference("song-playlistsong")
    private Set<PlaylistSong> playlistSongs = new HashSet<>();

}
