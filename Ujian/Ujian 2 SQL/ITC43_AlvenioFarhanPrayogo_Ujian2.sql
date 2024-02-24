select * from Student
select * from Tutor
select * from Major
select * from Subject
select * from SubjectMatter
select * from Prerequisite
select * from EducationHistory
select * from StudentMajor
select * from Period
select * from Enrollment
select * from StudentSubject
select * from StudentReportCard
select * from Competency
select * from TimeTable
select * from Certificate
select * from Country
select * from State
select * from City
select * from ErrorLog


--1) Citizenship Group.sql
--Principles ingin mengetahui jumlah total seluruh mahasiswa yang terdaftar di kelas berdasarkan kebangsaan/kewarganegaraannya (citizenshipnya).

select * from Student

select stu.CitizenshipID, COUNT(stu.StudentNumber)	TotalMahasiswa
from Student stu
group by stu.CitizenshipID









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









--4) Subject of Major.sql
--Siswa ingin mengetahui apa saja detail subject dari suatu major yang namanya mereka sudah ketahui.
--Buatlah procedure yang bisa list informasi subject dari nama, deskripsi, level, dan costnya, berdasarkan dari nama major yang diinput. 
--Nama major sifatnya akan di search dari kata-kata yang mengandung inputan dari procedure, misalnya di search “network” maka akan keluar seluruh 
--informasi subject dari major Internetworking, networking and cyber security, dan lain sebagainya.
--(Note: apabila deskripsi dari subject kosong, harus diganti dengan “Ask student call center for this subject information”, dan seluruh 
--level harus di tulis di outputnya dengan nama lengkap, misalnya B jadi Bachelor)

select * from Student
select * from Subject
select * from Major

select m.ID
from Major m
where m.Name like '%majorName%'

select s.Name, s.Description, 
		CASE 
               WHEN s.Level = 'B' THEN 'Bachelor'
               WHEN s.Level = 'M' THEN 'Master'
               WHEN s.Level = 'P' THEN 'Phd'
               ELSE 'TidakDiketahui'
           END AS Level,
		s.Cost
from Subject s
join Major m on s.MajorID = m.ID
where m.Name like '%Enterprise%'


drop procedure GetDetailSubject
create procedure GetDetailSubject(@majorname varchar(50))
as
begin


select s.Name, s.Description, 
		CASE 
               WHEN s.Level = 'B' THEN 'Bachelor'
               WHEN s.Level = 'M' THEN 'Master'
               WHEN s.Level = 'P' THEN 'Phd'
               ELSE 'TidakDiketahui'
           END AS Level,
		s.Cost
from Subject s
join Major m on s.MajorID = m.ID
where m.Name like CONCAT('%', @majorname, '%') 

end

execute GetDetailSubject @majorname = 'Enterprise'









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









--6) Previous Grade.sql
--Team pengurus applicant ingin mengetahui tinggi rendahnya nila rata-rata di setiap institusi pendidikan(sekolah/universitas) siswa sebelumnya. 
--Hitung rata-rata nilai siswa yang dikelompokan berdasarkan institusinya.

select * from EducationHistory

select distinct eh.Institution Institution,
		AVG(eh.Grade) Ratarata
from EducationHistory eh
group by eh.Institution









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










--9) Incoming Fee.sql
--Ingin diketahui jumlah total student fee yang sudah dibayar masuk ke kampus sampai dengan tanggal tertentu. 
--Buatlah fungsi yang menerima parameter tanggal, maka fungsi akan mengehitung dan mengeluarkan total hasil 
--perhitungan fee yang masuk sebelum tanggal tersebut.

select * from Enrollment

select SUM(e.Fee)
from Enrollment e
where e.Status = 'COM' and e.TransactionDate <= '2013-09-09 00:00:00.000'

drop function TotalIncome
create function TotalIncome(@tanggal date)
returns money as
begin

declare @total money

select @total = (
select SUM(e.Fee)
from Enrollment e
where e.Status = 'COM' and e.TransactionDate <= @tanggal
)

return @total
end

select dbo.TotalIncome('2013-09-09') JumlahStok










