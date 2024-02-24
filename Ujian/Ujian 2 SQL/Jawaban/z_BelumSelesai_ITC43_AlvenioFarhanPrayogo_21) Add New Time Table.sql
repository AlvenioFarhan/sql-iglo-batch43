--BELUM SELESAI
--21) Add New Time Table.sql
--Tutor ingin agar kamu membuatkan procedure yang bisa membantunya membuatkan, menambahkan atau merubah jadwal kuliahnya untuk setiap periodenya.
--Buatlah sebuah procedure yang bisa digunakan untuk menambah atau merubah jadwal kelas untuk setiap period. Procedure akan meminta 4 parameter:
--1. Period ID
--2. Nama Hari (dari pilihan ini: ‘Monday’, ‘Tuesday’, ‘Wednesday’, ‘Thursday’, ‘Friday’)
--3. Start Time (dalam time)
--4. End Time (dalam time)
--Apabila period id tidak ditemukan, berikan error validation message.
--Apabila nama hari dipilih di luar dari pilihan ini: ‘Monday’, ‘Tuesday’, ‘Wednesday’, ‘Thursday’, ‘Friday’, maka akan ada error validation message.
--Apabila sudah ditemukan jadwal pada hari senin dan dimasukan input hari senin, maka hari senin saat ini akan di ganti atau di replace 
--dengan inputan baru, apabila belum ada jadwa atau belum ada jadwal pada hari yang diinput di parameter, maka akan ditambahkan.

select * from Period
select * from TimeTable

select p.ID
from Period p

select DATENAME(DW, p.StartDate) Hari
from Period p
where DATENAME(DW, p.StartDate) not in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')


select CONVERT(time, p.StartDate) WaktuDalamJAM
from Period p

drop procedure AddNewTimeTable
create procedure  AddNewTimeTable(
@periodID int
--@Hari varchar(15),
--@starttime time,
--@endtime time
)
as
begin

insert into TimeTable (ID)
values (@periodID)

declare @id int

select p.ID
from Period p
where p.id = @id


while(@periodID != @id)
begin
select 'Period ID tidak ditemukan!'
end

end

execute AddNewTimeTable @periodID = 999