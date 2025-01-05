package com.app.nth_mp3.dto;

import lombok.Data;
import java.util.Date;

@Data
public class ArtistDTO {
    private Long id;
    private String name;
    private String bio;
    private String avatarUrl;
    private int totalSongs;
    private int totalAlbums;
    private Date createdDate;
    private Date updatedDate;
} 