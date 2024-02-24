--7) All Available Subject.sql
--Mahasiswa ingin mengetahui seluruh subject yang available di dalam satu waktu. Buatlah procedure yang mengeluarkan banyak 
--informasi subject hanya dengan 1 parameter tanggal. Informasi dari subject yang harus keluar adalah:
--Period Start Date, Periode End Date, Subject Name, Subject Description, Cost
--(Note: jangan ada output berulang dan tulis cost dalam format US Dollar)

select * from Period
select * from Subject
select * from Competency

select p.StartDate, p.EndDate, s.Name, s.Description ,FORMAT(s.Cost, 'C', 'en-US') Cost
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID

drop procedure GetSubject
create procedure GetSubject (@tanggal date)
as
begin

select p.StartDate, p.EndDate, s.Name, s.Description ,FORMAT(s.Cost, 'C', 'en-US') Cost
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
where @tanggal between p.StartDate and p.EndDate

end

execute GetSubject @tanggal = '2013-06-01'