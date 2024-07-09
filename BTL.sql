CREATE PROC procThemTK
@username VARCHAR(20),
@passwordd VARCHAR(20)
AS
INSERT INTO tblAccount(username,passwordd,rolee)
VALUES(@username,@passwordd,N'Nhân viên')

CREATE VIEW v_TK
AS
SELECT id AS [STT], username AS [Tài khoản],passwordd AS [Mật khấu] 
FROm tblAccount


FROM tblAccount




CREATE PROC XoaTK
@username VARCHAR(20)
AS
DELETE tblAccount
WHERE username = @username

SELECT * FROM tblAccount

CREATE PROC DoiMK
@username VARCHAR(20),
@passwordd VARCHAR(20)
AS
UPDATE tblAccount
SET passwordd = @passwordd WHERE username=@username


CREATE VIEW v_NV
AS
SELECT idEmployee AS [Mã nhân viên], username AS [Tài khoản] ,fullName [Họ tên], gender AS [Giới tính],convert(varchar(10),birthday,103) AS [Ngày sinh], adress AS [Địa chỉ], phoneNumber AS [SDT]
FROM tblEmployee 

SELECT * FROM v_NV


CREATE PROC procThemNhanVien
@username VARCHAR(20),
@fullName NVARchAR(50),
@gender NVARChAR(10),
@birthday DATE,
@adress NVARCHAR(50),
@phoneNumber VARCHAR(10)
AS
INSERT INTO tblEmployee(username,fullName,gender,birthday,adress,phoneNumber)
VALUES(@username,@fullName,@gender,@birthday,@adress,@phoneNumber)

CREATE PROC procXoaNV
@idEmployee INT
AS
DELETE FROM tblEmployee WHERE tblEmployee.idEmployee = @idEmployee

select * from tblAccount, tblEmployee WHERE tblAccount.username = 'user1' and tblAccount.username = tblEmployee.username

CREATE PROC procSuaNV
@idEmployee INT,
@fullName NVARchAR(50),
@gender NVARChAR(10),
@birthday DATE,
@adress NVARCHAR(50),
@phoneNumber VARCHAR(10)
AS
UPDATE tblEmployee
SET fullname = @fullName,
gender = @gender,
birthday = @birthday,
adress = @adress,
phoneNumber = @phoneNumber
WHERE idEmployee = @idEmployee

CREATE VIEW v_KhachHang
AS
SELECT idCustomer AS [Mã khách hàng],fullName AS [Họ tên], gender AS [Giới tính],convert(varchar(10),birthday,103) AS [Ngày sinh], adress AS [Địa chỉ], phoneNumber AS [SDT]
FROM tblCustomer

SELECT * FROM v_KhachHang

CREATE PROC procThemKhachHang
@fullName NVARCHAR(50),
@gender NVARCHAR(3),
@birthday DATE,
@adress NVARCHAR(50),
@phoneNumber VARCHAR(10)
AS
INSERT INTO tblCustomer(fullName,gender,birthday,adress,phoneNumber)
VALUES(@fullName,@gender,@birthday,@adress,@phoneNumber)

CREATE PROC procXoaKhachHang
@idCustomer INT
AS
DELETE FROM tblCustomer
WHERE idCustomer = @idCustomer

CREATE PROC procSuaKh
@idCustomer INT,
@fullName NVARCHAR(50),
@gender NVARCHAR(3),
@birthday DATE,
@adress NVARCHAR(50),
@phoneNumber VARCHAR(10)
AS
UPDATE tblCustomer
SET fullName=@fullName,
gender=@gender,
birthday=@birthday,
adress=@adress,
phoneNumber=@phoneNumber
WHERE idCustomer=@idCustomer

CREATE VIEW v_tblWarranty
AS
SELECT
	tblWarranty.idWarranty AS [Mã bảo hành],
	tblWarranty.typee AS [Loại bảo hành],
	tblWarranty.timeWarranty AS [Thời gian bảo hành],
	convert(varchar(10),tblWarranty.dateEnd,103) AS [Ngày kết thúc bảo hành],
	tblWarranty.support AS [Hệ thống hỗ trợ],
	tblWarranty.note AS [Ghi chú]
