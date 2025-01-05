package com.app.nth_mp3.config;

import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.repository.ArtistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
@Order(2)
public class ArtistDataInitializer implements CommandLineRunner {

    @Autowired
    private ArtistRepository artistRepository;

    @Override
    public void run(String... args) {
        // Kiểm tra nếu bảng artist đã có dữ liệu thì không thêm nữa
        if (artistRepository.count() > 0) {
            return;
        }

        // Danh sách thông tin nghệ sĩ
        List<Object[]> artistInfos = Arrays.asList(
            new Object[]{"Sơn Tùng M-TP", "Nguyễn Thanh Tùng, thường được biết đến với nghệ danh Sơn Tùng M-TP, là một nam ca sĩ, nhạc sĩ và diễn viên người Việt Nam.", "https://avatar-artist/sontung.jpg"},
            new Object[]{"Hồ Ngọc Hà", "Hồ Ngọc Hà là một nữ ca sĩ, người mẫu và doanh nhân người Việt Nam.", "https://avatar-artist/hongocha.jpg"},
            new Object[]{"Đen Vâu", "Nguyễn Đức Cường, thường được biết đến với nghệ danh Đen Vâu, là một nam rapper người Việt Nam.", "https://avatar-artist/denvau.jpg"},
            new Object[]{"Mỹ Tâm", "Phan Thị Mỹ Tâm, thường được biết đến với nghệ danh Mỹ Tâm, là một nữ ca sĩ, nhạc sĩ người Việt Nam.", "https://avatar-artist/mytam.jpg"},
            new Object[]{"Vũ", "Hoàng Thái Vũ, thường được biết đến với nghệ danh Vũ, là một nam ca sĩ, nhạc sĩ người Việt Nam.", "https://avatar-artist/vu.jpg"},
            new Object[]{"Bích Phương", "Bích Phương là một nữ ca sĩ người Việt Nam.", "https://avatar-artist/bichphuong.jpg"},
            new Object[]{"Hoàng Dũng", "Hoàng Dũng là một nam ca sĩ, nhạc sĩ người Việt Nam.", "https://avatar-artist/hoangdung.jpg"},
            new Object[]{"Tăng Duy Tân", "Tăng Duy Tân là một nam ca sĩ trẻ người Việt Nam.", "https://avatar-artist/tangduytan.jpg"},
            new Object[]{"MONO", "MONO là một nam ca sĩ trẻ người Việt Nam, em trai của Sơn Tùng M-TP.", "https://avatar-artist/mono.jpg"},
            new Object[]{"Hà Anh Tuấn", "Hà Anh Tuấn là một nam ca sĩ người Việt Nam.", "https://avatar-artist/haanhtuanh.jpg"},
            new Object[]{"Noo Phước Thịnh", "Noo Phước Thịnh là một nam ca sĩ người Việt Nam.", "https://avatar-artist/noophuocthinh.jpg"},
            new Object[]{"Min", "Min là một nữ ca sĩ người Việt Nam.", "https://avatar-artist/min.jpg"},
            new Object[]{"Đức Phúc", "Đức Phúc là một nam ca sĩ người Việt Nam.", "https://avatar-artist/ducphuc.jpg"},
            new Object[]{"Hoàng Thùy Linh", "Hoàng Thùy Linh là một nữ ca sĩ, diễn viên người Việt Nam.", "https://avatar-artist/hoangthuylinh.jpg"},
            new Object[]{"Jack", "Trịnh Trần Phương Tuấn, thường được biết đến với nghệ danh Jack, là một nam ca sĩ người Việt Nam.", "https://avatar-artist/jack.jpg"},
            new Object[]{"Amee", "Trần Huyền My, thường được biết đến với nghệ danh Amee, là một nữ ca sĩ người Việt Nam.", "https://avatar-artist/amee.jpg"},
            new Object[]{"Justatee", "Nguyễn Thanh Tuấn, thường được biết đến với nghệ danh Justatee, là một nam ca sĩ người Việt Nam.", "https://avatar-artist/justatee.jpg"},
            new Object[]{"Phương Ly", "Phương Ly là một nữ ca sĩ người Việt Nam.", "https://avatar-artist/phuongly.jpg"},
            new Object[]{"Soobin Hoàng Sơn", "Nguyễn Hoàng Sơn, thường được biết đến với nghệ danh Soobin Hoàng Sơn, là một nam ca sĩ người Việt Nam.", "https://avatar-artist/soobin.jpg"},
            new Object[]{"Chi Pu", "Nguyễn Thùy Chi, thường được biết đến với nghệ danh Chi Pu, là một nữ ca sĩ, diễn viên người Việt Nam.", "https://avatar-artist/chipu.jpg"}
        );

        // Thêm từng nghệ sĩ
        for (Object[] info : artistInfos) {
            Artist artist = new Artist();
            artist.setName((String) info[0]);
            artist.setBio((String) info[1]);
            artist.setAvatarUrl((String) info[2]);
            artistRepository.save(artist);
        }
    }
}