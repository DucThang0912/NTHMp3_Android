package com.app.nth_mp3.dto;

import lombok.Data;
import java.util.Date;

@Data
public class GenreDTO {
    private Long id;
    private String name;
    private Date createdDate;
    private Date updatedDate;
} 