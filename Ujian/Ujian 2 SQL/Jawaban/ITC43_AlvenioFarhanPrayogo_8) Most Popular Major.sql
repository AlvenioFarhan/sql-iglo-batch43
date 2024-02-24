--8) Most Popular Major.sql
--Ingin diketahui Major/jurusan mana yang paling populer diambil student di satu tahun. 
--Buatlah procedure yang menerima input berupa tahun, lalu procedure akan mengeluarkan hasil berupa nama major dan 
--jumlah total berapa kali major itu diambil pada tahun sesuai inputnya.

select * from Major
select * from Student
select * from StudentMajor

select m.Name, COUNT(sm.MajorID) TotalSiswa
from Major m
join StudentMajor sm on m.ID = sm.MajorID
join Student s on sm.StudentNumber = s.StudentNumber
where YEAR(s.RegisterDate) = 2012
group by m.Name
order by TotalSiswa desc

drop procedure PopularMajor
create procedure PopularMajor (@tahun int)
as
begin

select m.Name, COUNT(sm.MajorID) TotalSiswa
from Major m
join StudentMajor sm on m.ID = sm.MajorID
join Student s on sm.StudentNumber = s.StudentNumber
where YEAR(s.RegisterDate) = @tahun
group by m.Name
order by TotalSiswa desc

end

execute PopularMajor @tahun = 2012
