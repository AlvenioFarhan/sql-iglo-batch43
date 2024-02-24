--1) Citizenship Group.sql
--Principles ingin mengetahui jumlah total seluruh mahasiswa yang terdaftar di kelas berdasarkan kebangsaan/kewarganegaraannya (citizenshipnya).

select * from Student

select stu.CitizenshipID, COUNT(stu.StudentNumber)	TotalMahasiswa
from Student stu
group by stu.CitizenshipID