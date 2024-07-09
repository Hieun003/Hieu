CREATE DATABASE QLyBanDienThoai
GO 
USE QLyBanDienThoai
GO
CREATE TABLE tblAccount
(
	username VARCHAR(20) PRIMARY KEY,
	passwordd VARCHAR(20),
	rolee NVARCHAR(20)
);
SELECT * FROM tblAccount
ALTER TABLE tblAccount
ADD id INT IDENTITY
GO
CREATE TABLE tblEmployee 
(	
	idEmployee INT PRIMARY KEY IDENTITY,
	username VARCHAR(20) FOREIGN KEY REFERENCES tblAccount(username),
	fullName NVARCHAR(50),
	gender BIT,
	birthday DATE,
	adress NVARCHAR(50),
	phoneNumber VARCHAR(10)
);
--ALTER TABLE tblEmployee 
--ADD luong(trieu dong) FLOAT



CREATE TABLE tblCustomer 
(	
	idCustomer INT PRIMARY KEY IDENTITY,
	fullName NVARCHAR(50),
	gender BIT,
	birthday DATE,
	adress NVARCHAR(50),
	phoneNumber VARCHAR(10)
);
GO
CREATE TABLE tblDevice
(
	idDevice INT PRIMARY KEY IDENTITY,
	deviceName NVARCHAR(30),
	screen VARCHAR(10),
	operatingSystem NVARCHAR(30),
	camera VARCHAR(20),
	CPU VARCHAR(10),
	RAM VARCHAR(10),
	memory VARCHAR(10),
	SIM BIT,
	battery VARCHAR(10),
	color NVARCHAR(15),
	price FLOAT	
);
GO

CREATE TABLE tblImport
(
	idImport INT PRIMARY KEY IDENTITY,
	idDevice INT FOREIGN KEY REFERENCES tblDevice(idDevice),
	idEmployee INT FOREIGN KEY REFERENCES tblEmployee(idEmployee),
	amount INT,
	moneyy FLOAT
);

CREATE TABLE tblBill
(	
	idBill INT PRIMARY KEY IDENTITY,
	idCustomer INT FOREIGN KEY REFERENCES tblCustomer(idCustomer),
	idEmployee INT FOREIGN KEY REFERENCES tblEmployee(idEmployee),
	datee DATE,
	totalPrice FLOAT,
	statuss BIT,
);
GO
CREATE TABLE tblWarranty
(	
	idWarranty INT PRIMARY KEY IDENTITY,
	typee NVARCHAR(30),
	dateEnd DATE,
	support NVARCHAR(50),
	note NVARCHAR(50)
);
GO
ALTER TABLE tblWarranty
ADD timeWarranty INT
ALTER TABLE tblWarranty
ADD dateStart DATE


DECLARE DATESTARTCURSOR CURSOR FOR SELECT idWarranty FROM tblWarranty

OPEN DATESTARTCURSOR
DECLARE @idWarranty INT

FETCH NEXT FROM DATESTARTCURSOR INTO @idWarranty
WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE tblWarranty
	SET dateStart = (SELECT datee FROM v_Warranty WHERE v_Warranty.idWarranty = @idWarranty) WHERE tblWarranty.idWarranty = @idWarranty
	FETCH NEXT FROM DATESTARTCURSOR INTO @idWarranty
END
CLOSE DATESTARTCURSOR
DEALLOCATE DATESTARTCURSOR

SELECt * FROm tblWarranty

UPDATE tblWarranty
SET timeWarranty = DATEDIFF(Month,dateStart,dateEnd)

SELECT idWarranty FROM tblWarranty
CREATE VIEW v_Warranty
AS
SELECT idWarranty,datee
FROM tblBill
INNER JOIN tblBillDetails ON tblBill.idBill = tblBillDetails.idBill
GROUP BY idWarranty,datee



SELECT * FROM v_Warranty

SELECT idWarranty, datee
FROM tblWarranty,tblBill
WHERE tblWarranty.idWarranty = (SELECT idWarranty FROM tblBillDetails WHERE tblBillDetails.idBill=tblBill.idBill)







