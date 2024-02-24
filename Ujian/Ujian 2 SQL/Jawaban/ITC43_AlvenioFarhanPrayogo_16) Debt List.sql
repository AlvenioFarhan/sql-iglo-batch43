--16) Debt List.sql
--Pihak finance ingin mengetahui berapa banyak siswa yang belum membayar enrollmentnya 
--(tidak termasuk yang cancel atau yang membatalkan). Buatlah laporan total hutang per siswa (bukan per pelajaran), 
--berdasarkan harga subject saat ini. Keluarkan laporannya dalam 3 column, Student Number, Student Full Name, dan Total Debt (Total Hutang).

select * from Student
select * from Enrollment
select * from Subject

select s.StudentNumber, 
		CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) NamaLengkap,
		SUM(sub.Cost) TotalHutang
from Student s
join Enrollment e on s.StudentNumber = e.StudentNumber
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Subject sub on c.SubjectID = sub.ID
where e.Status = 'PEN'
group by s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName)