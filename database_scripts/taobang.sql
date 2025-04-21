CREATE DATABASE BTL
USE BTL
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TABLE "HopDong"(
    "MaHopDong" NVARCHAR(255) NOT NULL,
    "NgayBatDau" DATE NOT NULL,
    "NgayKetThuc" DATE NOT NULL,
    "GiaTien" INT NOT NULL,
    "MaSinhVien" NVARCHAR(255) NOT NULL,
    "MaNhanVien" NVARCHAR(255) NOT NULL,
    "MaPhong" NVARCHAR(255) NOT NULL,
    "SoThang" INT NOT NULL
);
ALTER TABLE
    "HopDong" ADD CONSTRAINT "hopdong_mahopdong_primary" PRIMARY KEY("MaHopDong");
CREATE TABLE "Phong"(
    "MaPhong" NVARCHAR(255) NOT NULL,
    "TenPhong" NVARCHAR(255) NOT NULL,
    "MaLoaiPhong" NVARCHAR(255) NOT NULL,
    "MaToa" NVARCHAR(255) NOT NULL,
    "MaNhanVien" NVARCHAR(255) NOT NULL,
    "TrangThai" BIGINT NOT NULL
);
ALTER TABLE
    "Phong" ADD CONSTRAINT "phong_maphong_primary" PRIMARY KEY("MaPhong");
CREATE TABLE "LoaiCSVC"(
    "MaLoaiCSVC" NVARCHAR(255) NOT NULL,
    "TenLoaiCSVC" NVARCHAR(255) NOT NULL,
    "Hang" NVARCHAR(255) NOT NULL,
    "Gia" BIGINT NOT NULL
);
ALTER TABLE
    "LoaiCSVC" ADD CONSTRAINT "loaicsvc_maloaicsvc_primary" PRIMARY KEY("MaLoaiCSVC");
