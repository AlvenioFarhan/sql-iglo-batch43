--menampilkan presentase kelulusan setiap subject
--sub id, name, total berapa kali ngambil, dia lulus berapa kali, sama persentase

select * from Subject
select * from StudentSubject
select * from Student
select * from Certificate
select * from StudentReportCard

select s.ID as SubjectID, s.Name as SubjectName, count(*)TotalAmbil, count(cer.ID) JumlahLulus,
		CONCAT(FORMAT((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM StudentReportCard), '0.00') ,'%') AS Percentage
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
join Enrollment e on p.ID = e.PeriodID
join Student stu on e.StudentNumber = stu.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
join Certificate cer on stu.StudentNumber = cer.StudentNumber
where stu.StudentNumber = cer.StudentNumber
group by s.ID, s.Name







--buatkan function yang berguna untuk convert list menjadi string
select 
    stuff((
        select ', '+convert(varchar(10),ID)
        from Subject
        for xml path (''), type).value('.','nvarchar(max)')
      ,1,1,'') StudentsNumbers 



create type ListString as TABLE(
	IsiString varchar(max)
);
alter function ConvertListToString(
	@list as ListString readonly
) returns varchar(max) as
begin
	declare @index int = 1
	declare @banyakIndex int = (select count(1) from @list)
	declare @isiText varchar(max)
	declare @newTable table(ID int identity(1,1), isiString varchar(max))
	
	insert into @newTable (isiString)
	select isiString from @list 
	while(@index <= @banyakIndex)
	begin
		set @isiText = concat(@isiText,' ',(select IsiString from @newTable order by ID offset @index-1 rows fetch next 1 rows only))
		set @index += 1
	end
	return right(@isiText, len(@isiText)-1)
end

declare @list as ListString
insert into @list values ('coba'),('aja'),('dlu'),('asal'),('hati'),('hati'),('oke'),('banget'),('bos')
select * from @list
select dbo.ConvertListToString(@list)







--query mengeluarkan employee id, nama lengkap, total huruf vokalnya, dan total huruf konsonen

select * from Tutor

SELECT 
    StaffNumber,
    CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName,
	LEN(LOWER(CONCAT(FirstName, MiddleName, LastName))) -
LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(CONCAT(FirstName, MiddleName, LastName)),'a', ''),'i',''),'u',''),'e',''),'o','')) Vocal,
LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(CONCAT(FirstName, MiddleName, LastName)),'a', ''),'i',''),'u',''),'e',''),'o','')) Konsonen
FROM 
    Tutor;





select LEN(LOWER(CONCAT(FirstName, MiddleName, LastName))) -
LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(CONCAT(FirstName, MiddleName, LastName)),'a', ''),'i',''),'u',''),'e',''),'o','')) Vocal,
LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(CONCAT(FirstName, MiddleName, LastName)),'a', ''),'i',''),'u',''),'e',''),'o','')) Konsonen
from Tutor

--function skalar int untuk total dari penjumlahan sebuah value
--params string 1

--buat function total yang harus dibayar oleh student berdasarkan sub recordnya









--tampilkan 1 total kolom untuk student , total tutor nya berapa

select * from Student
select * from Tutor

select s.Username, COUNT(t.StaffNumber)TotalTutor
from Student s
join Enrollment e on s.StudentNumber = e.StudentNumber
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Tutor t on c.StaffNumber = t.StaffNumber
group by s.Username

--Salah
select COUNT(distinct s.StudentNumber) TotalStudent, COUNT(distinct t.StaffNumber)TotalTutor
from Student s
join Enrollment e on s.StudentNumber = e.StudentNumber
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Tutor t on c.StaffNumber = t.StaffNumber
group by s.Username










--tampilin id sama nama lengkap dari student dan tutor yang lahir dinegara yang sama

select * from State
select * from Student
select * from Tutor
select * from Country

select CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) FullNameStudent, CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) FullNameTutor
from Student s
join City c on s.CitizenshipID = c.ID
join State sta on c.StateID = sta.ID
join Tutor t on c.ID = t.CitizenshipID
where  sta.ID = s.CitizenshipID and sta.ID = t.CitizenshipID


