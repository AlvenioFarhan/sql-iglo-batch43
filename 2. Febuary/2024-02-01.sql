use Sekolah

--create alter drop
--insert update delete(Hapus spesifik) truncate(Hapus Semua)

--insert
--insert into namatable(nama kolom)
--values (....?), (....?)

insert into MataPelajaran (Nama)
values
('Bahasa Indonesia'), ('Bahasa Inggris'), ('Agama'),('Matematika'),
('Biologi'), ('Fisika'), ('Kimia')

select * from Guru

insert into Guru
(NIP, NamaLengkap,TempatLahir,TanggalLahir,JenisKelamin,TanggalMulaiBekerja, NoTelepon, Alamat, IsHonorer, Gelar
,Gaji, Tunjangan)
values
('1234567893', 'Bobi Dewa', 'Semarang', '1990-04-18',
'L','2024-02-01', '08582733827', 'Jl. Maju Maundur Oke', 1, 'S.Pd',
6500000, 500000),
('1234567891', 'Caca', 'Bandung', '1980-01-20',
'P','2005-11-12', '085578712381', 'Jl. Maju Terus', 1, 'S.Pd',
6500000, 500000)

Select * from Guru
select * from MataPelajaran

--truncate table MataPelajaran

--update
--gunakan where untuk lebih spesifik

update Guru
set Gelar = 'S.Pd',
	NamaLengkap = 'Joko Priyatno'
where NIP = '1234567892'

update guru 
set NoTelepon = '085827338274'
where NIP = '1234567893'

--delete
delete from Guru

--truncate
--tidak bisa apabila ada relasi(FK)
truncate table matapelajaran

--memulai delete dan reset memulai dari 1
DBCC CHECKIDENT ('MataPelajaran', RESEED, 0)







--create alter drop
use master
drop database Sekolah

--create database
create database Sekolah
go
use Sekolah

--guru & MataPelajaran
drop table MataPelajaran
create table MataPelajaran(
--coloum
Id int identity(1,1),
Nama varchar(100),
Constraint PK_Sekolah_Id Primary Key (Id)
)

create table Guru(
NIP varchar(10) NOT NULL,
NamaLengkap varchar(100) NOT NULL,
TempatLahir varchar(50) NOT NULL,
TanggalLahir datetime NOT NULL,
JenisKelamin char(1) NOT NULL,
TanggalMulaiBekerja datetime NOT NULL,
NoTelepon varchar(13),
Alamat varchar(500) NOT NULL,
IsHonorer bit NOT NULL,
Gelar varchar(30) CONSTRAINT DF_Gelar DEFAULT 'S.Pd',
Gaji money NOT NULL,
Tunjangan money NOT NULL

CONSTRAINT PK_GURU_NIP PRIMARY KEY (NIP),
CONSTRAINT UQ_NoTelepon UNIQUE (NoTelepon)
)

--PK hanya 1 dalam 1 tabel
create table dbo.Kopetensi(
NIP varchar(10),
IdMataPelajaran int
--PK Komposit
CONSTRAINT PK_Kopetensi PRIMARY KEY (NIP,IdMataPelajaran)
)

alter table dbo.Kopetensi
add
constraint FK_Guru_Nip Foreign Key (Nip) References dbo.Guru(NIP)

alter table dbo.Kopetensi
add
constraint FK_MataPelajaran_Id Foreign Key (IdMataPelajaran) References dbo.MataPelajaran(Id)



select * from Guru
Select * from MataPelajaran
Select * from Kopetensi


--menambah kolom tabel
alter table Kopetensi
add DeleteDate datetime null


--mengubah kolom
alter table Kopetensi
alter column DeleteDate datetime not null

--menghapus kolom
alter table kopetensi
drop column DeleteDate

--rename kolom
--ALTER TABLE tableName RENAME COLUMN oldcolname TO newcolname datatype(length);


insert into Kopetensi 
(NIP,IdMataPelajaran)
values (1234567891, 2), (1234567892, 7)

--insert into select
--bisa memasukkan dari database lain
-- from Univ.dbo.Dosen (Contoh)

--select into from
--bisa buat tabel baru, tidak termasuk primary key. Apabila Tabel belum  ada bisa menggunakan ini.
-- into Dosen(Contoh)

--select harus disamakan dengan tabel yang akan di insert/dimasukkan/dituju





-- temporary table
--tabel sementara
--# satu local (Satu lembar Kerja)
-- ## global (Bisa di lembar kerja lain)

select NIP, NamaLengkap, Gaji, Tunjangan
into #tempDataGuru
from Guru

select * from #tempDataGuru

drop table #tempDataGuru





-- OUTPUT : INSERT UPDATE DELETE, INSERTED DELETED

-- INSERTED : VALUE TERBARU

INSERT INTO MataPelajaran(Nama)
OUTPUT inserted.Id,inserted.Nama
values('Seni Budaya')

update MataPelajaran
set Nama = 'Komputer'
output deleted.Nama, inserted.Nama
where Id = 1



delete from MataPelajaran
output deleted.Id, deleted.Nama
where Id = 1