CREATE TABLE "LoaiPhong_CSVC"(
    "MaLoaiCSVC" NVARCHAR(255) NOT NULL,
    "MaLoaiPhong" NVARCHAR(255) NOT NULL,
    "SoLuong" INT NOT NULL,
    "NgayMua" DATE NOT NULL,
    "Gia" BIGINT NOT NULL
);
ALTER TABLE "LoaiPhong_CSVC" 
ADD CONSTRAINT "loaiphong_csvc_primary" 
PRIMARY KEY("MaLoaiCSVC", "MaLoaiPhong");
CREATE TABLE "LoaiPhong"(
    "MaLoaiPhong" NVARCHAR(255) NOT NULL,
    "Gia" BIGINT NOT NULL,
    "TenPhong" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "LoaiPhong" ADD CONSTRAINT "loaiphong_maloaiphong_primary" PRIMARY KEY("MaLoaiPhong");
CREATE TABLE "Toa"(
    "MaToa" NVARCHAR(255) NOT NULL,
    "TenToa" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "Toa" ADD CONSTRAINT "toa_matoa_primary" PRIMARY KEY("MaToa");
CREATE TABLE "NhanVien"(
    "MaNhanVien" NVARCHAR(255) NOT NULL,
    "HoTen" NVARCHAR(255) NOT NULL,
    "NgaySinh" DATE NOT NULL,
    "GioiTinh" NVARCHAR(255) NOT NULL,
    "SoDienThoai" NVARCHAR(255) NOT NULL,
    "MaCongViec" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "NhanVien" ADD CONSTRAINT "nhanvien_manhanvien_primary" PRIMARY KEY("MaNhanVien");
CREATE TABLE "ViTriLamViec"(
    "MaCongViec" NVARCHAR(255) NOT NULL,
    "TenCongViec" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "ViTriLamViec" ADD CONSTRAINT "vitrilamviec_macongviec_primary" PRIMARY KEY("MaCongViec");
CREATE TABLE "HoaDon"(
    "MaHoaDon" NVARCHAR(255) NOT NULL,
    "MaPhong" NVARCHAR(255) NOT NULL,
    "DonGiaDien" INT NOT NULL,
    "DonGiaNuoc" INT NOT NULL,
    "TrangThai" BIT NOT NULL,
    "ChiSoDienDau" INT NOT NULL,
    "ChiSoDienCuoi" INT NOT NULL,
    "ChiSoNuocDau" INT NOT NULL,
    "ChiSoNuocCuoi" INT NOT NULL,
    "MaDaiDienPhong" NVARCHAR(255) NOT NULL,
    "MaNhanVien" NVARCHAR(255) NOT NULL,
    "NgayTao" DATE NOT NULL
);
ALTER TABLE
    "HoaDon" ADD CONSTRAINT "hoadon_mahoadon_primary" PRIMARY KEY("MaHoaDon");
CREATE TABLE "SinhVien"(
    "MaSinhVien" NVARCHAR(255) NOT NULL,
    "HoTen" NVARCHAR(255) NOT NULL,
    "NgaySinh" DATE NOT NULL,
    "GioiTinh" NVARCHAR(255) NOT NULL,
    "SoDienThoai" NVARCHAR(255) NOT NULL,
    "MaPhong" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "SinhVien" ADD CONSTRAINT "sinhvien_masinhvien_primary" PRIMARY KEY("MaSinhVien");
ALTER TABLE
    "HopDong" ADD CONSTRAINT "hopdong_manhanvien_foreign" FOREIGN KEY("MaNhanVien") REFERENCES "NhanVien"("MaNhanVien");
ALTER TABLE
    "HoaDon" ADD CONSTRAINT "hoadon_manhanvien_foreign" FOREIGN KEY("MaNhanVien") REFERENCES "NhanVien"("MaNhanVien");
ALTER TABLE
    "HopDong" ADD CONSTRAINT "hopdong_masinhvien_foreign" FOREIGN KEY("MaSinhVien") REFERENCES "SinhVien"("MaSinhVien");
ALTER TABLE
    "Phong" ADD CONSTRAINT "phong_maloaiphong_foreign" FOREIGN KEY("MaLoaiPhong") REFERENCES "LoaiPhong"("MaLoaiPhong");
ALTER TABLE
    "HopDong" ADD CONSTRAINT "hopdong_maphong_foreign" FOREIGN KEY("MaPhong") REFERENCES "Phong"("MaPhong");
ALTER TABLE
    "LoaiPhong_CSVC" ADD CONSTRAINT "loaiphong_csvc_maloaiphong_foreign" FOREIGN KEY("MaLoaiPhong") REFERENCES "LoaiPhong"("MaLoaiPhong");
ALTER TABLE
    "Phong" ADD CONSTRAINT "phong_matoa_foreign" FOREIGN KEY("MaToa") REFERENCES "Toa"("MaToa");
ALTER TABLE
    "SinhVien" ADD CONSTRAINT "sinhvien_maphong_foreign" FOREIGN KEY("MaPhong") REFERENCES "Phong"("MaPhong");
ALTER TABLE
    "NhanVien" ADD CONSTRAINT "nhanvien_macongviec_foreign" FOREIGN KEY("MaCongViec") REFERENCES "ViTriLamViec"("MaCongViec");
ALTER TABLE
    "HoaDon" ADD CONSTRAINT "hoadon_madaidienphong_foreign" FOREIGN KEY("MaDaiDienPhong") REFERENCES "SinhVien"("MaSinhVien");
ALTER TABLE
    "Phong" ADD CONSTRAINT "phong_manhanvien_foreign" FOREIGN KEY("MaNhanVien") REFERENCES "NhanVien"("MaNhanVien");
ALTER TABLE
    "HoaDon" ADD CONSTRAINT "hoadon_maphong_foreign" FOREIGN KEY("MaPhong") REFERENCES "Phong"("MaPhong");
ALTER TABLE "LoaiPhong_CSVC" 
ADD CONSTRAINT "loaiphong_csvc_maloaicsvc_foreign" 
FOREIGN KEY("MaLoaiCSVC") REFERENCES "LoaiCSVC"("MaLoaiCSVC");