select s.StudentNumber as ID, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) as FullName, s.BirthCountryID, c.Name as Negara
from Student s
join Country c on s.BirthCountryID = c.ID
join Tutor t on c.ID = t.BirthCountryID
union
select t.StaffNumber as ID, CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) as FullName, t.BirthCountryID, c.Name as Negara
from Tutor t
join Country c on t.BirthCountryID = c.ID
join Student s on c.ID = s.BirthCountryID










--keluarin ID, periode id, startdate, enddate, dan total pertemuan disetiap kelas sesuai dengan jadwal

select * from Period
select * from Competency
select * from Enrollment
select * from TimeTable

select p.id as PeriodID, p.StartDate, p.EndDate, COUNT(p.ID) TotalPertemuan
from Period p
group by p.ID, p.StartDate, p.EndDate









--tampilkan staff number tutoor, nama lengkap, besar uang yang diaterima(Take home pay), declare tanggal, dari range tanggal tertentu

select * from Tutor









--keluarin, subject code dan subject name dan total siswa yang ambil subject tersebut

select * from Subject
select * from Student

select s.Code, s.Name, COUNT(stu.StudentNumber)TotalSiswa
from Subject s
join Major m on s.MajorID = m.ID
join StudentMajor sm on m.ID= sm.MajorID
join Student stu on sm.StudentNumber = stu.StudentNumber
group by s.Code, s.Name









/*
keluarin subject id, name, yang memiliki level berbeda dengan level majornya
*/

select * from Major
select * from Subject


select s.ID, s.Name
from Subject s
join Major m on s.MajorID = m.ID
where m.Level != s.Level

--keluarin daftar tutor, tampilin staff number, fullname, sama yang belum dipesan kopetensinya

select * from Tutor
select * from Competency

select distinct t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) FullName
from Tutor t
join Competency c on t.StaffNumber = c.StaffNumber
where t.StaffNumber	!= c.StaffNumber

--daftar student yang lahir di negara asalnya

select * from Student

select s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) FullName
from Student s
join Country c on s.BirthCountryID = c.ID
where s.BirthCountryID != c.ID










/*
buat SP ngeluarin selec informasi student
student number, fullname, major id, register date, rapot siswa tersebut

mengeluarkan daftar nilai
subject code, nilai 
dengan catatan kalau subject lebih dari sekali diambil nilai tertingginya
*/

select * from Student
select * from StudentMajor
select * from Major
select * from StudentReportCard
select * from Enrollment

select s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) FullName, sm.MajorID, s.RegisterDate,
		SUM(src.Mark * src.WeightedMark) RaportSiswa
from Student s
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
where e.Status = 'COM'
group by s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName), sm.MajorID, s.RegisterDate


select * from Subject

select s.Code
from Subject s









/*
tambahin kolom di tutor kolom email
FP
update dengan struktur, dengan nama depan dan nama belakan @domain disesuaikan dengan tutornya kalau fulltime Permanent() domain unicorn.com / @yahoo.com
*/

select * from Tutor

ALTER TABLE dbo.Tutor
ADD Email varchar(50)

ALTER TABLE dbo.Tutor
drop column Email 

update dbo.Tutor
set Email = 
 LOWER(CONCAT(FirstName,LastName)) + IIF(EmployeeType = 'FP', '@unicorn.com', '@yahoo.com') 
		









/*
buat sp untuk hitung total yang dikeluarkan oleh siswa jika dia mengambil beberapa major sekaligus, filtering dengan major id
*/

select * from Major
select * from Subject
select * from Student
select * from StudentMajor

select  m.ID, SUM(sub.Cost)Total
from Student s
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
join Subject sub on m.ID = sub.MajorID
--where m.id in (1,5)
group by m.ID

drop type Tot
create type Tot as Table (ID Int)


drop proc TotalCost
alter  procedure TotalCost(@majorID as Tot Readonly)
as
begin

select  --m.ID, 
SUM(sub.Cost)Total
from Major m
join Subject sub on m.ID = sub.MajorID
where m.id in (select * from @majorID )
--group by m.ID

end