FROM tblWarranty;
SELECT * FROM v_tblWarranty;

ALTER PROC sp_AddWarranty
@typee NVARCHAR(30),
@support NVARCHAR(50),
@note NVARCHAR(50),
@timeWarranty INT
AS
INSERT INTO tblWarranty VALUES(@typee,null,@support,@note,@timeWarranty,null);


INSERT INTO tblWarranty VALUES('1',null,'1','1',1,null);
CREATE PROC sp_DeleteWarranty
@idWarranty INT
AS
DELETE FROM tblWarranty WHERE tblWarranty.idWarranty = @idWarranty;

CREATE PROC sp_UpdateWarranty
    @idWarranty INT,
    @typee NVARCHAR(30),
    @support NVARCHAR(50),
    @note NVARCHAR(50)
AS
UPDATE tblWarranty
SET 
    typee = @typee,
    support = @support,
    note = @note
WHERE
    idWarranty = @idWarranty;

CREATE VIEW v_HoaDon
AS
SELECT idBill AS [Mã hóa đơn], tblBill.idCustomer AS[Mã khách hàng] ,tblCustomer.fullName AS[Tên khách hàng], tblBill.idEmployee AS[Mã nhân viên], 
tblEmployee.fullName AS[Tên nhân viên], convert(varchar(10),tblBill.datee,103) AS[Ngày lập],totalPrice AS[Tổng tiền], CASE WHEN statuss = 1 THEN N'Đã thanh toán' ELSE N'Chưa thanh toán' END AS[Trạng thái],amount AS[Số lượng]
FROM tblBill, tblCustomer, tblEmployee 
WHERE tblBill.idCustomer = tblCustomer.idCustomer  
AND tblBill.idEmployee = tblEmployee.idEmployee 

SELECT * FROM v_HoaDon

SELECT * FROM v_HoaDon WHERE 1=1 AND v_HoaDon.[Tổng tiền] BETWEEN 1000 AND 4000

CREATE VIEW v_CTHD
AS
SELECT idBillDetails AS [Mã chi tiết hóa đơn],
idBill AS [Mã hóa đơn], d.idDevice AS [Mã điện thoại]
,deviceName AS [Tên điện thoại],w.timeWarranty AS [Bảo hành (tháng)] ,
typee AS [Loại bảo hành],
bd.price AS [Thành tiền]
,VAT AS [Thuế VAT],
sale AS [Giảm giá] 
FROM tblBillDetails bd 
INNER JOIN tblDevice d ON d.idDevice= bd.idDevice 
INNER JOIN tblWarranty w ON w.idWarranty=bd.idWarranty 


CREATE PROC LayDataBaoCao
@mahoadon int
AS
SELECT datee, b.idBill,e.fullName AS [tennv],e.idEmployee,c.fullName AS [tenkhach],c.adress,c.phoneNumber,bd.idDevice,d.deviceName,wr.timeWarranty,VAT,sale,bd.price,totalPrice,CASE WHEN statuss = 1 THEN N'Ðã thanh toán' ELSE N'Chưa thanh toán' END AS [trangthai] FROM tblBill b
INNER JOIN tblEmployee e ON b.idEmployee=e.idEmployee
INNER JOIN tblCustomer c ON b.idCustomer=c.idCustomer
INNER JOIN tblBillDetails bd ON b.idBill=bd.idBill
INNER JOIN tblWarranty wr ON wr.idWarranty = bd.idWarranty
INNER JOIN tblDevice d ON bd.idDevice=d.idDevice
WHERE bd.idBill=@mahoadon

SELECT * FROM tblBillDetails

INSERT INTO tblBillDetails VALUES (12,20,16,0,0,0)


SELECT * FROM tblWarranty



