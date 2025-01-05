package com.app.nth_mp3.config;

import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Genre;
import com.app.nth_mp3.repository.SongRepository;
import com.app.nth_mp3.repository.ArtistRepository;
import com.app.nth_mp3.repository.AlbumRepository;
import com.app.nth_mp3.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Component
@Order(4)
public class SongDataInitializer implements CommandLineRunner {

    @Autowired
    private SongRepository songRepository;

    @Autowired
    private ArtistRepository artistRepository;

    @Autowired
    private AlbumRepository albumRepository;

    @Autowired
    private GenreRepository genreRepository;

    @Override
    public void run(String... args) {
        if (songRepository.count() > 0) {
            return;
        }

        // Format: {title, artist_name, album_title, genre_name, duration(seconds), filePath, lyrics}
        List<Object[]> songInfos = Arrays.asList(
            // Sơn Tùng M-TP Songs
            new Object[]{"Chúng Ta Của Hiện Tại", "Sơn Tùng M-TP", "Chúng Ta Của Hiện Tại", "V-Pop", 290, "/songs/chungtacuahientai.mp3", "Lyrics chúng ta của hiện tại..."},
            new Object[]{"Nắng Ấm Xa Dần", "Sơn Tùng M-TP", "m-tp M-TP", "V-Pop", 267, "/songs/nangamxadan.mp3", "Lyrics nắng ấm xa dần..."},
            new Object[]{"Chạy Ngay Đi", "Sơn Tùng M-TP", "Sky Tour", "V-Pop", 247, "/songs/chayngaydi.mp3", "Lyrics chạy ngay đi..."},
            new Object[]{"Có Chắc Yêu Là Đây", "Sơn Tùng M-TP", null, "V-Pop", 189, "/songs/cochacyeuladay.mp3", "Lyrics có chắc yêu là đây..."},
            new Object[]{"Muộn Rồi Mà Sao Còn", "Sơn Tùng M-TP", null, "V-Pop", 274, "/songs/muonroimasaocon.mp3", "Lyrics muộn rồi mà sao còn..."},
            new Object[]{"Em Của Ngày Hôm Qua", "Sơn Tùng M-TP", "m-tp M-TP", "V-Pop", 279, "/songs/emcuangayhomqua.mp3", "Lyrics em của ngày hôm qua..."},
            new Object[]{"Lạc Trôi", "Sơn Tùng M-TP", "m-tp M-TP", "V-Pop", 295, "/songs/lactroi.mp3", "Lyrics lạc trôi..."},
            
            // Hoàng Thùy Linh Songs
            new Object[]{"See Tình", "Hoàng Thùy Linh", "Link", "V-Pop", 189, "/songs/seetinh.mp3", "Lyrics see tình..."},
            new Object[]{"Để Mị Nói Cho Mà Nghe", "Hoàng Thùy Linh", "Hoàng", "V-Pop", 234, "/songs/deminoichomanghe.mp3", "Lyrics để mị nói cho mà nghe..."},
            new Object[]{"Gieo Quẻ", "Hoàng Thùy Linh", "Link", "V-Pop", 199, "/songs/gieoque.mp3", "Lyrics gieo quẻ..."},
            new Object[]{"Bo Xì Bo", "Hoàng Thùy Linh", "Link", "V-Pop", 203, "/songs/boxibo.mp3", "Lyrics bo xì bo..."},
            
            // Đen Vâu Songs
            new Object[]{"Trốn Tìm", "Đen Vâu", "Lối Nhỏ", "Rap/Hip Hop", 258, "/songs/trontim.mp3", "Lyrics trốn tìm..."},
            new Object[]{"Mang Tiền Về Cho Mẹ", "Đen Vâu", "Mang Tiền Về Cho Mẹ", "Rap/Hip Hop", 345, "/songs/mangtienvechome.mp3", "Lyrics mang tiền về cho mẹ..."},
            new Object[]{"Đi Về Nhà", "Đen Vâu", null, "Rap/Hip Hop", 240, "/songs/divenha.mp3", "Lyrics đi về nhà..."},
            new Object[]{"Lối Nhỏ", "Đen Vâu", "Lối Nhỏ", "Rap/Hip Hop", 267, "/songs/loinho.mp3", "Lyrics lối nhỏ..."},
            new Object[]{"Bài Này Chill Phết", "Đen Vâu", null, "Rap/Hip Hop", 289, "/songs/bainaychillphet.mp3", "Lyrics bài này chill phết..."},
            new Object[]{"Một Triệu Like", "Đen Vâu", null, "Rap/Hip Hop", 294, "/songs/mottrieulike.mp3", "Lyrics một triệu like..."},
            
            // Mỹ Tâm Songs
            new Object[]{"Người Hãy Quên Em Đi", "Mỹ Tâm", "Tâm 9", "V-Pop", 287, "/songs/nguoihayquenemdi.mp3", "Lyrics người hãy quên em đi..."},
            new Object[]{"Đúng Cũng Thành Sai", "Mỹ Tâm", "Tâm 9", "V-Pop", 267, "/songs/dungcungthanhsai.mp3", "Lyrics đúng cũng thành sai..."},
            new Object[]{"Hẹn Ước Từ Hư Vô", "Mỹ Tâm", "Tâm 10", "V-Pop", 289, "/songs/henuoctuhuvo.mp3", "Lyrics hẹn ước từ hư vô..."},
            
            // Vũ Songs
            new Object[]{"Lạ Lùng", "Vũ", "Vũ Trụ Cò Bay", "Indie", 279, "/songs/lalung.mp3", "Lyrics lạ lùng..."},
            new Object[]{"Đông Kiếm Em", "Vũ", "Đông Kiếm Em", "Indie", 315, "/songs/dongkiemem.mp3", "Lyrics đông kiếm em..."},
            new Object[]{"Bước Qua Nhau", "Vũ", null, "Indie", 234, "/songs/buoquanhau.mp3", "Lyrics bước qua nhau..."},
            
            // MONO Songs
            new Object[]{"Waiting For You", "MONO", null, "V-Pop", 265, "/songs/waitingforyou.mp3", "Lyrics waiting for you..."},
            new Object[]{"Em Là", "MONO", null, "V-Pop", 178, "/songs/emla.mp3", "Lyrics em là..."},
            
            // Amee Songs
            new Object[]{"Anh Nhà Ở Đâu Thế", "Amee", "dreamee", "V-Pop", 203, "/songs/anhnhaodauthe.mp3", "Lyrics anh nhà ở đâu thế..."},
            new Object[]{"Đen Đá Không Đường", "Amee", "dreAMEE", "V-Pop", 184, "/songs/dendakhongduong.mp3", "Lyrics đen đá không đường..."},
            new Object[]{"Ex's Hate Me", "Amee", "dreamee", "V-Pop", 199, "/songs/exshateme.mp3", "Lyrics ex's hate me..."},
            
            // Đức Phúc Songs
            new Object[]{"Hơn Cả Yêu", "Đức Phúc", "Hơn Cả Yêu", "V-Pop", 295, "/songs/honcayeu.mp3", "Lyrics hơn cả yêu..."},
            new Object[]{"Năm Ấy", "Đức Phúc", "Hơn Cả Yêu", "V-Pop", 271, "/songs/namay.mp3", "Lyrics năm ấy..."},
            new Object[]{"Ngày Đầu Tiên", "Đức Phúc", null, "V-Pop", 237, "/songs/ngaydautien.mp3", "Lyrics ngày đầu tiên..."},
            
            // Min Songs
            new Object[]{"Có Em Chờ", "Min", null, "V-Pop", 234, "/songs/coemcho.mp3", "Lyrics có em chờ..."},
            new Object[]{"Ghen", "Min", null, "V-Pop", 189, "/songs/ghen.mp3", "Lyrics ghen..."},
            
            // Jack Songs
            new Object[]{"Sóng Gió", "Jack", null, "V-Pop", 281, "/songs/songgio.mp3", "Lyrics sóng gió..."},
            new Object[]{"Bạc Phận", "Jack", null, "V-Pop", 293, "/songs/bacphan.mp3", "Lyrics bạc phận..."},
            
            // US-UK Songs
            new Object[]{"Shape of You", "Ed Sheeran", "÷ (Divide)", "US-UK", 234, "/songs/shapeofyou.mp3", "Lyrics shape of you..."},
            new Object[]{"Blinding Lights", "The Weeknd", "After Hours", "US-UK", 201, "/songs/blindinglights.mp3", "Lyrics blinding lights..."},
            new Object[]{"Bad Guy", "Billie Eilish", "When We All Fall Asleep", "US-UK", 194, "/songs/badguy.mp3", "Lyrics bad guy..."},
            new Object[]{"Stay With Me", "Sam Smith", "In The Lonely Hour", "US-UK", 173, "/songs/staywithme.mp3", "Lyrics stay with me..."},
            
            // K-Pop Songs
            new Object[]{"Butter", "BTS", "Butter", "K-Pop", 164, "/songs/butter.mp3", "Lyrics butter..."},
            new Object[]{"How You Like That", "BLACKPINK", "THE ALBUM", "K-Pop", 182, "/songs/howyoulikethat.mp3", "Lyrics how you like that..."},
            new Object[]{"Boy With Luv", "BTS", "Map of the Soul: Persona", "K-Pop", 229, "/songs/boywithluv.mp3", "Lyrics boy with luv..."},
            
            // Rock Songs
            new Object[]{"Numb", "Linkin Park", "Meteora", "Rock", 187, "/songs/numb.mp3", "Lyrics numb..."},
            new Object[]{"Sweet Child O' Mine", "Guns N' Roses", "Appetite for Destruction", "Rock", 356, "/songs/sweetchild.mp3", "Lyrics sweet child..."},
            
            // EDM Songs
            new Object[]{"Faded", "Alan Walker", "Different World", "EDM", 212, "/songs/faded.mp3", "Lyrics faded..."},
            new Object[]{"The Nights", "Avicii", "The Days / Nights", "EDM", 176, "/songs/thenights.mp3", "Lyrics the nights..."},
            
            // Rap/Hip Hop Songs
            new Object[]{"Rap God", "Eminem", "The Marshall Mathers LP 2", "Rap/Hip Hop", 363, "/songs/rapgod.mp3", "Lyrics rap god..."},
            new Object[]{"Sicko Mode", "Travis Scott", "Astroworld", "Rap/Hip Hop", 312, "/songs/sickomode.mp3", "Lyrics sicko mode..."},
            
            // V-Pop Songs (Additional)
            new Object[]{"Hãy Trao Cho Anh", "Sơn Tùng M-TP", null, "V-Pop", 243, "/songs/haytraochoanh.mp3", "Lyrics hãy trao cho anh..."},
            new Object[]{"Tháng Năm", "Soobin Hoàng Sơn", null, "V-Pop", 267, "/songs/thangnam.mp3", "Lyrics tháng năm..."},
            
            // Ballad Songs
            new Object[]{"All of Me", "John Legend", "Love in the Future", "Ballad", 269, "/songs/allofme.mp3", "Lyrics all of me..."},
            new Object[]{"Perfect", "Ed Sheeran", "÷ (Divide)", "Ballad", 263, "/songs/perfect.mp3", "Lyrics perfect..."},
            
            // R&B Songs
            new Object[]{"Earned It", "The Weeknd", "Beauty Behind the Madness", "R&B", 277, "/songs/earnedit.mp3", "Lyrics earned it..."},
            new Object[]{"Love On Top", "Beyoncé", "4", "R&B", 267, "/songs/loveontop.mp3", "Lyrics love on top..."},
            new Object[]{"Thinking Out Loud", "Ed Sheeran", "x (Multiply)", "R&B", 281, "/songs/thinkingoutloud.mp3", "Lyrics thinking out loud..."}
        );

        for (Object[] info : songInfos) {
            String title = (String) info[0];
            String artistName = (String) info[1];
            String albumTitle = (String) info[2];
            String genreName = (String) info[3];
            Integer duration = (Integer) info[4];
            String filePath = (String) info[5];
            String lyrics = (String) info[6];

            // Tìm artist và genre theo tên
            Optional<Artist> artist = artistRepository.findByName(artistName);
            Optional<Genre> genre = genreRepository.findByName(genreName);
            
            if (artist.isPresent() && genre.isPresent()) {
                Song song = new Song();
                song.setTitle(title);
                song.setArtist(artist.get());
                song.setGenre(genre.get());
                song.setDuration(duration);
                song.setFilePath(filePath);
                song.setLyrics(lyrics);
                song.setPlayCount(0);

                // Nếu có album thì set album
                if (albumTitle != null) {
                    List<Album> albums = albumRepository.findByTitleAndArtistId(albumTitle, artist.get().getId());
                    if (!albums.isEmpty()) {
                        song.setAlbum(albums.get(0)); // Lấy album đầu tiên nếu có nhiều album trùng tên
                    }
                }

                songRepository.save(song);
            }
        }
    }
}
