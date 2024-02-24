--11) All Tutor and Student Involved.sql
--Diperlukan data seluruh tutor yang mengajar dan murid yang belajar pada satu subject di satu tanggal. 
--Buatlah sebuah procedure yang mengeluarkan seluruh nama lengkap siswa dan nama lengkap tutor, dimana procedure 
--tersebut meminta 2 parameter, yaitu subject code dan satu tanggal.

select * from Student
select * from Enrollment
select * from Tutor
select * from Subject
select * from Period
select * from Major
select * from Tutor
select * from Competency


select distinct CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) NamaLengkapMurid,
		CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) NamaLengkapTutor
from Period p
join Enrollment e on p.ID = e.PeriodID
join Student s on e.StudentNumber = s.StudentNumber
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
join Subject sub on m.ID = sub.MajorID
join Competency c on p.CompetencyID = c.ID
join Tutor t on c.StaffNumber = t.StaffNumber
where sub.Code = '31251' and 
CONCAT(YEAR(p.StartDate),'-',MONTH(p.StartDate),'-',DAY(p.StartDate)) >= '2014-01-01' and
CONCAT(YEAR(p.StartDate),'-',MONTH(p.StartDate),'-',DAY(p.StartDate)) <= '2013-12-01' 


drop procedure NamaTutorDanMurid
create procedure NamaTutorDanMurid(@code varchar(5), @tanggal varchar(max))
as
begin

select distinct CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) NamaLengkapMurid,
		CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) NamaLengkapTutor
from Period p
join Enrollment e on p.ID = e.PeriodID
join Student s on e.StudentNumber = s.StudentNumber
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
join Subject sub on m.ID = sub.MajorID
join Competency c on p.CompetencyID = c.ID
join Tutor t on c.StaffNumber = t.StaffNumber
where sub.Code = '31251' and 
CONCAT(YEAR(p.StartDate),'-',MONTH(p.StartDate),'-',DAY(p.StartDate)) >= '2014-01-01' 

end

execute NamaTutorDanMurid @code = '31251', @tanggal = '2014-01-01'