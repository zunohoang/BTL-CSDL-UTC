USE BTL

SELECT * FROM SinhVien
SELECT * FROM Phong
SELECT * FROM HopDong
SELECT * FROM NhanVien
SELECT * FROM ViTriLamViec
SELECT * FROM Toa
SELECT * FROM LoaiPhong

--1. Liệt kê các sinh viên là nam

SELECT *
FROM SinhVien
WHERE SinhVien.GioiTinh = N'Nữ'

--2. Liệt kê các sinh viên ở phòng 102     :D???
SELECT * FROM SinhVien
WHERE SinhVien.MaPhong = 'P102'

--3. Liệt kê sinh viên kèm tên phòng ở

SELECT sv.*, p.TenPhong
FROM SinhVien sv
         JOIN Phong p ON sv.MaPhong = p.MaPhong

--4. Liệt kê sinh viên kèm tên tòa

SELECT sv.*, t.TenToa
FROM SinhVien sv
         JOIN Phong p ON sv.MaPhong = p.MaPhong
         JOIN Toa t ON p.MaToa = t.MaToa

--5. Liệt kê sinh viên và tên nhân viên phụ trách hợp đồng của họ

SELECT sv.*, nv.HoTen
FROM SinhVien sv
         JOIN Phong p ON sv.MaPhong = p.MaPhong
         JOIN NhanVien nv ON p.MaNhanVien = nv.MaNhanVien

--6. Đếm số sinh viên trong mỗi phòng

SELECT sv.MaPhong, COUNT(sv.MaSinhVien) AS SoSinhVien
FROM SinhVien sv
GROUP BY sv.MaPhong

--7. Cho biết những phòng có hơn 3 sinh viên ở

SELECT sv.MaPhong
FROM SinhVien sv
GROUP BY sv.MaPhong
HAVING COUNT(sv.MaSinhVien) > 3

--8. Liệt kê số lượng sinh viên trong mỗi tòa, sắp xếp giảm dần theo số lượng

-- SELECT t.TenToa, COUNT(sv.MaSinhVien) AS SoLuongSinhVien
-- FROM Toa t
--         JOIN Phong p ON t.MaToa = p.MaToa
--         JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
-- GROUP BY t.TenToa;
-- cach nay khong co lay duoc toa nao ma khong co phong nao
SELECT t.TenToa, COUNT(sv.MaSinhVien) AS SoLuongSinhVien
FROM Toa t
        LEFT JOIN Phong p ON t.MaToa = p.MaToa
        LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY t.TenToa;

--9. Liệt kê những phòng có số lượng sinh viên nhiều hơn số lượng sinh viên trung bình của tất cả các phòng

WITH SVMoiPhong AS (
    SELECT MaPhong, COUNT(MaSinhVien) AS SoSinhVien
    FROM SinhVien
    GROUP BY MaPhong
)
SELECT p.MaPhong, p.TenPhong
FROM SinhVien sv
         JOIN Phong p ON sv.MaPhong = p.MaPhong
GROUP BY p.MaPhong, p.TenPhong
HAVING COUNT(sv.MaSinhVien) > (SELECT AVG(svmp.SoSinhVien)
                               FROM SVMoiPhong svmp)


--10. Liệt kê các hợp đồng có thời gian kết thúc trong năm 2025

SELECT *
FROM HopDong hd
WHERE YEAR(hd.NgayKetThuc) = 2025

--11. Liệt kê hợp đồng có tổng số tiền lớn hơn 5.000.000
SELECT *
FROM HopDong
WHERE GiaTien >= 5000000
--12. Chèn một hợp đồng mới cho sinh viên có mã 'SV090'
--13. Cập nhật tổng số tiền cho các hợp đồng kết thúc năm 2025
--14. Xóa các hợp đồng đã kết thúc trước năm 2020
--15. Liệt kê hóa đơn và tên nhân viên lập hóa đơn
SELECT * FROM HoaDon HD
                  JOIN NhanVien NV on NV.MaNhanVien = HD.MaNhanVien

--16. Liệt kê hóa đơn và số điện sử dụng và tổng tiền điện  trên 800.000
SELECT MaHoaDon,MaPhong, (ChiSoDienCuoi - ChiSoDienDau) as SoDienSD,(ChiSoDienCuoi - ChiSoDienDau)*DonGiaDien as TongTienDien  FROM HoaDon HD
WHERE (ChiSoDienCuoi - ChiSoDienDau)*DonGiaDien >= 800000

--17. Tính tổng tiền điện của từng phòng trong tháng 3 năm 2025

