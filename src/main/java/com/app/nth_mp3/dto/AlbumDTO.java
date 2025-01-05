package com.app.nth_mp3.dto;

import lombok.Data;
import java.util.Date;

@Data
public class AlbumDTO {
    private Long id;
    private String title;
    private String artistName;
    private Long artistId;
    private Integer releaseYear;
    private String coverImageUrl;
    private int totalSongs;
    private Date createdDate;
    private Date updatedDate;
} 