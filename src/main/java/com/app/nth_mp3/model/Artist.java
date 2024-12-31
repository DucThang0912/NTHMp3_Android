package com.app.nth_mp3.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "artist")
public class Artist extends Base {

    private String name; // tên nghệ sĩ

    private String bio; // tiểu sử nghệ sĩ

    private String avatarUrl; // hình ảnh nghệ sĩ

    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL)
    private List<Album> albums = new ArrayList<>(); // danh sách album của nghệ sĩ

    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL)
    private List<Song> songs = new ArrayList<>(); // danh sách bài hát của nghệ sĩ
}