--10) Major Total Cost.sql
--Ingin diprediksi oleh setiap siswa, apabila mereka mengambil seluruh subject pada satu major, 
--berapa biaya total biaya yang harus diambilnya. Tampilkan; Rank, Major Name, Major Type dan Total Cost.
--Buatlah nomor ranking, apabila ada major dengan harga yang sama, maka dia akan menduduki peringkat yang sama.
--(Note: Major Type harus ditampilkan yang lengkap, apakah Full Major, Sub Major, atau Elective)


select * from Major
select * from Subject


select	RANK() over (order by sum(s.Cost) desc) RANK,
		m.Name,
		CASE
           WHEN m.Type = 'FM' THEN 'Full-Major'
           WHEN m.Type = 'SM' THEN 'Sub-Major'
           WHEN m.Type = 'EL' THEN 'Elective'
           ELSE 'TidakDiketahui'
       END AS Type,
		SUM(s.Cost) TotalCost
from Major m
join Subject s on m.ID = s.MajorID
group by m.name, Type
order by TotalCost desc









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









--12) Different Point.sql
--Setiap major atau jurusan terdiri dari beberapa subject / mata pelajaran. Setiap major memiliki total credit point, 
--dimana seharusnya total credit point milik major adalah penjumlahan dari semua credit point milik subject. 
--Tapi kenyataannya tidak selalu begitu, di sini ada perbedaan antara total credit point milik major dan total penjumlahan 
--credit point milik subject. Buatlah list major dengan total credit pointnya, lalu buatlah perbandingan antara total credit point 
--milik major dengan credit point subject.
--Contohnya:
--Major Name	Total Credit Point	Different with subject
--Major 1	48	24
--Major 2	48	-12
--Ini berarti total point subject dari Major 1 lebih 24 point dari total credit point majornya (berarti total credit point 
--subject Major 1 adalah 72) dan Subject dari Major 2 totalnya hanya 36.


select * from Major
select * from Subject


select s.MajorID, SUM(s.CreditPoint) CreditPoint
from Subject s
group by s.MajorID

select m.Name, m.TotalCreditPoint,
		m.TotalCreditPoint - 
							(select SUM(s.CreditPoint) CreditPoint
							from Subject s where s.MajorID = m.ID
							group by s.MajorID) PerbedaanPoint
from Major m









--BELUM SELESAI
--13) Add New Competency.sql
--Buatlah sebuah procedure yang berfungsi untuk memberikan kompetensi seorang tutor terhadap sebuah subject. 
--Procedure akan meminta 2 input parameter, yaitu existing Staff Number dan existing subject code, dan kedua hal ini 
--akan dikaitkan dalam kompetensi. Procedure harus memiliki validasi dan harus bisa memberikan error massage apabila tutor 
--dengan staff number yang input tidak ada pada database atau apabila subject dengan subject code yang diinput tidak ada pada database. 
--Dan apabila salah satu tidak exist pada database, competency tidak jadi ditambahkan.

select * from Tutor
select * from Competency
select * from Subject

select t.StaffNumber, s.ID
--into Comoetency
from Competency c
join Subject s on c.SubjectID = s.ID
join Tutor t on c.StaffNumber = t.StaffNumber
where c.StaffNumber = 'CA01' and s.Code = '48024'

drop procedure AddNewCompetency
create procedure AddNewCompetency(
@StaffNumber varchar(20),
@SubjectCode varchar(1)
)
as begin
begin try

insert into Competency
values (@StaffNumber, (select s.ID
from Competency c
join Subject s on c.SubjectID = s.ID
join Tutor t on c.StaffNumber = t.StaffNumber
where c.StaffNumber = @StaffNumber and s.Code = @SubjectCode))

end try

begin catch
		select 'Gagal Menambahkan, Data Tidak Ditemukan!'
		Rollback transaction
end catch

end

execute AddNewCompetency @StaffNumber = 'CA01', @SubjectCode = '48024'

select * from Competency




--14) Completing Enrollment.sql
--Buatlah procedure yang bisa digunakan untuk menyelesaikan transaksi siswa yang masing pending di enrollment. 
--Procedure hanya akan meminta input parameter berupa payment method. Transaction date akan diambil dari hari ini, 
--atau hari saat procedure ini dijalankan dan feenya akan disesuaikan dengan harga subject saat ini.

