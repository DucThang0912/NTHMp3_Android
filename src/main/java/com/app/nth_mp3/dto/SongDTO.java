package com.app.nth_mp3.dto;

import lombok.Data;
import java.util.Date;

@Data
public class SongDTO {
    private Long id;
    private String title;
    private String artistName;
    private Long artistId;
    private String albumTitle;
    private Long albumId;
    private String genreName;
    private Long genreId;
    private int duration;
    private String filePath;
    private String lyrics;
    private int playCount;
    private Date createdDate;
    private Date updatedDate;
} 