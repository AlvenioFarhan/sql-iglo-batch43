--5) Clueless Student.sql
--Sering kali terjadi beberapa mahasiswa yang sudah register, tetapi tidak mengerti cara melakukan pendaftaran/enrollment mata kuliah, 
--atau karena mereka masih ragu untuk mengambilnya atau memulainya. Student support center ingin menghampiri mereka satu persatu dan 
--mengajak mahasiswa ini berbincang-bicang. Apabila mereka tidak mengerti cara enrollment mata pelajaran lewat system dikarenakan mereka 
--tidak mengikuti masa orientasi, maka student support center akan membantu mereka dan mengajari mereka. Oleh karena itu student support 
--center ingin kamu menunjukan data seluruh mahasiswa yang sudah ter-register tapi tidak memiliki data enrollment sama sekali. List nama 
--dan alamat dari seluruh siswa yang tidak melakukan enrollment sama sekali.

select * from Enrollment
select * from Student


select CONCAT(stu.FirstName, ' ', stu.MiddleName, ' ', stu.LastName) NamaLengkap, stu.Address
from Student stu
where stu.StudentNumber not in (
select enr.StudentNumber
from Enrollment enr
)