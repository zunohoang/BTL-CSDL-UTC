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
WHERE SinhVien.GioiTinh = 'Nam'

--2. Liệt kê sinh viên có số điện thoại bắt đầu bằng '09'      :D???



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

SELECT t.TenToa, COUNT(sv.MaSinhVien) AS SoLuongSinhVien
FROM SinhVien sv
JOIN Phong p ON sv.MaPhong = p.MaPhong
JOIN Toa t ON p.MaToa = t.MaToa
GROUP BY t.TenToa
ORDER BY COUNT(sv.MaSinhVien) DESC

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

--11. Liệt kê hợp đồng có tổng số tiền lớn hơn 1.000.000

SELECT *
FROM HopDong hd
WHERE hd.GiaTien > 1000000

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

--15. Liệt kê hóa đơn và tên nhân viên lập hóa đơn

SELECT hd.*, nv.HoTen
FROM HoaDon hd
JOIN NhanVien nv ON hd.MaNhanVien = nv.MaNhanVien

--16. Liệt kê hóa đơn và số điện sử dụng

SELECT hd.*, hd.ChiSoDienCuoi - hd.ChiSoDienDau AS SoDienSuDung
FROM HoaDon hd

--17. Tính tổng tiền điện của từng phòng trong tháng 3 năm 2025

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau)*hd.DonGiaDien AS TienDien
FROM HoaDon hd
JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE MONTH(hd.NgayTao) - 1 = 3 AND YEAR(hd.NgayTao) = 2025

--18. Liệt kê các phòng có tổng số điện tiêu thụ trên 100, sắp xếp giảm dần

SELECT hd.MaHoaDon, p.MaPhong, (hd.ChiSoDienCuoi - hd.ChiSoDienDau) AS SoDienTieuThu
FROM HoaDon hd
JOIN Phong p ON hd.MaPhong = p.MaPhong
WHERE (hd.ChiSoDienCuoi - hd.ChiSoDienDau) > 100
ORDER BY SoDienTieuThu DESC

--19. Liệt kê các phòng thuộc tòa 01

SELECT p.MaPhong, p.TenPhong
FROM Phong p
WHERE p.MaPhong IN (SELECT p2.MaPhong
					FROM Phong p2
					JOIN Toa t ON p2.MaToa = t.MaToa
					WHERE t.MaToa = 'TOA01')

--20. Liệt kê phòng có sức chứa lớn hơn 4

SELECT p.MaPhong, p.TenPhong
FROM Phong p
JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong
WHERE lp.SucChua > 4

--21. Liệt kê tên phòng và tên loại phòng tương ứng

SELECT p.TenPhong, lp.TenPhong
FROM Phong p
JOIN LoaiPhong lp ON p.MaLoaiPhong = lp.MaLoaiPhong

--22. Cho biết tổng số lượng phòng của từng loại phòng

SELECT lp.MaLoaiPhong, lp.TenPhong, COUNT(p.MaPhong) AS SoLuongPhong
FROM LoaiPhong lp
JOIN Phong p ON lp.MaLoaiPhong = p.MaLoaiPhong
GROUP BY lp.MaLoaiPhong, lp.TenPhong

--23. Liệt kê nhân viên giữ chức Quản lý ký túc xá

SELECT *
FROM NhanVien nv
JOIN ViTriLamViec vt ON nv.MaCongViec = vt.MaCongViec
WHERE vt.TenCongViec = N'Quản lý ký túc xá'

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



--26. Cập nhật chức vụ cho nhân viên có mã NV010 thành Quản lý ký túc xá


--27. Xóa nhân viên chưa từng lập hóa đơn nào


--28. Liệt kê các cơ sở vật chất trong từng phòng -> dai vl ??


--29. Liệt kê các cơ sở vật chất có số lượng khả dụng nhỏ hơn 5


--30. Liệt kê phòng có tổng số cơ sở vật chất lớn hơn 10