select * from Subject
select * from Competency
select * from Period
select * from Enrollment

select * from Enrollment
where Status = 'PEN'

select s.Name as SubjectName, SUM(s.Cost)TotalPembayaran
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
join Enrollment e on p.ID = e.PeriodID
where e.Status = 'PEN' and e.PeriodID = 160
group by s.Name

drop procedure CompletingEnrollment
create procedure CompletingEnrollment(@MethodPembayaran varchar(2))
as 
begin

declare @date date

set @date = GETDATE()

update Enrollment
set TransactionDate = @date,
	Fee = (
	SELECT s.Cost FROM Subject s
	join Competency c on s.ID = c.SubjectID
	join Period p on c.ID = p.CompetencyID
	join Enrollment e on p.ID = e.PeriodID
	WHERE s.ID = e.ID
	),
	Status = 'COM'
	where Status = 'PEN'

end

execute CompletingEnrollment @MethodPembayaran = 'BT'









--15) Payment Method Percentage.sql
--Ingin diketahui trend cara pembayaran/ payment method dari awal pertama kali enrollment. 
--Hitung berapa persen setiap payment method dipakai untuk transaksi dari semua transaksi yang ada. 
--(Note: payment method harus ditulis nama lengkapnya). Kurang lebih outputnya harus seperti dibawah ini:
--Payment Method	Percentage
--Credit Card	40%
--Auto Collection	20%
--Cheque	10%
--Bank Transfer	30%

select * from Enrollment

select (COUNT(*) * 100) / (SELECT COUNT(*) FROM Enrollment) AS Percentage
FROM Enrollment

select 
	CASE 
        WHEN e.PaymentMethod = 'AC' THEN 'Auto Collection'
        WHEN e.PaymentMethod = 'CC' THEN 'Credit Card'
        WHEN e.PaymentMethod = 'CH' THEN 'Cheque'
        WHEN e.PaymentMethod = 'BT' THEN 'Bank Transfer'
		ELSE 'BelumPayment'
    END AS PaymentMethod,
	CONCAT(FORMAT((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Enrollment), '0.00') ,'%') AS Percentage
from Enrollment e
WHERE e.PaymentMethod IS NOT NULL
group by e.PaymentMethod











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









--17) Check Prerequisite.sql
--Pre-requisite adalah subject/mata pelajaran yang harus diselesaikan sebelum sebuah subject diambil atau di enroll. 
--Sebagian subject tidak memiliki pre-requisite yang artinya bisa langsung saja di ambil.
--Mahasiswa tidak ingin repot-repot mencari tahu pre-requisite apa saja yang harus dipenuhi sebelum dia mau mengambil subject, 
--mahasiswa ingin agar dia hanya mendapat jawaban bisa atau tidak bisa dia mengambil subject ini berdasarkan pre-requisitenya. 
--Jadi, buatlah sebuah function dimana function tersebut menerima input Student Number dan Subject Code, lalu function akan 
--mengembalikan output berupa bit/boolean, True(1) untuk bisa diambil, False(0) untuk tidak bisa diambil.

select * from Student
select * from Subject









--18) Major Popularity on Gender.sql
--Ingin diketahui apakah adanya trend satu penjurusan/major terhadap jenis kelamin. 
--Tunjukan lah perbandingan jumlah siswa pada table pivot jenis kelamin dan major.
--Major Name	Male	Female
--Major 1		
--Major 2		
--(Note: Ada mahasiswa yang mengambil double major, artinya dia punya lebih dari satu major, maka mahasiswa itu akan dihitung lebih dari 1)

select * from Major
select * from StudentMajor
select * from Student

select * from(
select m.Name as MajorName, s.StudentNumber,
		CASE 
            WHEN s.Gender = 'M' THEN 'Male'
            WHEN s.Gender = 'F' THEN 'Female'            
            ELSE 'TidakDiketahui'
       END AS Gender
from Student s
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
) tbl
pivot(count(StudentNumber)for Gender in ([Male],[Female])
) pvt











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