declare @tot as Tot
insert into @tot values (1),(5), (10)

execute TotalCost @tot











/*
keluarin informasi studen, studen name, sama nama,yang bercity dan country tidak sesuai
*/

select * from Student
select * from Country
select * from City
select * from State


select s.StudentNumber, s.Username
from Student s
left join Country c on s.BirthCountryID = c.ID
left join City cit on s.CitizenshipID = cit.ID
where s.BirthCountryID != c.ID and s.BirthCityID != cit.ID



--daftar siswa yang keluarin student number fullname.
--dia mengambil subject diluar major dia

select * from Student
select * from Subject
select * from Major

select distinct s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) FullName
from Student s
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
join Subject sub on m.ID = sub.MajorID
where m.ID != sub.MajorID



;with tblcicty as(
select ct.ID,CountryID from City ct
join State st on ct.StateID = st.ID
)
select StudentNumber, CONCAT(FirstName,' ',MiddleName,' ',LastName) [fulname] from Student std
join tblcicty ct on std.BirthCityID = ct.ID
where std.BirthCountryID <> ct.CountryID


--keluarin studen number dan full name daftar siswa yang mengambil subject diluar majer dia

;with tblstdmajor as (
select std.StudentNumber, CONCAT(FirstName,' ',MiddleName,' ',LastName) [fulname], sm.MajorID [std major] from Student std
join StudentMajor sm on std.StudentNumber = sm.StudentNumber
), submajor as (
select distinct StudentNumber, sub.MajorID [sub major id] from Enrollment en
join Period p on en.PeriodID = p.ID
join Competency c on c.ID = p.CompetencyID
join Subject sub on sub.ID = c.SubjectID
)
select * from tblstdmajor tm
right join submajor sm on tm.StudentNumber = sm.StudentNumber
where sm.StudentNumber is null









/*buat sp
yang menampilkan self informasi tutor, staff number, fullname, empoyee type dan hire date diformat indonesia. 
daftarkelas yang pernah diajar dari range tahun
param tahun periode kelas, dan staff number
*/

select * from Tutor
select * from Competency
select * from Period
select * from Subject

select t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) FullName, t.EmployeeType, FORMAT(t.HireDate, 'dd-MM-yyy') HireDate
from Tutor t
join Competency c on t.StaffNumber = c.StaffNumber
join Period p on  c.ID = p.CompetencyID
where t.StaffNumber = 'CA01'

select s.Code, s.Name, p.StartDate, p.EndDate
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID

select s.Code, s.Name, p.StartDate, p.EndDate
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
where YEAR(p.StartDate) between 2013 and 2013


drop procedure DaftarTutor
create procedure DaftarTutor (
@staffnumber varchar,
@tahun int
)
as
begin

select t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) FullName, t.EmployeeType, FORMAT(t.HireDate, 'dd-MM-yyy') HireDate
from Subject s
join Competency c on s.ID = c.SubjectID
join Tutor t on t.StaffNumber = c.StaffNumber
join Period p on c.ID = p.CompetencyID
where t.StaffNumber = @staffnumber and YEAR(p.StartDate) between @tahun and @tahun


select s.Code, s.Name, p.StartDate, p.EndDate
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
where YEAR(p.StartDate) between @tahun and @tahun

end

execute DaftarTutor @staffnumber = 'CA01', @tahun = '2013'








/*
buat sp
untuk pendaftaran enrollment
setiap siswa
dia bisa
sekali pembayaran 
membuat enrollment setiap kelas tersebut
daftar kelar
siapa student, daftar kelas yang mau di ambil
select keluarkan total keseluruhan yang harus dibayarkan
*/

select * from Student
select * from Period
select * from Subject
select * from Enrollment


select s.StudentNumber, s.Username
from Student s

select p.ID, s.Name, s.Code, s.Cost
from Period p
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where p.ID in (select * from @pilihan)
union all
select '','','' SUM(s.Cost)
from Period p
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where p.ID in (select * from @pilihan)


drop type KelasID
create type KelasID as table (PeriodID int)

drop procedure pembayaran
create procedure pembayaran(
@StudentNumber varchar(15),
@KelasPilihan as KelasID Readonly
)
as
begin

