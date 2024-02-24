

--membuat database
create database MarketPlace

--menjalankan database
go
use MarketPlace

-- Tabel untuk Akun
CREATE TABLE Akun (
    AkunID varchar(10) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Pass VARCHAR(50) NOT NULL,
    TglRegister DATETIME NOT NULL,
    RoleAkun VARCHAR(50) NOT NULL

	CONSTRAINT PK_Akun_AkunID PRIMARY KEY (AkunID),
	CONSTRAINT UQ_AkunID UNIQUE (AkunID)
);


-- Tabel untuk Admin
CREATE TABLE Admin (
    AdminID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL

	CONSTRAINT PK_Admin_AdminID PRIMARY KEY (AdminID),
	CONSTRAINT UQ_AdminID UNIQUE (AdminID),
	constraint FK_Admin_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Kota
CREATE TABLE Kota (
    KotaID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	NamaKota VARCHAR(50) NOT NULL

	CONSTRAINT PK_Kota_KotaID PRIMARY KEY (KotaID),
	CONSTRAINT UQ_KotaID UNIQUE (KotaID),
	constraint FK_Kota_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Pembeli
CREATE TABLE Pembeli (
    PembeliID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL,
	TanggalLahir date not null,
	TempatLahir varchar(50),
	JenisKelamin Varchar(10)

	CONSTRAINT PK_Pembeli_PembeliID PRIMARY KEY (PembeliID),
	CONSTRAINT UQ_PembeliID UNIQUE (PembeliID),
	constraint FK_Pembeli_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_Pembeli_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Penjual
CREATE TABLE Penjual (
    PenjualID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL,
	TanggalLahir date not null,
	TempatLahir varchar(50),
	JenisKelamin Varchar(10),
	Alamat Varchar(100)

	CONSTRAINT PK_Penjual_PenjualID PRIMARY KEY (PenjualID),
	CONSTRAINT UQ_PenjualID UNIQUE (PenjualID),
	constraint FK_Penjual_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_Penjual_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk AlamatPembeli
CREATE TABLE AlamatPembeli (
    AlamatPembeliID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	AlamatDetail VARCHAR(100) NOT NULL
    
	CONSTRAINT PK_AlamatPembeli_AlamatPembeliID PRIMARY KEY (AlamatPembeliID),
	CONSTRAINT UQ_AlamatPembeliID UNIQUE (AlamatPembeliID),
	constraint FK_AlamatPembeli_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_AlamatPembeli_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Toko
CREATE TABLE Toko (
    TokoID varchar(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaToko VARCHAR(50) NOT NULL,
	AlamatToko Varchar(100) Not null
    
	CONSTRAINT PK_Toko_TokoID PRIMARY KEY (TokoID),
	CONSTRAINT UQ_TokoID UNIQUE (TokoID),
	constraint FK_Toko_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Ekspedisi
CREATE TABLE Ekspedisi (
    EkspedisiID varchar(10) NOT NULL,
	AdminID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaEkspedisi VARCHAR(50) NOT NULL,
	OngkirPerKm int Not null
    
	CONSTRAINT PK_Ekspedisi_EkspedisiID PRIMARY KEY (EkspedisiID),
	CONSTRAINT UQ_EkspedisiID UNIQUE (EkspedisiID),
	constraint FK_Ekspedisi_AdminID Foreign Key (AdminID) References dbo.Admin(AdminID),
	constraint FK_Ekspedisi_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk ProdukKategori
CREATE TABLE Kategori (
    KategoriID varchar(10) NOT NULL,
	AdminID VARCHAR(10) NOT NULL,
	NamaKategori VARCHAR(50) NOT NULL
    
	CONSTRAINT PK_Kategori_KategoriID PRIMARY KEY (KategoriID),
	CONSTRAINT UQ_KategoriID UNIQUE (KategoriID),
	constraint FK_Kategori_AdminID Foreign Key (AdminID) References dbo.Admin(AdminID)
);


-- Tabel untuk Wallet
CREATE TABLE Wallet (
    WalletID varchar(10) NOT NULL,
	AkunID VARCHAR(10) NOT NULL,
	Nominal int NOT NULL
    
	CONSTRAINT PK_Wallet_WalletID PRIMARY KEY (WalletID),
	CONSTRAINT UQ_WalletID UNIQUE (WalletID),
	constraint FK_Wallet_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Produk
CREATE TABLE Produk (
    ProdukID varchar(10) NOT NULL,
	KategoriID VARCHAR(10) NOT NULL,
	TokoID VARCHAR(10) NOT NULL,
	NamaProduk Varchar(100),
	Harga int not null,
	Deskripsi varchar(100),
	Stok int,
	TglMulaiJual datetime
    
	CONSTRAINT PK_Produk_ProdukID PRIMARY KEY (ProdukID),
	CONSTRAINT UQ_ProdukID UNIQUE (ProdukID),
	constraint FK_Produk_KategoriID Foreign Key (KategoriID) References dbo.Kategori(KategoriID),
	constraint FK_Produk_TokoID Foreign Key (TokoID) References dbo.Toko(TokoID)
);
ALTER TABLE Produk
ADD MinQuantity int not null;


-- Tabel untuk Diskusi
CREATE TABLE Diskusi (
    DiskusiID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Question varchar(200)
    
	CONSTRAINT PK_Diskusi_DiskusiID PRIMARY KEY (DiskusiID),
	CONSTRAINT UQ_DiskusiID UNIQUE (DiskusiID),
	constraint FK_Diskusi_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Diskusi_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);


-- Tabel untuk Review
CREATE TABLE Review (
    ReviewID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Rating Varchar(5),
	Question varchar(200)
    
	CONSTRAINT PK_Review_ReviewID PRIMARY KEY (ReviewID),
	CONSTRAINT UQ_ReviewID UNIQUE (ReviewID),
	constraint FK_Review_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Review_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);



-- Tabel untuk Cart
CREATE TABLE Cart (
    CartID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Quantity int not null
    
	CONSTRAINT PK_Cart_CartID PRIMARY KEY (CartID),
	CONSTRAINT UQ_CartID UNIQUE (CartID),
	constraint FK_Cart_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Cart_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);


-- Tabel untuk Transaksi
CREATE TABLE Transaksi (
    TransaksiID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	PenjualID VARCHAR(10) NOT NULL,
	EkspedisiID VARCHAR(10) NOT NULL,
	TotalTransaksi int,
	TanggalTransaksi datetime
    
	CONSTRAINT PK_Transaksi_TransaksiID PRIMARY KEY (TransaksiID),
	CONSTRAINT UQ_TransaksiID UNIQUE (TransaksiID),
	constraint FK_Transaksi_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Transaksi_PenjualID Foreign Key (PenjualID) References dbo.Penjual(PenjualID),
	constraint FK_Transaksi_EkspedisiID Foreign Key (EkspedisiID) References dbo.Ekspedisi(EkspedisiID)
);


-- Tabel untuk Pembayaran
CREATE TABLE Pembayaran (
    PembayaranID varchar(10) NOT NULL,
	TransaksiID VARCHAR(10) NOT NULL,
	WalletID VARCHAR(10) NOT NULL,
	Jumlah int not null,
	TanggalPembayaran datetime
    
	CONSTRAINT PK_Pembayaran_PembayaranID PRIMARY KEY (PembayaranID),
	CONSTRAINT UQ_PembayaranID UNIQUE (PembayaranID),
	constraint FK_Pembayaran_TransaksiID Foreign Key (TransaksiID) References dbo.Transaksi(TransaksiID),
	constraint FK_Pembayaran_WalletID Foreign Key (WalletID) References dbo.Wallet(WalletID)
);


-- Tabel untuk TransaksiDetail
CREATE TABLE TransaksiDetail (
    TransaksiDetailID varchar(10) NOT NULL,
	TransaksiID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	QuantityTransaksi int not null,
	SubTotalTransaksi int
    
	CONSTRAINT PK_TransaksiDetail_TransaksiDetailID PRIMARY KEY (TransaksiDetailID),
	CONSTRAINT UQ_TransaksiDetailID UNIQUE (TransaksiDetailID),
	constraint FK_TransaksiDetail_TransaksiID Foreign Key (TransaksiID) References dbo.Transaksi(TransaksiID),
	constraint FK_TransaksiDetail_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);




--Data Untuk Tabel Akun
insert into Akun
values ('1','admin1','admin1','2024-02-05','Admin'),
('2','admin2','admin2','2024-02-05','Admin'),
('3','pembeli1','pembeli1','2024-02-05','Pembeli'),
('4','pembeli2','pembeli2','2024-02-05','Pembeli'),
('5','penjual1','penjual1','2024-02-05','Penjual'),
('6','penjual2','penjual2','2024-02-05','Penjual')
;
select *
from Akun

--Data Untuk Tabel Admin
insert into Admin
values ('1','1','Alvenio','Farhan'),
('2','2','Budi','Pekerti');
select *
from Admin


--Data Untuk Tabel Admin
insert into Kota
values('1','1','Semarang'),
('2','2','Jakarta'),
('3','3','Bandung'),
('4','4','Semarang'),
('5','5','Jakarta'),
('6','6','Bandung')
;
select * from Kota



--Data Untuk Tabel Pembeli
insert into Pembeli
values('1','3','3','Alisa','Magda','1980-02-05','Bandung','Wanita'),
('2','4','4','Gundahar','Aziz','1995-11-28','Semarang','Pria')
;
select * from Kota
select * from Pembeli
update Pembeli
set TempatLahir = 'Semarang'
where PembeliID = 2


--Data Untuk Tabel Penjual
insert into Penjual
values ('1','5','5','Jia','Alfred','1995-01-30','Jakarta','Wanita','Jalan Terus'),
('2','6','6','Sandhya','Justinas','1989-08-18','Bandung','Pria','Jalan Maju')
;
select * from Penjual



--Data Untuk Tabel AlamatPembeli
insert into AlamatPembeli
values ('1','3','3','Jalan Bandung Tengah'),
('2','4','4','Jalan Semarang Selatan')
;
select * from AlamatPembeli


--Data Untuk Tabel Toko
insert into Toko
values ('1','5','Berkah Jaya','Jalan Jakarta Utara'),
('2','6','Maju Jaya','Jalan Bandung Barat')
;
select * from Toko


--Data Untuk Tabel Ekspedisi
insert into Ekspedisi
values ('1','1','1','TIKI','500'),
('2','2','2','JNE','700')
;
select * from Ekspedisi


--Data Untuk Tabel Ekspedisi
insert into Kategori
values ('1','1','Pakaian'),
('2','2','Makanan')
;
select * from Kategori

--Data Untuk Tabel Wallet
insert into Wallet
values ('1','3','50000'),
('2','4','100000'),
('3','5','20000'),
('4','6','150000')
;
select * from Wallet

----Data Untuk Tabel Produk
insert into Produk
values ('1','1','1','Baju Anak','30000','Baju Anak Lucu','5','2022-05-05','1'),
('2','2','2','Cireng','10000','Cireng Enak','10','2024-02-05','1')
;
select * from Produk
select * from Kategori
select * from Toko

--Data Untuk Tabel Diskusi
insert into Diskusi
values ('1','1','1','Adakah Baju Ukuran S?'),
('2','2','2','Ada varian rasa apa saja?')
;
select * from Diskusi


--Data Untuk Tabel Review
insert into Review
values ('1','1','1','4','Packing kurang rapi'),
('2','2','2','2','Rasanya aneh')
;
select * from Review


--Data Untuk Tabel Cart
insert into Cart
values ('1','1','1','2'),
('2','2','2','1')
;
select * from Cart


--Data Untuk Tabel Transaksi
insert into Transaksi
values('1','1','1','1','60000','2024-02-05'),
('2','2','2','1','10000','2024-02-04')
;
select * from Transaksi
select * from Penjual
select * from Ekspedisi
select * from Produk


--Data Untuk Tabel TransaksiDetail
insert into transaksidetail
values ('1','1','1','2','60000'),
('2','2','2','1','10000')
;
select * from transaksidetail
select * from Transaksi


--Data Untuk Tabel Pembayaran
insert into Pembayaran 
values ('1', '1', '1' ,'80000' ,'2024-02-05'),
('2', '2', '2' ,'31000' ,'2024-02-04')
;
select * from pembayaran 
select * from Ekspedisi
select * from Wallet
select * from transaksidetail
select * from Transaksi

select * from Cart
select * from Produk


