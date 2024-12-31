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
@Table(name = "genre")
public class Genre extends Base {
    
    private String name; // tên thể loại

    @OneToMany(mappedBy = "genre", cascade = CascadeType.ALL)
    private List<Song> songs = new ArrayList<>(); // danh sách bài hát thuộc thể loại
}