select p.ID, s.Name, s.Code, s.Cost
from Period p
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where p.ID in (select * from @KelasPilihan)
union all
select '','','', SUM(s.Cost)
from Period p
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where p.ID in (select * from @KelasPilihan)

--ADD Data
declare @index int = 1
declare @totalbaris int = (select COUNT(PeriodID) from @KelasPilihan)

while(@index <= @totalbaris)
begin

declare @id int = (select PeriodID from @KelasPilihan order by PeriodID offset @index-1 rows fetch next 1 rows only)

insert into Enrollment (StudentNumber, EnrollDate, PeriodID, Status)
values
(@StudentNumber, GETDATE(), @id, 'PEN')

set @index = @index + 1

end

end

select * from Enrollment

declare @kelasPilihan as KelasID
insert into @KelasPilihan values (1),(10)
execute pembayaran '2012/01/0001', @KelasPilihan

delete Enrollment
where ID in (119,120)










/*
keluarin informasi tutor, staff number, fullname, basic salary, allowence sama tunjangan, type employee
dan basic salary terbaru saat tahun tertentu
sediakan paramater tahun
diawaltahun tsb salary berapa
jika kenaikan salary 10% saat itu
*/

select * from Tutor

select t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ',t.LastName) FullName, BasicSalary, t.EmployeeType
from Tutor t

--dalam setaahun
select convert(money, (BasicSalary + (BasicSalary * Allowance)))
from Tutor

--Pertahun kedepan
select CONVERT(money, (BasicSalary+((BasicSalary + (BasicSalary * Allowance)) * 0.10)))
from Tutor

select (BasicSalary + (DATEDIFF(YEAR, HireDate, '2010') * 0.10))
from Tutor

select DATEDIFF(YEAR, HireDate, '2010')
from Tutor


drop type Tahunan
create type Tahunan as table (Tahun int)

--drop procedure GajiTahunan
--create procedure GajiTahunan (@tahun int)
--as
--begin

--select t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ',t.LastName) FullName, BasicSalary, t.EmployeeType,
--		CONVERT(money, (BasicSalary+((BasicSalary + (BasicSalary * Allowance)) * 0.10))) GajiUntukTahunan
--from Tutor t

--declare @index int = 1
--declare @tahunawal int = (select DATENAME(YEAR, HireDate) from Tutor)

--while(@index <= @tahunawal)
--begin 

--select CONVERT(money, (BasicSalary+((BasicSalary + (BasicSalary * Allowance)) * 0.10)))Gaji
--from Tutor
--where DATENAME(YEAR, HireDate) = @tahun

--set @index = @index + 1
--end

--end

--execute GajiTahunan @tahun = 2013



drop function UpdateGajiTutor
create function UpdateGajiTutor(
@staffNumber Varchar(20),
@selisihTahun Int
)
returns @TutorInfoTable Table (StaffNumber varchar(20), FullName varchar(100), BasicSalary money, Allowance Decimal, EmployeeType Varchar(2), GajiBaru money)
as
begin
	declare @temp int = 0
	declare @tempSalary money = (select BasicSalary from Tutor where StaffNumber = @staffNumber)
	declare @tutorInfo as table (StaffNumber varchar(20), FullName varchar(100), BasicSalary money, Allowance Decimal, EmployeeType Varchar(2), GajiBaru money)

	while(@temp < @selisihTahun)
	begin
		insert into @tutorInfo(StaffNumber, FullName, BasicSalary, Allowance, EmployeeType, GajiBaru)
		select t.StaffNumber, CONCAT(t.FirstName, ' ', t.MiddleName, ' ',t.LastName) FullName, t.BasicSalary, t.Allowance, t.EmployeeType, CAST(@tempSalary * 1.10 as money) GajiBaru
		from Tutor t
		where t.StaffNumber like @staffNumber

		set @tempSalary = @tempSalary * 1.10
		set @temp = @temp + 1

	end
	
	insert into @TutorInfoTable
	select top 1 * from @tutorInfo order by GajiBaru desc
	return
end


