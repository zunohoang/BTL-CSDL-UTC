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
WHERE SinhVien.GioiTinh = N'Nam'

--2. Liệt kê các sinh viên ở phòng 102

SELECT *
FROM SinhVien
WHERE SinhVien.MaPhong = N'P102'


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

--6. Đếm số sinh viên trong mỗi phòng -

SELECT p.MaPhong, COUNT(sv.MaSinhVien) AS SoSinhVien
FROM Phong p
LEFT JOIN SinhVien sv on p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong

--7. Cho biết những phòng có hơn 3 sinh viên ở -

SELECT p.MaPhong
FROM Phong p
LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong
HAVING COUNT(sv.MaSinhVien) > 3

--8. Liệt kê số lượng sinh viên trong mỗi tòa, sắp xếp giảm dần theo số lượng -

SELECT t.TenToa, COUNT(sv.MaSinhVien) AS SoLuongSinhVien
FROM Toa t
LEFT JOIN Phong p ON t.MaToa = p.MaToa
LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY t.TenToa
ORDER BY SoLuongSinhVien DESC;

--9. Liệt kê những phòng có số lượng sinh viên nhiều hơn số lượng sinh viên trung bình của tất cả các phòng -

WITH SVMoiPhong AS (
    SELECT p.MaPhong, COUNT(sv.MaSinhVien) as SoLuong
    FROM Phong p
             LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
    group by p.MaPhong
)
SELECT p.MaPhong, p.TenPhong
FROM Phong p
         LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong, p.TenPhong
HAVING COUNT(sv.MaSinhVien) > (SELECT AVG(SoLuong) FROM SVMoiPhong)

--10. Liệt kê các hợp đồng có thời gian kết thúc trong năm 2025

SELECT *
FROM HopDong hd
WHERE YEAR(hd.NgayKetThuc) = 2025

--11. Liệt kê hợp đồng có tổng số tiền lớn hơn 5.000.000

SELECT *
FROM HopDong hd
WHERE hd.GiaTien > 5000000

--12. Liệt kê hóa đơn và tên nhân viên lập hóa đơn

SELECT hd.*, nv.HoTen
FROM HoaDon hd
         JOIN NhanVien nv ON hd.MaNhanVien = nv.MaNhanVien

--13. Liệt kê hóa đơn và số điện sử dụng và tổng tiền điện  trên 800.000

SELECT hd.MaHoaDon, hd.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienSD, (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien AS TongTienDien
FROM HoaDon hd
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien > 800000

--14. Tính tổng tiền điện của từng phòng trong tháng 3 năm 2025 -

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien AS TienDien
FROM HoaDon hd
         JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE YEAR(hd.NgayTao) = 2025 AND MONTH(hd.NgayTao) = 4

--15. Liệt kê các phòng có tổng số điện tiêu thụ trên 240, sắp xếp giảm dần

SELECT hd.MaHoaDon, hd.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienSD
FROM HoaDon hd
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau) > 240
ORDER BY SoDienSD DESC

--16. Liệt kê các phòng thuộc tòa 01

SELECT p.MaPhong, p.TenPhong
FROM Phong p
WHERE p.MaPhong IN (SELECT p2.MaPhong
                    FROM Phong p2
                             JOIN Toa t ON p2.MaToa = t.MaToa
                    WHERE t.MaToa = N'TOA01')

--17. Liệt kê tên phòng và tên loại phòng tương ứng

SELECT p.TenPhong, lp.TenPhong
FROM Phong p
         JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong

--18. Cho biết tổng số lượng phòng của từng loại phòng

SELECT lp.MaLoaiPhong, lp.TenPhong, COUNT(p.MaPhong) AS SoLuongPhong
FROM LoaiPhong lp
         JOIN Phong p ON lp.MaLoaiPhong = p.MaLoaiPhong
GROUP BY lp.MaLoaiPhong, lp.TenPhong

--19. Liệt kê nhân viên giữ chức Quản lý ký túc xá

SELECT *
FROM NhanVien nv
         JOIN ViTriLamViec vt ON nv.MaCongViec = vt.MaCongViec
WHERE vt.TenCongViec = N'Quản lý ký túc xá'

