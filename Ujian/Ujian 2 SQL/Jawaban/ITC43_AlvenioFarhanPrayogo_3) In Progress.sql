--3) In Progress.sql
--List informasi mengenai mahasiswa yang belum memiliki sertifikat atau belum pernah lulus di unicorn.
--Informasi yang ditampilkan adalah:
--1. Nama lengkap: campuran dari nama depan, nama tengah, dan nama belakang
--2. Kelahiran: campuran dari kota dan tanggal lahir dengan format seperti ini “Jakarta, 29 Desember 1989”
--3. Major name: nama major yang saat ini sedang diambilnya.

select * from Student
select * from Major
select * from Certificate

select CONCAT(stu.FirstName, ' ', stu.MiddleName, ' ', stu.LastName) NamaLengkap,
		CONCAT(c.Name,', ',DATENAME(DAY, (stu.BirthDate)), ' ', DATENAME(MONTH, (stu.BirthDate)), ' ', DATENAME(YEAR, (stu.BirthDate)))	Kelahiran,
		m.Name as MajorName
from Student stu
JOIN StudentMajor sm ON stu.StudentNumber = sm.StudentNumber
JOIN Major m ON sm.MajorID = m.ID
JOIN City c ON stu.BirthCityID = c.ID
LEFT JOIN Certificate cer ON stu.StudentNumber = cer.StudentNumber
WHERE cer.StudentNumber IS NULL