CREATE TABLE tblBillDetails
(	
	idBillDetails INT PRIMARY KEY IDENTITY,
	idBill INT FOREIGN KEY REFERENCES tblBill(idBill),
	idDevice INT FOREIGN KEY REFERENCES tblDevice(idDevice),
	idWarranty INT FOREIGN KEY REFERENCES tblWarranty(idWarranty),
	price FLOAT
);
GO 
ALTER TABLE tblBillDetails ADD VAT FLOAT
GO
ALTER TABLE tblBillDetails ADD sale FLOAT
GO 
ALTER TABLE tblBill	
ADD amount INT
GO
ALTER TABLE tblEmployee
ALTER COLUMN gender NVARCHAR(3)
GO
ALTER TABLE tblCustomer
ALTER COLUMN gender NVARCHAR(3)
GO
ALTER TABLE tblDevice
ALTER COLUMN screen VARCHAR(30)
GO
ALTER TABLE tblDevice
ALTER COLUMN CPU VARCHAR(30)
GO
ALTER TABLE tblWarranty
ALTER COLUMN note NVARCHAR(50)
--price = ((1-sale)*price(tblDevice))*(1+VAT)
--INSERT 
INSERT INTO tblAccount
VALUES
('user1', 'password1', N'Quản lý'),
('user2', 'password2', N'Quản lý'),
('user3', 'password3', N'Nhân viên'),
('user4', 'password4', N'Nhân viên'),
('user5', 'password5', N'Nhân viên'),
('user6', 'password6', N'Nhân viên'),
('user7', 'password7', N'Nhân viên'),
('user8', 'password8', N'Nhân viên'),
('user9', 'password9', N'Nhân viên'),
('user10', 'password10', N'Nhân viên');
GO
INSERT INTO tblEmployee 
VALUES
( 'user1', N'Nguyễn Lam Phương', N'Nam', '1990-05-15', N'Quận 7,TP.HCM', '0123456789'),
('user2', N'Trần Thu Ngân', N'Nữ', '1985-09-20', N'Long Biên ,Hà Nội', '0234567890'),
('user3', N'Lê Gia Vinh', N'Nam', '1988-03-10', N'Quận 3, TP.HCM', '0345678901'),
('user4', N'Hà Chi', N'Nữ', '1992-07-25', N'Tây Sơn, Bắc Ninh', '0456789012'),
('user5', N'Hoàng Đức Tuấn', N'Nam', '1980-12-05', N' Thái Bình', '0567890123'),
('user6', N'Gia Hân', N'Nữ', '1995-01-30', N'Hoàng Mai, Hà Nội', '0678901234'),
('user7', N'Hải Anh', N'Nam', '1983-11-18', N' Ninh Bình', '0789012345'),
('user8', N'Ngô Thùy Trang', N'Nữ', '1998-04-22', N'Hà Đông', '0890123456'),
('user9', N'Lê Hồng Phong', N'Nam', '1993-08-12', N' Hải Phòng', '0901234567'),
('user10', N'Phạm Thùy Chi', N'Nữ', '1987-06-08', N'Yên Phong, Bắc Ninh', '0912345678');
GO
INSERT INTO tblCustomer 
VALUES
( N'Trần Thị An', N'Nữ', '1990-05-15', N'Ba Đình, Hà Nội', '0123456789'),
( N'Nguyễn Vũ Dũng', N'Nam', '1985-09-20', N'An Khê, Gia Lai', '0234567890'),
(N'Lê Thị Cúc', N'Nữ', '1988-03-10', N'Long Biên, Hà Nội', '0345678901'),
(N'Phạm Văn Long', N'Nam', '1992-07-25', N'Long Biên, Hà Nội', '0456789012'),
( N'Nguyễn Thị Hải Anh', N'Nữ', '1980-12-05', N'Long Biên, Hà Nội', '0567890123'),
( N'Ngô Hồng Phong', N'Nam', '1995-01-30', N'An Khê, Gia Lai', '0678901234'),
( N'Mai Thị Hạ', N'Nữ', '1983-11-18', N'An Khê, Gia Lai', '0789012345'),
( N'Lê Văn Khoa', N'Nam', '1998-04-22', N'An Khê, Gia Lai', '0890123456'),
( N'Trần Thị Liên', N'Nữ', '1993-08-12', N'Ba Đình, Hà Nội', '0901234567'),
(N'Vũ Văn Minh', N'Nam', '1987-06-08', N'Ba Đình, Hà Nội', '0912345678');
GO 