--20. Cập nhật sức chứa cho các loại phòng, với LP01 là phòng 8 người, LP02 là phòng 6 người,
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

--21. Chèn nhân viên mới vào bảng nhân viên

INSERT INTO "NhanVien" ("MaNhanVien", "HoTen", "NgaySinh", "GioiTinh", "SoDienThoai", "MaCongViec")
VALUES ('NV011', N'Nguyễn Văn Minh',  '1990-06-15', 'Nam', '0912345678', 'CV01');

--22. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá

UPDATE NhanVien
SET MaCongViec = 'CV01'
WHERE MaNhanVien = 'NV010'

--23. Xóa nhân viên chưa từng lập hóa đơn nào

DELETE FROM NhanVien
WHERE MaNhanVien NOT IN (
    SELECT hd.MaNhanVien
    FROM HoaDon hd)

--24. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 5

SELECT p.MaPhong, p.TenPhong, lp.TenPhong, COUNT(lcsvc.MaLoaiCSVC) AS TongCSVC
FROM LoaiPhong lp
         JOIN Phong p ON p.MaLoaiPhong = lp.MaLoaiPhong
         JOIN LoaiPhong_CSVC lpcsvc on lp.MaLoaiPhong = lpcsvc.MaLoaiPhong
         JOIN LoaiCSVC lcsvc on lcsvc.MaLoaiCSVC = lpcsvc.MaLoaiCSVC
GROUP BY p.MaPhong, p.TenPhong, lp.TenPhong
HAVING COUNT(lcsvc.MaLoaiCSVC) > 5

--25.	Liệt kê phòng có sức chứa lớn hơn 4

SELECT *
FROM Phong p
         JOIN LoaiPhong lp on p.MaLoaiPhong = lp.MaLoaiPhong
WHERE lp.SucChua > 4



-- Dưới bỏ



--12. Chèn một hợp đồng mới cho sinh viên có mã 'SV090'




--13. Cập nhật tổng số tiền cho các hợp đồng kết thúc năm 2025

ALTER TABLE HOPDONG

UPDATE HopDong
SET GiaTien =
        (SELECT lp.Gia * HopDong.SoThang
         FROM Phong p
                  JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
         WHERE p.MaPhong = HopDong.MaPhong)

SELECT * FROM HopDong

--14. Xóa các hợp đồng đã kết thúc trước năm 2020

DELETE FROM HopDong
WHERE YEAR(HopDong.NgayKetThuc) < 2020



--16. Liệt kê hóa đơn và số điện sử dụng

SELECT hd.*, hd.ChiSoDienCuoi - hd.ChiSoDienDau AS SoDienSuDung
FROM HoaDon hd



--18. Liệt kê các phòng có tổng số điện tiêu thụ trên 100 trong thang 3 nam 2025, sắp xếp giảm dần

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienTieuThu
FROM HoaDon hd
         JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau) > 100 AND YEAR(hd.NgayTao) = 2025 AND MONTH(hd.NgayTao) = 4
ORDER BY SoDienTieuThu DESC



--20. Liệt kê phòng có sức chứa lớn hơn 4

SELECT p.MaPhong, p.TenPhong
FROM Phong p
         JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
WHERE lp.SucChua > 4


--25. Chèn nhân viên mới vào bảng nhân viên



--26. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá


--27. Xóa nhân viên chưa từng lập hóa đơn nào


--28. Liệt kê các cơ sở vật chất trong phong P506

SELECT p.MaPhong, p.TenPhong, lp.TenPhong, lc.TenLoaiCSVC, lpcsvc.SoLuong
FROM LoaiPhong lp
         JOIN Phong p ON p.MaLoaiPhong = lp.MaLoaiPhong
         JOIN LoaiPhong_CSVC lpcsvc on lp.MaLoaiPhong = lpcsvc.MaLoaiPhong
         JOIN LoaiCSVC lc on lc.MaLoaiCSVC = lpcsvc.MaLoaiCSVC
WHERE MaPhong = N'P506';

--29. Liệt kê các cơ sở vật chất có số lượng khả dụng nhỏ hơn 5