--20)Tutor Payroll.sql
--Terdiri dari beberapa jenis Tutor berdasarkan tipe status ketenagakerjaannya, yaitu Full-time Contract, Full-time Permanent, 
--Part-time Contract, dan Casual. Setiap pekerja Full Time menerima gaji 1 kali dalam 1 bulan, sedangkan Part Time dan Casual 
--menerima 2 kali dalam 1 bulan. Sebagian pekerja Full Time Permanent menerima tunjangan(allowance) extra di gajinya dalam bentuk 
--persentase total gajinya. Apabila allowancenya 15, itu artinya gajinya akan ditambah 15% lagi dari gaji sebulannya.
--Hitung seluruh take home pay tutor (total pendapatan, sudah termasuk allowance) dalam waktu 1 bulan, dan keluarkan hasilnya dalam 
--column-column: Staff Number, Employee Full name, Employee Type, dan Take Homepay. (Note: Employee Type harus ditulis lengkap, 
--tidak boleh singkatan seperti FC, harus Full-time Contract).

select * from Tutor


select t.StaffNumber,
		CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) NamaLengkap,
		CASE 
            WHEN t.EmployeeType = 'FC' THEN 'Full-time Contract'
            WHEN t.EmployeeType = 'FP' THEN 'Full-time Permanent' 
			WHEN t.EmployeeType = 'PC' THEN 'Part-time Contract'
			WHEN t.EmployeeType = 'CA' THEN 'Casual'
            ELSE 'TidakDiketahui'
		END AS EmployeeType,
		CASE 
            WHEN t.EmployeeType IN ('FC', 'FP') THEN 
                (t.BasicSalary + (t.BasicSalary * ISNULL(t.Allowance, 0) / 100))
            WHEN t.EmployeeType IN ('PC', 'CA') THEN 
                (t.BasicSalary / 2)
        END AS TakeHomePay

from Tutor t












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


















--BELUM SELESAI
--22) Unmatch Subject.sql
--Setiap major memiliki level, baik bachelor, master, maupun phd, begitu pula dengan setiap subject. 
--Level setiap major dan subject tidak perlu selalu match atau cocok. Pada major phd, subject phd, bachelor dan 
--master diperbolehkan, pada major master subject dengan level bachelor dan master diperbolehkan, tetapi pada major 
--bachelor hanya subject bachelor yang diperbolehkan. List seluruh subject yang levelnya tidak match dengan level majornya 
--(bukan yang melanggar aturan, yang tidak match saja), lalu keluarkan informasi, Major Name dan Subject Name, tetapi seluruh 
--Subject Namenya harus yang masih aktif, atau tidak ada tanggal NonActiveDate.


select * from Major
select * from Subject

select m.Name as MajorName, s.Name as SubjectName
from Major m
join Subject s on m.ID = s.MajorID








SELECT m.Name as MajorName, s.Name as SubjectName
FROM Major m
JOIN Subject s ON m.ID = s.MajorID
WHERE 
    (m.Level = 'Bachelor' AND s.Level <> 'Bachelor') OR
    (m.Level = 'Master' AND s.Level = 'Phd') OR
    (m.Level = 'Phd' AND s.Level IN ('Bachelor', 'Master')) AND
    (s.NonActiveDate IS NULL OR s.NonActiveDate > GETDATE());










--23) Cost Changes.sql
--Terkadang harga setiap subject bisa berubah, ada yang naik dan ada yang turun. Naik turunnya harga sebuah subject bisa dilihat 
--pada data enrollment, fee yang dibayar oleh siswa adalah harga subject pada saat enrollment dibayar (transaction date), 
--harga subject pada subject master data adalah harga saat ini. List seluruh subject yang mengalami perubahan harga sesuai 
--dengan data pada enrollment. Keluarkan informasi dalam; Subject Code, Subject Name, Current Price (harga sekarang), 
--Transaction Date, Price on Transaction (harga pada saat transaksi)

select * from Subject
select * from Enrollment

select s.Code SubjectCode, s.Name SubjectName, s.Cost AS HargaTerbaru, e.TransactionDate, e.Fee AS HargaLampauTransaksi,
		IIF(s.cost > e.fee, 'Harga Naik', 'Harga Turun') StatusHarga
from Enrollment e
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where s.Cost != e.Fee
