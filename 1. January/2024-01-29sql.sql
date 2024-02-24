use Northwind

--STR, jadi string
select STR(12)


declare @angka as int = 10,
		@stringAngka as varchar(5) = '100'

--PARSE, adalah fungsi yang digunakan untuk mengonversi data string menjadi jenis data yang diminta 
--dan mengembalikan hasilnya sebagai ekspresi. 
select PARSE(@stringAngka as int) * 2 

--str menjadikan angka jadi string
--parse menjadikan string jadi apapun

select STR(@angka)
select STR(EmployeeID) as IdString
from Employees

select PARSE(PostalCode as bigint) as IdString
from Employees
where EmployeeID < 4


select * from Employees
--try parse menjadikan nilai yang gagal jadi null
select TRY_PARSE(PostalCode as bigint) as IdString
from Employees


go
declare @angka as int = 10,
		@stringAngka as varchar(5) = '100'
--cast convert, mengubah apapun jadi apapun sperti int, decimal, varchar,dll
select CONVERT(int, @stringAngka),
		CONVERT(varchar(10), @angka) *1,
		CAST(@stringAngka as int)

--CONVERT,  fungsi umum yang mengubah ekspresi salah satu tipe data yang lain
--CAST pada SQL adalah fungsi yang digunakan untuk mengkonversi nilai (dari semua jenis) menjadi tipe data yang ditentukan

declare @hariKemerdekaan as datetime = '1945-08-17'

select GETDATE(), --waktu saat ini
		GETUTCDATE() --Waktu london

--Fungsi GETDATE() dalam SQL Server digunakan untuk mengambil tanggal dan waktu sistem database saat ini.

go 
declare @hariKemerdekaan as datetime = '1945-08-17'

--DAY, MONTH, WEEK w
--DATENAME,Mengambil Data nama tanggal menjadi string
select GETDATE(),
DATENAME(DAY, @hariKemerdekaan)

--membuat sebuah tanggal
select DATEFROMPARTS(2024, 1, 22)

--DATETIMEFROMPARTS lengkap dengan jam
select DATENAME(w, DATEFROMPARTS(2024, 1, 22)),
DATETIMEFROMPARTS(2024,1,22,10,10,0,0)

--isdate mengecek apakah itu format benar date atau tidak
select ISDATE('29-01-2024'), ISDATE('01-11-2024')



go 
declare @hariKemerdekaan as datetime = '1945-08-17'

--DATEDIFF menghitung jarak antar 2 tanggal
select DATEDIFF(YEAR, @hariKemerdekaan, GETDATE())

-- DATEADD mengambil tanggal yang dipilih, jika tanggal mundur tambah minus -12
select DATEADD(DAY, 3, GETDATE())
select DATEADD(DAY, -3, GETDATE())

select DATEADD(DAY,2, '04-12-2024')

--PARSE dalam SQL adalah fungsi yang digunakan untuk mengonversi data string menjadi jenis data yang diminta 
--dan mengembalikan hasilnya sebagai ekspresi. 
select PARSE('09-01-2024' as datetime)



go 
declare @hariKemerdekaan as datetime = '1945-08-17'
--menghitung total data yang diatasnya saja
select @@ROWCOUNT 

select * from Employees
select @@ROWCOUNT

--mengecek nama server kita
select @@SERVERNAME



use Northwind

select * 
from Employees

select EmployeeID, CONCAT(FirstName, ' ', LastName) FullName
from Employees
where DATEDIFF(YEAR, BirthDate, GETDATE()) > 65




--customer id, name, total transaksi customernya, data diurutkan dari total transaksi terbanyak. dan ditampilkan diambil data ke 4 dan ke 5 saja

use Northwind

select * from Customers
select * from Orders

select ord.CustomerID, COUNT(cus.CustomerID) TotalTransaksi
from Customers cus
join Orders ord on cus.CustomerID = ord.CustomerID
group by ord.CustomerID, cus.CustomerID
order by TotalTransaksi desc
offset 3 rows
fetch next 2 rows only




--buat laporan untuk pengiriman barang disetiap bulan, untuk negara pengiriman prancis, jerman, brazil, mexico, opralia. sumbu y negara, sumbu x bulan. 5 kebawah, kesamping 12. 
--Buat laporan transaksi berapa kali pengirimannya,range semua transaksi di tahun 1996

select * from Products
select * from Orders
select * from [Order Details]
select * from Shippers

select o.ShipCountry, o.OrderID, o.ShippedDate, DATENAME(MONTH, o.ShippedDate) MonthShipper
from Orders o
join Shippers s on s.ShipperID = o.ShipVia
where o.ShipCountry in ('France','Germany', 'Brazil','Mexico','Austria') 
					AND DATENAME(YEAR, o.ShippedDate) = 1996

select * from (
select o.ShipCountry, o.OrderID, o.ShippedDate, DATENAME(MONTH, o.ShippedDate) MonthShipper
from Orders o
join Shippers s on s.ShipperID = o.ShipVia
where o.ShipCountry in ('France','Germany', 'Brazil','Mexico','Austria') 
					AND DATENAME(YEAR, o.ShippedDate) = 1996
) T1
pivot(
count(OrderID) for MonthShipper in ([January], [Febuary], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December])
) L1


--bikin soal 10 per kelompok, untuk kelompok lain