drop procedure GajiTutor
create procedure GajiTutor(
@tahun date
)
as begin

declare @temp int = 0
declare @TutorInfo as table (StaffNumber varchar(20), FullName varchar(100), BasicSalary money, Allowance Decimal, EmployeeType Varchar(2), GajiBaru money)
declare @indexOffset int = 1

while(@temp < (select count(*) from Tutor))
begin
	declare @tempStaaffNuber Varchar(20) =(select StaffNumber from Tutor order by StaffNumber offset @indexOffset - 1 rows fetch next 1 rows only)
	declare @selisihTahun int = (select DATEDIFF(YEAR,HireDate,@tahun) from Tutor order by StaffNumber offset @indexOffset -1 rows fetch next 1 rows only)

	insert into @TutorInfo(StaffNumber, FullName, BasicSalary,Allowance,EmployeeType,GajiBaru)
	select * from UpdateGajiTutor(@tempStaaffNuber,@selisihTahun)

	set @temp = @temp + 1
	set @indexOffset = @indexOffset + 1

end
select * from @TutorInfo
end

execute GajiTutor @tahun = '2011'








/*
staffnumber, fullname,hiredate lama bekerja dalam tahun
gaji terakhir saat usia pensiun usia 65 tahun
tiap tahun gajinya naik 10%
*/












--keluarin subject code, subject name,student number, nama lengkap student, nilai siswa, dan major id
--daftar yang nilai student tertinggi di majornya

select * from Subject
select * from Major
select * from Student
select * from StudentReportCard


select sub.Code, sub.Name, s.StudentNumber, CONCAT(s.FirstName, ' ', s.MiddleName, ' ', s.LastName) FullNameStudent, sum(src.Mark * src.WeightedMark) Nilai, m.ID
from Student s
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Subject sub on c.SubjectID = sub.ID
join Major m on sub.MajorID = m.ID
order by m.ID


;with nilai as(
select StudentNumber, sub.ID [sub id],sub.MajorID,PeriodID, sum(Mark*WeightedMark) [nilai] from Enrollment en
join StudentSubject ssub on en.ID = ssub.EnrollmentID
join StudentReportCard src on src.StudentSubjectID = ssub.ID
join Period per on per.ID = en.PeriodID
join Competency com on com.ID = per.CompetencyID
join Subject sub on sub.ID = com.SubjectID
group by StudentNumber, sub.ID,sub.MajorID,PeriodID
), tbl2 as(
select MajorID,max(nilai) [nilai rata]  from nilai
group by MajorID)
select * from tbl2
join nilai n on tbl2.MajorID = n.MajorID
where nilai = [nilai rata]
order by n.MajorID









--keluarkan daftar siswa berupa student number, fullname, yang memiliki 3 nilai terendah, dari jurusannya

select * from Student
select * from StudentReportCard

select s.StudentNumber, m.id,SUM(src.Mark * src.WeightedMark) Nilai
from Student s
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
group by s.StudentNumber, m.ID


select src.ID, SUM(src.Mark * src.WeightedMark)
from StudentReportCard src
group by src.ID


select StudentNumber, sub.ID [sub id],sub.MajorID,PeriodID, sum(Mark*WeightedMark) [nilai] from Enrollment en
join StudentSubject ssub on en.ID = ssub.EnrollmentID
join StudentReportCard src on src.StudentSubjectID = ssub.ID
join Period per on per.ID = en.PeriodID
join Competency com on com.ID = per.CompetencyID
join Subject sub on sub.ID = com.SubjectID
group by StudentNumber, sub.ID,sub.MajorID,PeriodID









/*
keluarin cetifikate/ ijazah siswa yang total nilainya yang tidak seharusnya
*/

select * from Certificate
select * from StudentReportCard

select * , SUM(src.Mark * src.WeightedMark) Nilai
from Certificate c
join Student stu on c.StudentNumber = stu.StudentNumber
join Enrollment e on stu.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID 
join Period per on per.ID = e.PeriodID
join Competency com on com.ID = per.CompetencyID
join Subject sub on sub.ID = com.SubjectID
group by c.ID, c.StudentNumber, c.GraduateDate, c.TotalMark, c.Grade, c.AcademicTitle, c.Level
having c.TotalMark != SUM(src.Mark * src.WeightedMark)



















