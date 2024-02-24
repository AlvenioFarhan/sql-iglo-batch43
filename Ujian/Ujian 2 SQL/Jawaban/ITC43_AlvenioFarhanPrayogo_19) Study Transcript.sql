
--19) Study Transcript.sql
--Diperlukan untuk membuat transcript nilai seorang siswa, dimana transcript tersebut berisi detail penilaian subject milik mahasiswa. 
--Buatlah procedure yang menerima 1 parameter, yaitu student number. Dari student number keluarkan lah 2 results, yang pertama menunjukan:
--Student Fullname	Gender 	Register Date	Total Credit Point
			
--Hasil yang kedua:
--Subject Code	Subject Name	Major Name	Total Mark	End Period Date
							
--Dimana Gender adalah descriptionnya (M = Male, F= Female). Total mark adalah penjumlahan dari semua nilai report card pada subject 
--dengan specific enrollment. dimana setiap nilainya didapat dari weight (bobot) dikali mark.

select * from Student
select * from Subject
select * from Major
select * from Period
select * from StudentReportCard
select * from StudentSubject
select * from Enrollment

select CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) NamaLengkapMurid,
		CASE 
            WHEN s.Gender = 'M' THEN 'Male'
            WHEN s.Gender = 'F' THEN 'Female'            
            ELSE 'TidakDiketahui'
       END AS Gender, 
	   s.RegisterDate, s.TotalCreditPoint
from Student s
where s.StudentNumber = '2012/01/0001'

select sub.Code as SubjectCode, sub.Name as SubjectName, m.Name as MajorName, 
		sum(src.Mark * src.WeightedMark) as TotalMark,
		p.EndDate as EndPeriodDate
from Subject sub
join Major m on sub.MajorID = m.ID
join Competency c on sub.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
join StudentMajor sm on m.ID = sm.MajorID
join Student s on sm.StudentNumber = s.StudentNumber
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
where s.StudentNumber = '2012/01/0001'
group by sub.Code, sub.Name, m.Name, p.EndDate


drop procedure StudyTranscript
create procedure StudyTranscript (@StudentNumber varchar(15))
as
begin

select CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) NamaLengkapMurid,
		CASE 
            WHEN s.Gender = 'M' THEN 'Male'
            WHEN s.Gender = 'F' THEN 'Female'            
            ELSE 'TidakDiketahui'
       END AS Gender, 
	   s.RegisterDate, s.TotalCreditPoint
from Student s
where s.StudentNumber = @StudentNumber

select sub.Code as SubjectCode, sub.Name as SubjectName, m.Name as MajorName, 
		sum(src.Mark * src.WeightedMark) as TotalMark,
		p.EndDate as EndPeriodDate
from Subject sub
join Major m on sub.MajorID = m.ID
join Competency c on sub.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
join StudentMajor sm on m.ID = sm.MajorID
join Student s on sm.StudentNumber = s.StudentNumber
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
where s.StudentNumber = @StudentNumber
group by sub.Code, sub.Name, m.Name, p.EndDate

end

execute StudyTranscript @StudentNumber = '2012/01/0001'