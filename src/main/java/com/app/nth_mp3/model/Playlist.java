package com.app.nth_mp3.model;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.Column;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.JoinTable;
import java.util.HashSet;
import java.util.Set;
import jakarta.persistence.OneToMany;
import com.fasterxml.jackson.annotation.JsonManagedReference;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "playlist")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Playlist extends Base {

    private String name; // tên danh sách bài hát

    private String description; // mô tả danh sách bài hát

    @Column(name = "is_public")
    private boolean isPublic; // công khai hay riêng tư

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User user; // người tạo danh sách bài hát

    @OneToMany(mappedBy = "playlist")
    @JsonManagedReference("playlist-playlistsong")
    private Set<PlaylistSong> playlistSongs = new HashSet<>();

}
