--2) Student Certificate.sql
--Akan ditampilkan informasi lengkap lulusan Unicorn pada student website, beserta detail ijazahnya.
--Tampilkan seluruh informasi lengkap mahasiswa, dengan column-column sebagai berikut ini
--1. Nama lengkap: campuran dari nama depan, nama tengah, dan nama belakang
--2. Kelahiran: campuran dari kota dan tanggal lahir dengan format seperti ini “Jakarta, 29 Desember 1989”
--3. Level: dengan output lengkap, seperti: Bachelor, Master atau Phd
--4. Academic Title
--5. Grade: dengan out lengkap, seperti: Pass, Credit, Distinction, High Distinction
--6. Graduate Date: dengan format 29 Desember 2000

select * from Student
select * from City
select * from StudentMajor
select * from Major
select * from Certificate

select distinct CONCAT(stu.FirstName, ' ', stu.MiddleName, ' ', stu.LastName) NamaLengkap,
		CONCAT(c.Name,', ',DATENAME(DAY, (stu.BirthDate)), ' ', DATENAME(MONTH, (stu.BirthDate)), ' ', DATENAME(YEAR, (stu.BirthDate)))	Kelahiran,
		CASE 
            WHEN m.Level = 'B' THEN 'Bachelor'
            WHEN m.Level = 'M' THEN 'Master'
            WHEN m.Level = 'P' THEN 'Phd'
            ELSE 'TidakDiketahui'
       END AS Level,
	   	cer.AcademicTitle,
		CASE 
            WHEN cer.Grade = 'PAS' THEN 'Pass'
            WHEN cer.Grade = 'CRE' THEN 'Credit'
            WHEN cer.Grade = 'DIS' THEN 'Distinction'
			WHEN cer.Grade = 'HDS' THEN 'High Distinction'
            ELSE 'TidakDiketahui'
       END AS Grade,
	   CONCAT(DATENAME(DAY, (cer.GraduateDate)), ' ', DATENAME(MONTH, (cer.GraduateDate)), ' ', DATENAME(YEAR, (cer.GraduateDate))) GraduateDate
from Student stu
join City c on stu.BirthCountryID = c.StateID
join StudentMajor sm on stu.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
join Certificate cer on stu.StudentNumber = cer.StudentNumber