-- SELECT MaHoaDon,MaPhong, (ChiSoDienCuoi - ChiSoDienDau) as SoDienSD,(ChiSoDienCuoi - ChiSoDienDau)*DonGiaDien as TongTienDien  FROM HoaDon HD
-- WHERE NgayTao > '2025-03-01' AND NgayTao <= '2025-04-01'
-- nen dung between de toi uu neu ma danh index
SELECT MaHoaDon,MaPhong, (ChiSoDienCuoi - ChiSoDienDau) as SoDienSD,(ChiSoDienCuoi - ChiSoDienDau)*DonGiaDien as TongTienDien  FROM HoaDon HD
WHERE MONTH(NgayTao) -1;

--18. Liệt kê các phòng có tổng số điện tiêu thụ trên 240, sắp xếp giảm dần
SELECT MaHoaDon,MaPhong, (ChiSoDienCuoi - ChiSoDienDau) as SoDienSD  FROM HoaDon HD
WHERE (ChiSoDienCuoi - ChiSoDienDau) > 240

--19. Liệt kê các phòng thuộc tòa TOA01
SELECT * FROM Phong
WHERE Phong.MaToa = N'TOA01'

--21. Liệt kê tên phòng và tên loại phòng tương ứng
SELECT Phong.TenPhong,LoaiPhong.TenPhong as TenLoaiPhong  FROM Phong
JOIN LoaiPhong on LoaiPhong.MaLoaiPhong = Phong.MaLoaiPhong

--22. Cho biết tổng số lượng phòng của từng loại phòng

-- SELECT LoaiPhong.MaLoaiPhong,LoaiPhong.TenPhong,COUNT(LoaiPhong.MaLoaiPhong) as SoLuongPhong
-- FROM Phong
--     JOIN LoaiPhong on LoaiPhong.MaLoaiPhong = Phong.MaLoaiPhong
-- GROUP BY LoaiPhong.MaLoaiPhong,LoaiPhong.TenPhong
-- fix lai cho hop ly
SELECT lp.MaLoaiPhong,lp.TenPhong,COUNT(lp.MaLoaiPhong) as SoLuongPhong
FROM LoaiPhong lp
    LEFT JOIN Phong p on lp.MaLoaiPhong = p.MaLoaiPhong
GROUP BY lp.MaLoaiPhong,lp.TenPhong

--23. Liệt kê nhân viên giữ chức Quản lý ký túc xá
SELECT * FROM NhanVien
WHERE NhanVien.MaCongViec = N'CV01'


--24. Cập nhật sức chứa cho các loại phòng, với LP01 là phòng 8 người, LP02 là phòng 6 người,
-- LP03 là phòng 4 người, LP04 là phòng 3 người, LP05 là phòng 2 người
ALTER TABLE LoaiPhong
    ADD SucChua INT

UPDATE LoaiPhong
SET SucChua = CASE
                  WHEN LoaiPhong.MaLoaiPhong = 'LP01' THEN 8
                  WHEN LoaiPhong.MaLoaiPhong = 'LP02' THEN 6
                  WHEN LoaiPhong.MaLoaiPhong = 'LP03' THEN 4
                  WHEN LoaiPhong.MaLoaiPhong = 'LP04' THEN 3
                  WHEN LoaiPhong.MaLoaiPhong = 'LP05' THEN 2
    END

SELECT * FROM LoaiPhong

--25. Chèn nhân viên mới vào bảng nhân viên
INSERT INTO "NhanVien" ("MaNhanVien", "HoTen", "NgaySinh", "GioiTinh", "SoDienThoai", "MaCongViec") VALUES
    ('NV011', N'Nguyễn Văn Minh', N'Nam', '1990-06-15', '0912345678', N'123 Nguyễn Trãi, Hà Nội', N'Nhân viên lễ tân');

--26. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá
UPDATE NhanVien
SET MaCongViec = N'CV01'
WHERE MaNhanVien = 'NV010'

--27. Xóa nhân viên chưa từng lập hóa đơn nào
DELETE FROM NhanVien
WHERE MaNhanVien NOT IN (
    SELECT DISTINCT MaNhanVien FROM HoaDon
);


--30. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 20
SELECT Phong.MaPhong,Phong.TenPhong,LoaiPhong.TenPhong,SUM(SoLuong) as TongCSVC FROM LoaiPhong
                                                                                         JOIN Phong on Phong.MaLoaiPhong = LoaiPhong.MaLoaiPhong
                                                                                         JOIN LoaiPhong_CSVC on LoaiPhong.MaLoaiPhong = LoaiPhong_CSVC.MaLoaiPhong
                                                                                         JOIN LoaiCSVC on LoaiCSVC.MaLoaiCSVC = LoaiPhong_CSVC.MaLoaiCSVC
GROUP BY Phong.MaPhong,Phong.TenPhong,LoaiPhong.TenPhong
HAVING SUM(SoLuong) > 20

--31. Liệt kê phòng có sức chứa lớn hơn 4
SELECT * FROM Phong
                  JOIN LoaiPhong LP on LP.MaLoaiPhong = Phong.MaLoaiPhong
WHERE SucChua >= 4
ORDER BY SucChua DESC
--32.