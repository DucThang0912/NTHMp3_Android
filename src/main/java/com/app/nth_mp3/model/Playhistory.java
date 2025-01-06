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
import jakarta.persistence.Enumerated;
import jakarta.persistence.EnumType;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "playhistory")
@JsonIgnoreProperties({"user", "song"})
public class Playhistory extends Base {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // người nghe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "song_id", nullable = false)
    private Song song; // bài hát được nghe

    @Enumerated(EnumType.STRING)
    private HistoryType type; // PLAY hoặc FAVORITE

    public enum HistoryType {
        PLAY,    // Lịch sử nghe
        FAVORITE // Bài hát yêu thích
    }
}