--30. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 10
Hoàng
Nguyễn Văn Hoàng
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
WHERE SinhVien.GioiTinh = N'Nam'

--2. Liệt kê các sinh viên ở phòng 102

SELECT *
FROM SinhVien
WHERE SinhVien.MaPhong = N'P102'


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

--6. Đếm số sinh viên trong mỗi phòng -

SELECT p.MaPhong, COUNT(sv.MaSinhVien) AS SoSinhVien
FROM Phong p
LEFT JOIN SinhVien sv on p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong

--7. Cho biết những phòng có hơn 3 sinh viên ở -

SELECT p.MaPhong
FROM Phong p
LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong
HAVING COUNT(sv.MaSinhVien) > 3

--8. Liệt kê số lượng sinh viên trong mỗi tòa, sắp xếp giảm dần theo số lượng -

SELECT t.TenToa, COUNT(sv.MaSinhVien) AS SoLuongSinhVien
FROM Toa t
LEFT JOIN Phong p ON t.MaToa = p.MaToa
LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY t.TenToa
ORDER BY SoLuongSinhVien DESC;

--9. Liệt kê những phòng có số lượng sinh viên nhiều hơn số lượng sinh viên trung bình của tất cả các phòng -

WITH SVMoiPhong AS (
    SELECT p.MaPhong, COUNT(sv.MaSinhVien) as SoLuong
    FROM Phong p
             LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
    group by p.MaPhong
)
SELECT p.MaPhong, p.TenPhong
FROM Phong p
         LEFT JOIN SinhVien sv ON p.MaPhong = sv.MaPhong
GROUP BY p.MaPhong, p.TenPhong
HAVING COUNT(sv.MaSinhVien) > (SELECT AVG(SoLuong) FROM SVMoiPhong)

--10. Liệt kê các hợp đồng có thời gian kết thúc trong năm 2025

SELECT *
FROM HopDong hd
WHERE YEAR(hd.NgayKetThuc) = 2025

--11. Liệt kê hợp đồng có tổng số tiền lớn hơn 5.000.000

SELECT *
FROM HopDong hd
WHERE hd.GiaTien > 5000000

--12. Liệt kê hóa đơn và tên nhân viên lập hóa đơn

SELECT hd.*, nv.HoTen
FROM HoaDon hd
         JOIN NhanVien nv ON hd.MaNhanVien = nv.MaNhanVien

--13. Liệt kê hóa đơn và số điện sử dụng và tổng tiền điện  trên 800.000

SELECT hd.MaHoaDon, hd.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienSD, (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien AS TongTienDien
FROM HoaDon hd
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien > 800000

--14. Tính tổng tiền điện của từng phòng trong tháng 3 năm 2025 -

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien AS TienDien
FROM HoaDon hd
         JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE YEAR(hd.NgayTao) = 2025 AND MONTH(hd.NgayTao) = 4

--15. Liệt kê các phòng có tổng số điện tiêu thụ trên 240, sắp xếp giảm dần

SELECT hd.MaHoaDon, hd.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienSD
FROM HoaDon hd
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau) > 240
ORDER BY SoDienSD DESC

--16. Liệt kê các phòng thuộc tòa 01

SELECT p.MaPhong, p.TenPhong
FROM Phong p
WHERE p.MaPhong IN (SELECT p2.MaPhong
                    FROM Phong p2
                             JOIN Toa t ON p2.MaToa = t.MaToa
                    WHERE t.MaToa = N'TOA01')

--17. Liệt kê tên phòng và tên loại phòng tương ứng

SELECT p.TenPhong, lp.TenPhong
FROM Phong p
         JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong

--18. Cho biết tổng số lượng phòng của từng loại phòng

SELECT lp.MaLoaiPhong, lp.TenPhong, COUNT(p.MaPhong) AS SoLuongPhong
FROM LoaiPhong lp
         JOIN Phong p ON lp.MaLoaiPhong = p.MaLoaiPhong
GROUP BY lp.MaLoaiPhong, lp.TenPhong

--19. Liệt kê nhân viên giữ chức Quản lý ký túc xá

SELECT *
FROM NhanVien nv
         JOIN ViTriLamViec vt ON nv.MaCongViec = vt.MaCongViec