INSERT INTO tblBill
VALUES
( 1, 1, '2024-03-01', 1000000, 1, 0),
( 2, 2, '2024-03-02', 1500000, 1, 0),
( 3, 3, '2024-03-03', 800000, 0, 0),
( 4, 4, '2024-03-04', 2000000, 1, 0),
( 5, 5, '2024-03-05', 300000, 0, 0),
( 6, 6, '2024-03-06', 1200000, 1, 0),
( 7, 7, '2024-03-07', 700000, 0, 0),
( 8, 8, '2024-03-08', 900000, 1, 0),
( 9, 9, '2024-03-09', 1100000, 1, 0),
( 10, 10, '2024-03-10', 500000, 0, 0);
GO 
INSERT INTO tblDevice 
VALUES
( N'Samsung Galaxy S21 Ultra', 'Dynamic AMOLED', N'Android', '108 MP', 'Exynos 2100', '12 GB', '256 GB', 1, '5000 mAh', N'Đen Bóng', 1299.99),
( N'iPhone 13 Pro Max', 'Super Retina XDR OLED', N'iOS', '12 MP', 'A15 Bionic', '6 GB', '512 GB', 0, '4352 mAh', N'Bạc', 1399.99),
(N'Google Pixel 6 Pro', 'OLED', N'Android', '50 MP', 'Google Tensor', '12 GB', '128 GB', 1, '5000 mAh', N'Đen', 899.99),
(N'OnePlus 9 Pro', 'Fluid AMOLED', N'Android', '48 MP', 'Snapdragon 888', '8 GB', '128 GB', 1, '4500 mAh', N'Xám', 969.99),
( N'Xiaomi Mi 11 Ultra', 'AMOLED', N'Android', '50 MP', 'Snapdragon 888', '12 GB', '256 GB', 1, '5000 mAh', N'Trắng', 1199.99),
( N'Samsung Galaxy Z Fold 3', 'Dynamic AMOLED', N'Android', '12 MP', 'Snapdragon 888', '12 GB', '256 GB', 1, '4400 mAh', N'Xanh Bóng', 1799.99),
( N'iPhone 13 Mini', 'Super Retina XDR OLED', N'iOS', '12 MP', 'A15 Bionic', '4 GB', '128 GB', 0, '2438 mAh', N'Ánh Sáng', 699.99),
( N'Google Pixel 5a', 'OLED', N'Android', '12.2 MP', 'Snapdragon 765G', '6 GB', '128 GB', 1, '4680 mAh', N'Đỏ', 449.99),
( N'OnePlus Nord 2', 'AMOLED', N'Android', '50 MP', 'MediaTek Dimensity 1200', '12 GB', '256 GB', 1, '4500 mAh', N'Xám', 499.99),
( N'Xiaomi Redmi Note 11 Pro+', 'AMOLED', N'Android', '108 MP', 'Snapdragon 695', '8 GB', '256 GB', 1, '5000 mAh', N'Xanh Dương', 399.99),
( N'Samsung Galaxy A52s 5G', 'Super AMOLED', N'Android', '64 MP', 'Snapdragon 778G', '6 GB', '128 GB', 1, '4500 mAh', N'Đen', 499.99),
( N'iPhone SE (2022)', 'Retina IPS LCD', N'iOS', '12 MP', 'A15 Bionic', '4 GB', '256 GB', 0, '2015 mAh', N'Đỏ', 599.99),
( N'Google Pixel 4a', 'OLED', N'Android', '12.2 MP', 'Snapdragon 730G', '6 GB', '128 GB', 1, '3140 mAh', N'Đen', 349.99),
( N'OnePlus 8T', 'Fluid AMOLED', N'Android', '48 MP', 'Snapdragon 865', '8 GB', '128 GB', 1, '4500 mAh', N'Đen', 599.99),
( N'Xiaomi Poco X3 Pro', 'IPS LCD', N'Android', '48 MP', 'Snapdragon 860', '6 GB', '128 GB', 1, '5160 mAh', N'Đen', 249.99),
( N'Samsung Galaxy M52 5G', 'Super AMOLED Plus', N'Android', '64 MP', 'Snapdragon 778G', '8 GB', '128 GB', 1, '5000 mAh', N'Đen', 429.99),
( N'iPhone 12', 'Super Retina XDR OLED', N'iOS', '12 MP', 'A14 Bionic', '4 GB', '128 GB', 0, '2815 mAh', N'Xanh Lam', 799.99),
( N'Google Pixel 6', 'OLED', N'Android', '50 MP', 'Google Tensor', '8 GB', '128 GB', 1, '4614 mAh', N'Đen', 699.99),
( N'OnePlus 9R', 'Fluid AMOLED', N'Android', '48 MP', 'Snapdragon 870', '8 GB', '128 GB', 1, '4500 mAh', N'Đen', 699.99),
( N'Xiaomi Redmi Note 11', 'IPS LCD', N'Android', '50 MP', 'MediaTek Helio G88', '4 GB', '64 GB', 1, '5000 mAh', N'Đen', 199.99);
GO
INSERT INTO tblWarranty 
VALUES
(N'Bảo hành bình thường', '2024-12-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành vàng', '2025-06-30', N'Trung tâm bảo hành chính hăng', N'Thời gian bảo hành mở rộng thêm 6 tháng',null,null),
(N'Bảo hành bình thường', '2024-09-30', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành bình thường', '2025-03-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành bình thường', '2024-11-30', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành vàng', '2025-04-30', N'Trung tâm bảo hành chính hăng', N'Thời gian bảo hành mở rộng thêm 4 tháng',null,null),
(N'Bảo hành bình thường', '2024-08-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành bình thường', '2025-05-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành bình thường', '2024-10-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null),
(N'Bảo hành bình thường', '2025-01-31', N'Trung tâm bảo hành chính hăng', N'Không ghi chú',null,null);
GO
INSERT INTO tblBillDetails
VALUES
( 1, 1, 1, 0, 0.1, 0.15),
( 2, 2, 2, 0, 0, 0.12),
( 3, 4, 3, 0, 0.1, 0),
( 4, 7, 4, 0, 0.1, 0.1),
( 5, 11, 5, 0, 0.1, 0.12),
( 6, 15, 6, 0, 0.1, 0),
( 7, 19, 7, 0, 0.1, 0),
( 8, 1, 8, 0, 0.1, 0.15),
( 9, 5, 10, 0, 0.05, 0.1),
( 10, 9, 9, 0, 0.05, 0.15)
GO
SELECT * FROM tblBill
UPDATE tblBillDetails
SET price = ROUND((1+VAT)*((1-sale)*(SELECT tblDevice.price FROM tblDevice WHERE tblBillDetails.idDevice= tblDevice.idDevice)),2)
GO 
UPDATE tblBill 
SET totalPrice = (SELECT SUM(price) FROM tblBillDetails WHERE tblBill.idBill= tblBillDetails.idBill)
SELect * from tblBillDetails

UPDATE tblBill 
SET amount = (SELECT COUNT(*) FROM tblBillDetails WHERE tblBillDetails.idBill = tblBill.idBill)

CREATE TRIGGER trgUpdateBillDetails
ON tblBillDetails
AFTER INSERT
AS
BEGIN
	DECLARE @VAT FLOAT
	DECLARE @sale FLOAT
	SELECT @VAT = VAT FROM inserted
	SELECT @sale = sale FROM inserted
	UPDATE tblBillDetails
	SET price = ROUND((1+@VAT)*((1-@sale)*(SELECT tblDevice.price FROM tblDevice WHERE tblBillDetails.idDevice= tblDevice.idDevice)),2)
END


CREATE TRIGGER trgUpdateBill
ON tblBillDetails
AFTER INSERT
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill= idBill FROM inserted
	UPDATE tblBill 
	SET totalPrice = (SELECT SUM(price) FROM tblBillDetails WHERE tblBill.idBill= idBill) WHERE tblBill.idBill = @idBill
END
ALTER TRIGGER trgAmountBill
ON tblBillDetails
AFTER INSERT
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill=idBill FROM inserted
	UPDATE tblBill 
SET amount = (SELECT COUNT(*) FROM tblBillDetails WHERE tblBillDetails.idBill = tblBill.idBill) WHERE tblBill.idBill = @idBill
END
DECLARE DATESTARTCURSOR CURSOR FOR SELECT idWarranty FROM tblWarranty

OPEN DATESTARTCURSOR
DECLARE @idWarranty INT

FETCH NEXT FROM DATESTARTCURSOR INTO @idWarranty
WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE tblWarranty
	SET dateStart = (SELECT datee FROM v_Warranty WHERE v_Warranty.idWarranty = @idWarranty) WHERE tblWarranty.idWarranty = @idWarranty
	FETCH NEXT FROM DATESTARTCURSOR INTO @idWarranty
END
CLOSE DATESTARTCURSOR
DEALLOCATE DATESTARTCURSOR

SELECt * FROm tblWarranty

UPDATE tblWarranty
SET timeWarranty = DATEDIFF(Month,dateStart,dateEnd)

SELECT idWarranty FROM tblWarranty
CREATE VIEW v_Warranty
AS
SELECT idWarranty,datee
FROM tblBill
INNER JOIN tblBillDetails ON tblBill.idBill = tblBillDetails.idBill
GROUP BY idWarranty,datee

CREATE TRIGGER UpDateDatestart
ON tblBillDetails
AFTER INSERT
AS
BEGIN
DECLARE @idWarranty INT
SELECT @idWarranty = idWarranty FROM inserted
	UPDATE tblWarranty
	SET dateStart = (SELECT datee FROM tblBillDetails,tblBill WHERE tblBillDetails.idBill = tblBill.idBill and tblBillDetails.idWarranty = tblWarranty.idWarranty) WHERE tblWarranty.idWarranty = @idWarranty
	UPDATE tblWarranty
SET dateEnd = DATEADD(Month,timeWarranty,dateStart)
END

CREATE VIEW v_WarrantyNotExists AS
SELECT idWarranty FROM tblWarranty WHERE NOT EXISTS(SELECT DISTINCT idWarranty FROM tblBillDetails WHERE tblBillDetails.idWarranty = tblWarranty.idWarranty)
SELECT v_WarrantyNotExists.idWarranty,timeWarranty FROM v_WarrantyNotExists,tblWarranty WHERE v_WarrantyNotExists.idWarranty = tblWarranty.idWarranty

CREATE TRIGGER trgThemImport
ON tblImport
AFTER INSERT
AS
BEGIN
	UPDATE tblImport
	SET moneyy = tblImport.amount*(SELECT tblDevice.price FROM tblDevice WHERE tblImport.idDevice= tblDevice.idDevice)
END
INSERT INTO tblImport (idDevice, idEmployee, amount, moneyy)
VALUES
(1, 1, 10, 0),
(2, 2, 5,0),
(3, 3, 8, 0),
(4, 4, 12, 0),
(5, 5, 7, 0),
(6, 6, 3, 0),
(7, 7, 15, 0),
(8, 8, 9, 0),
(9, 9, 6, 0),
(10, 10, 11, 0);

SELECT * FROM tblImport

CREATE PROC procThemPhieuNhap
@idDevice INT,
@idEmployee INT,
@amount INT
AS
INSERT INTO tblImport(idDevice,idEmployee,amount,moneyy)
VALUES(@idDevice,@idEmployee,@amount,0);

CREATE PROC procSuaPhieuNhap
@idImport INT,
@idDevice INT,
@idEmployee INT,
@amount INT,
@moneyy FLOAT
AS
UPDATE tblImport
SET idDevice = @idDevice,
idEmployee = @idEmployee,
amount = @amount
WHERE idImport = @idImport;

CREATE PROC procXoaPhieuNhap
@idImport INT
AS
DELETE tblImport
WHERE tblImport.idImport = @idImport;

CREATE VIEW v_PhieuNhap
AS
SELECT idImport AS [Mã phiếu nhập],idDevice AS [Mã điện thoại],idEmployee AS [Mã nhân viên], amount AS [Số lượng], moneyy AS [Tổng tiền]
FROM tblImport
