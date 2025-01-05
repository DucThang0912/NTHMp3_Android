package com.app.nth_mp3.config;

import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.repository.AlbumRepository;
import com.app.nth_mp3.repository.ArtistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Component
@Order(3)
public class AlbumDataInitializer implements CommandLineRunner {

    @Autowired
    private AlbumRepository albumRepository;

    @Autowired
    private ArtistRepository artistRepository;

    @Override
    public void run(String... args) {
        // Kiểm tra nếu bảng album đã có dữ liệu thì không thêm nữa
        if (albumRepository.count() > 0) {
            return;
        }

        // Danh sách thông tin album
        List<Object[]> albumInfos = Arrays.asList(
            // Format: {tên album, tên nghệ sĩ, năm phát hành, cover URL}
            new Object[]{"Chúng Ta Của Hiện Tại", "Sơn Tùng M-TP", 2020, "https://cover-album/chungtacuahientai.jpg"},
            new Object[]{"Sky Tour", "Sơn Tùng M-TP", 2019, "https://cover-album/skytour.jpg"},
            new Object[]{"m-tp M-TP", "Sơn Tùng M-TP", 2017, "https://cover-album/mtp.jpg"},
            
            new Object[]{"Link", "Hoàng Thùy Linh", 2022, "https://cover-album/link.jpg"},
            new Object[]{"Hoàng", "Hoàng Thùy Linh", 2019, "https://cover-album/hoang.jpg"},
            
            new Object[]{"Mang Tiền Về Cho Mẹ", "Đen Vâu", 2022, "https://cover-album/mangtienvechome.jpg"},
            new Object[]{"Lối Nhỏ", "Đen Vâu", 2019, "https://cover-album/loinho.jpg"},
            
            new Object[]{"Tâm 9", "Mỹ Tâm", 2017, "https://cover-album/tam9.jpg"},
            new Object[]{"Tâm 10", "Mỹ Tâm", 2023, "https://cover-album/tam10.jpg"},
            
            new Object[]{"Vũ Trụ Cò Bay", "Vũ", 2020, "https://cover-album/vutrucobay.jpg"},
            new Object[]{"Gieo Quẻ", "Hoàng Thùy Linh", 2022, "https://cover-album/gieoque.jpg"},
            
            new Object[]{"dreamee", "Amee", 2020, "https://cover-album/dreamee.jpg"},
            new Object[]{"dreAMEE", "Amee", 2021, "https://cover-album/dreamee2.jpg"},
            
            new Object[]{"Màu Nước Mắt", "Nguyễn Trần Trung Quân", 2020, "https://cover-album/maunuocmat.jpg"},
            new Object[]{"Đông Kiếm Em", "Vũ", 2019, "https://cover-album/dongkiemem.jpg"},
            
            new Object[]{"Thái Bình Mồ Hôi Rơi", "Sơn Tùng M-TP", 2015, "https://cover-album/thaibinhmohoiroi.jpg"},
            new Object[]{"Người Yêu Cũ", "Phan Mạnh Quỳnh", 2018, "https://cover-album/nguoiyeucu.jpg"},
            
            new Object[]{"Hơn Cả Yêu", "Đức Phúc", 2020, "https://cover-album/honcayeu.jpg"},
            new Object[]{"Yêu Được Không", "Đức Phúc", 2021, "https://cover-album/yeuduockhong.jpg"},
            
            new Object[]{"Sau Tất Cả", "ERIK", 2016, "https://cover-album/sautatca.jpg"}
        );

        // Thêm từng album
        for (Object[] info : albumInfos) {
            Optional<Artist> artist = artistRepository.findByName((String) info[1]);
            if (artist.isPresent()) {
                Album album = new Album();
                album.setTitle((String) info[0]);
                album.setArtist(artist.get());
                album.setReleaseYear((Integer) info[2]);
                album.setCoverImageUrl((String) info[3]);
                albumRepository.save(album);
            }
        }
    }
}