--Alvenio
/*
buatkan sp,
buat generate certificate, berdasarkan majorid
*/

select * from Certificate
select * from Major
select * from Subject


--totalmark
;with nilaiMark as (
select StudentNumber, sub.ID [sub id],sub.MajorID,PeriodID, sum(Mark*WeightedMark) TotalMark from Enrollment en
join StudentSubject ssub on en.ID = ssub.EnrollmentID
join StudentReportCard src on src.StudentSubjectID = ssub.ID
join Period per on per.ID = en.PeriodID
join Competency com on com.ID = per.CompetencyID
join Subject sub on sub.ID = com.SubjectID
group by StudentNumber, sub.ID,sub.MajorID,PeriodID
)
--select * from nilaiMark

--insert
select distinct c.ID, s.StudentNumber, GETDATE() GraduateDate,
		nm.TotalMark,
		CASE 
            WHEN nm.TotalMark > 50 and nm.TotalMark < 60 THEN 'PAS'
            WHEN nm.TotalMark > 60 and nm.TotalMark < 75 THEN 'CRE' 
			WHEN nm.TotalMark > 75 and nm.TotalMark < 85 THEN 'DIS'
			WHEN nm.TotalMark > 85 THEN 'HDS'
            ELSE 'TidakLulus'
		END AS Grade,
		m.Name as AcademicTitle,
		m.Level
from Certificate c
join Student s on c.StudentNumber = s.StudentNumber
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
join Period p on e.PeriodID = p.ID
join Competency com on p.CompetencyID = com.ID
join Subject sub on com.SubjectID = sub.ID
join Major m on sub.MajorID = m.ID
join nilaiMark nm on m.id = nm.MajorID
where m.id = 5






--Table Type
drop type CertificateBaru
create type CertificateBaru as table
(
ID bigint,
StudentNumber varchar(20),
GraduateDate datetime,
TotalMark decimal,
Grade varchar(3),
AcademicTitle varchar(200),
Level varchar(1)
)




create procedure NewCertificate (@Majorid int, @tableBaru as CertificateBaru readonly)
as begin


insert into @tableBaru (ID, StudentNumber, GraduateDate, TotakMark, Grade, AcademicTitle, Level)
values


;with nilaiMark as (
select StudentNumber, sub.ID [sub id],sub.MajorID,PeriodID, sum(Mark*WeightedMark) TotalMark from Enrollment en
join StudentSubject ssub on en.ID = ssub.EnrollmentID
join StudentReportCard src on src.StudentSubjectID = ssub.ID
join Period per on per.ID = en.PeriodID
join Competency com on com.ID = per.CompetencyID
join Subject sub on sub.ID = com.SubjectID
group by StudentNumber, sub.ID,sub.MajorID,PeriodID
)
--select * from nilaiMark

--insert
select distinct c.ID, s.StudentNumber, GETDATE() GraduateDate,
		nm.TotalMark,
		CASE 
            WHEN nm.TotalMark > 50 and nm.TotalMark < 60 THEN 'PAS'
            WHEN nm.TotalMark > 60 and nm.TotalMark < 75 THEN 'CRE' 
			WHEN nm.TotalMark > 75 and nm.TotalMark < 85 THEN 'DIS'
			WHEN nm.TotalMark > 85 THEN 'HDS'
            ELSE 'TidakLulus'
		END AS Grade,
		m.Name as AcademicTitle,
		m.Level
from Certificate c
join Student s on c.StudentNumber = s.StudentNumber
join Enrollment e on s.StudentNumber = e.StudentNumber
join StudentSubject ss on e.ID = ss.EnrollmentID
join StudentReportCard src on ss.ID = src.StudentSubjectID
join Period p on e.PeriodID = p.ID
join Competency com on p.CompetencyID = com.ID
join Subject sub on com.SubjectID = sub.ID
join Major m on sub.MajorID = m.ID
join nilaiMark nm on m.id = nm.MajorID
where m.id = 5



end

execute NewCertificate @Majorid = '5'