WHERE vt.TenCongViec = N'Quản lý ký túc xá'

--20. Cập nhật sức chứa cho các loại phòng, với LP01 là phòng 8 người, LP02 là phòng 6 người,
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

--21. Chèn nhân viên mới vào bảng nhân viên

INSERT INTO "NhanVien" ("MaNhanVien", "HoTen", "NgaySinh", "GioiTinh", "SoDienThoai", "MaCongViec")
VALUES ('NV011', N'Nguyễn Văn Minh',  '1990-06-15', 'Nam', '0912345678', 'CV01');

--22. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá

UPDATE NhanVien
SET MaCongViec = 'CV01'
WHERE MaNhanVien = 'NV010'

--23. Xóa nhân viên chưa từng lập hóa đơn nào

DELETE FROM NhanVien
WHERE MaNhanVien NOT IN (
    SELECT hd.MaNhanVien
    FROM HoaDon hd)

--24. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 20

SELECT Phong.MaPhong,Phong.TenPhong,LoaiPhong.TenPhong,SUM(LoaiPhong_CSVC.SoLuong) as TongCSVC FROM LoaiPhong
JOIN Phong on Phong.MaLoaiPhong = LoaiPhong.MaLoaiPhong
JOIN LoaiPhong_CSVC on LoaiPhong.MaLoaiPhong = LoaiPhong_CSVC.MaLoaiPhong
GROUP BY Phong.MaPhong,Phong.TenPhong,LoaiPhong.TenPhong
HAVING SUM(LoaiPhong_CSVC.SoLuong) > 20

--25.	Liệt kê phòng có sức chứa lớn hơn 4

SELECT *
FROM Phong p
         JOIN LoaiPhong lp on p.MaLoaiPhong = lp.MaLoaiPhong
WHERE lp.SucChua > 4



-- Dưới bỏ



--12. Chèn một hợp đồng mới cho sinh viên có mã 'SV090'




--13. Cập nhật tổng số tiền cho các hợp đồng kết thúc năm 2025

ALTER TABLE HOPDONG

UPDATE HopDong
SET GiaTien =
        (SELECT lp.Gia * HopDong.SoThang
         FROM Phong p
                  JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
         WHERE p.MaPhong = HopDong.MaPhong)

SELECT * FROM HopDong

--14. Xóa các hợp đồng đã kết thúc trước năm 2020

DELETE FROM HopDong
WHERE YEAR(HopDong.NgayKetThuc) < 2020



--16. Liệt kê hóa đơn và số điện sử dụng

SELECT hd.*, hd.ChiSoDienCuoi - hd.ChiSoDienDau AS SoDienSuDung
FROM HoaDon hd



--18. Liệt kê các phòng có tổng số điện tiêu thụ trên 100 trong thang 3 nam 2025, sắp xếp giảm dần

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienTieuThu
FROM HoaDon hd
         JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau) > 100 AND YEAR(hd.NgayTao) = 2025 AND MONTH(hd.NgayTao) = 4
ORDER BY SoDienTieuThu DESC



--20. Liệt kê phòng có sức chứa lớn hơn 4

SELECT p.MaPhong, p.TenPhong
FROM Phong p
         JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
WHERE lp.SucChua > 4


--25. Chèn nhân viên mới vào bảng nhân viên



--26. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá


--27. Xóa nhân viên chưa từng lập hóa đơn nào


--28. Liệt kê các cơ sở vật chất trong phong P506

SELECT p.MaPhong, p.TenPhong, lp.TenPhong, lc.TenLoaiCSVC, lpcsvc.SoLuong
FROM LoaiPhong lp
         JOIN Phong p ON p.MaLoaiPhong = lp.MaLoaiPhong
         JOIN LoaiPhong_CSVC lpcsvc on lp.MaLoaiPhong = lpcsvc.MaLoaiPhong
         JOIN LoaiCSVC lc on lc.MaLoaiCSVC = lpcsvc.MaLoaiCSVC
WHERE MaPhong = N'P506';

--29. Liệt kê các cơ sở vật chất có số lượng khả dụng nhỏ hơn 5


--30. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 10