-- 2024-01-24
use Northwind;
--select CategoryID , CategoryName, Description
--from Categories
--where CategoryID >= 4 and CategoryID <=8;

/*
Urutan Penting !!!

5 select [kolom]
1 from [table name]
1 join [table name]
2 where [kondisi]
3 group by [kolom]
4 having [kolom] ketika ada aggregate function sql
6 order by [kolom]

Penghubung 2 kondisi:
OR
AND

tidak sama dengan
!=
<>

3 value :
1. scalar = 1 data
select 'Alvenio'

2. list value = 1 list/lebih dari 1 scalar

3. tabel value = banyak data/list



*/


select CustomerID, CompanyName, Country
from Customers
where Country in ('Germany', 'Mexico', 'Argentina');

--Distinct untuk menghilangkan data yang double/sama
--Count untuk menghitung banyaknya Jumlah pada Category ID
select distinct COUNT (CategoryID)
from Categories;


select * from Products --where CategoryID = 1

--Count untuk mengetahui hasil jumlah pada product ID
select CategoryID, count(ProductID) TotalProduct
from Products
group by CategoryID

-- sum untuk melakukan penjumlahan 
select CategoryID, sum(UnitsOnOrder) TotalProduct
from Products
group by CategoryID

--AVG/Average untuk melakukan rata"
select CategoryID, AVG(UnitPrice) TotalHarga
from Products
group by CategoryID

--Max mengambil data harga tertinggi
select CategoryID, max(UnitPrice) TotalHarga
from Products
group by CategoryID

--Min mengambil data harga terendah
select CategoryID, min(UnitPrice) 'Total Harga'
from Products
group by CategoryID

--HAVING pada SQL memiliki fungsi yang sama seperti WHERE, namun digunakan untuk menerapkan kondisi pada agregate function
select CategoryID, min(UnitPrice) MinUnitPrice
from Products
group by CategoryID
having min(UnitPrice) >= 10

select COUNT(CategoryID)
from Products

select *
from Products

select CategoryID, COUNT(distinct UnitPrice) TotalJenisPrice
from Products
group by CategoryID;

select *
from Products
order by ProductName asc;

select *
from Products
order by ProductName desc;

select *
from Products
order by CategoryID asc, ProductName desc;

--count(1) untuk memanipulasi tabel baru
select CategoryID, COUNT(1) TotalProduct
from Products
group by CategoryID
order by TotalProduct






-- 2024-01-25

use Northwind;

select *
from Products;

select *
from Suppliers;

select ProductID, ProductName, SupplierID
from Products
where SupplierID is null
order by ProductID

--ASC/Asending untuk mengurutkan data sesuai abjad A-Z atau 1- 10(Data terkecil ke besar),dst
select top 10 * from Customers
order by city asc

--DESC/Desending untuk mengurutkan data kebalikan abjad Z-A atau 10-1(Data terbesar ke kecil),dst
select top 10 * from Customers
order by city desc

--OFFSET untuk menampilkan data dan Memulainya dari nomor data yang kita inginkan
--FETCH NEXT untuk memaksimalkan tampilan data yang kita inginkan
select * from Customers
order by city desc
offset 10 rows
fetch next 3 rows only

--TOP Untuk menampikkan data teratas
select top 3 * from Products
order by UnitPrice desc

--Dibawah adalah menggunakan Subquery
select SupplierID, CompanyName from Suppliers
where SupplierID in (select top 3 SupplierID from Products
order by UnitPrice desc)

select count(CategoryID) from Products
group by CategoryID

select CategoryID, count(1) TotalProduct
from Products
group by CategoryID

select * from (
select CategoryID, count(1) TotalProduct
from Products
group by CategoryID ) as tblBaru
where TotalProduct > 10

select *, (select max(UnitPrice) from Products) as tblBaru
from Suppliers

/*
--JOIN
inner join / join on
right join, on
left join, on
full join, on
cross join
self join
*/

--INNER JOIN
--JOIN adalah perintah dalam SQL yang berfungsi untuk menggabungkan informasi dari dua tabe

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
join Categories cat on prod.CategoryID = cat.CategoryID


--LEFT JOIN
--LEFT JOIN adalah fungsi yang digunakan untuk menggabungkan dan menampilkan seluruh data pada tabel kiri dan tabel kanan yang memenuhi kondisi JOIN

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
left join Categories cat on prod.CategoryID = cat.CategoryID

--RIGHT JOIN
--Menampilkan Semua Data Tabel Kanan: Dengan perintah RIGHT JOIN, Anda dapat menampilkan semua data dari tabel kanan (tabel kedua dalam pernyataan JOIN)

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
right join Categories cat on prod.CategoryID = cat.CategoryID

select *
from Products

select *
from Suppliers

select prod.ProductName, prod.UnitsInStock, sup.CompanyName
from Products prod
left join Suppliers sup on prod.SupplierID = sup.SupplierID
where UnitsInStock = 0;


--CROSS JOIN
--=adalah salah satu jenis join dalam SQL yang digunakan untuk menggabungkan setiap baris dari satu tabel dengan setiap baris dari tabel lainnya.
select emp.EmployeeID, cat.CategoryID 
from Employees emp
cross join Categories cat


--SELF JOIN
--adalah operasi penggabungan tabel dengan dirinya sendiri.
select prod.ProductName, *
from Products prod, Categories cat
where prod.CategoryID = cat.CategoryID



--jumlah total employee, jumlah total customer, jumlah total supplier

select count(emp.EmployeeID) JumlahEmp 
from Employees emp

select count(cus.CustomerID)
from Customers cus

select count(sup.SupplierID)
from Suppliers sup

--cara pertama
select count(distinct EmployeeID), count(distinct SupplierID), count(distinct CustomerID)
from Employees, Suppliers, Customers


--cara kedua

select emp.totalEmployee, cust.totalCustomer, sup.totalSupplier
from (
select 'A' PK, count(1) totalEmployee from Employees) emp
join (
select 'A' PK, count(1) totalCustomer from Customers)
cust on emp.PK = cust.PK
join (
select 'A' PK, count(1) totalSupplier from Suppliers)
sup on sup.PK = cust.PK


--Union
--menampilkan data dengan tabel yang berbeda(WAJIB sama untuk value nya!!)

/*
UNION menggabungkan dua atau lebih pernyataan SELECT dan menghapus rekaman duplikat, 
sedangkan UNION ALL menggabungkan hasil tanpa menghilangkan duplikat.
*/
select CompanyName as Name
from Customers cust
union
select CompanyName as Name
from Suppliers sup

--INTERSECT, yang ada di dalam kedua kolom, seperti inner join
select Country from Customers
intersect
select Country from Suppliers

--EXCEPT, yang tidak ada di kedua kolom
select Country from Customers
except
select Country from Suppliers

-- SOAL DAN JAWABAN EXCERCISE 1

--Manajemen ingin tahu perusahaan shipper mana yang paling populer dan yang paling mengantarkan banyak order di sepanjang masa. 
--Keluarkan nama 1 perusahaan shipper yang paling populer dengan total ordernya.

use Northwind

select *
from Shippers

select *
from Orders

select ship.CompanyName PerusahaanPopular, count(ord.ShipVia) TotalOrder
from Shippers ship, Orders ord
where ShipperID = shipvia
--right join Orders ord on ship.ShipperID = ord.OrderID
group by ship.CompanyName
order by TotalOrder desc


--Ingin diketahui seluruh Territory penjualan, beserta nama lengkap karyawan yang bekerja di territory tersebut. 
--Baik ada ataupun tidak ada karyawan, territory description harus tetap ditunjukan.

use Northwind

select *
from Territories

select *
from EmployeeTerritories

select *
from Employees

select CONCAT(emp.TitleOfCourtesy, ' ', emp.FirstName, ' ', emp.LastName) NamaLengkap, ter.TerritoryDescription
from EmployeeTerritories et
right join Territories ter on et.TerritoryID = ter.TerritoryID
join Employees emp on et.EmployeeID = emp.EmployeeID



--Kerugian di sisi penjualan bisa disebabkan oleh banyak scenario, salah satunya adalah kerusakaan product-product di tempat penyimpanan, 
--terutama barang pecah belah. Beberapa kemasan product-product ini memang mudah pecah, karena sebagian terbuat dari glasses (gelas kaca), 
--bottle (botol), dan jars (toples). Karena itu management membuatkan lemari penyimpanan baru yang lebih aman untuk barang pecah belah, 
--tetapi management kesulitan untuk menetukan barang yang mana yang harus di simpan lemari yang aman ini. Buatlah laporan dengan informasi nama product, 
--nama perusahaan supplier, nama category, jumlah quantity dalam kemasan dan unit in stock di penyimpanan, dimana semua barang tersebut memiliki kemasan 
--pecah belah berupa gelas kaca, botol atau toples.


use Northwind

select *
from Products

select *
from Suppliers

select *
from Categories

select prod.ProductName, sup.CompanyName, cat.CategoryName, prod.QuantityPerUnit, prod.UnitsInStock
from Products prod
join Suppliers sup on prod.SupplierID = sup.SupplierID
join Categories cat on prod.CategoryID = cat.CategoryID
where prod.QuantityPerUnit like '%glasses%' or prod.QuantityPerUnit like '%bottle%' or prod.QuantityPerUnit like '%jars%'



--Management ingin mengetahui rata-rata harga product-product per unitnya yang berasal dari supplier yang berada di negara-negara Eropa, 
--yaitu Germany, Spain, Sweden, Italy, Norway, Denmark, Netherland, Finland, dan France. Management ingin terus bekerja sama dengan supplier dari Eropa, 
--selama harga rata-rata productnya 50 dolar kebawah. Tunjukan harga rata-rata barang untuk setiap negara di Eropa, lalu tampilkan berurutan dari yang 
--tertinggi harga rata-ratanya sampai yang terendah, terkecuali yang harga rata-rata barangnya di atas 50 dollar.

use Northwind

select *
from Suppliers

select *
from Products

select avg(prod.UnitPrice) HargaRata2, sup.Country
from Products prod
join Suppliers sup on prod.SupplierID = sup.SupplierID
where sup.Country in ('Germany', 'Spain', 'Sweden', 'Italy', 'Norway', 'Denmark', 'Netherland', 'Finland', 'France')
group by sup.Country
having not avg(prod.UnitPrice) > 50
order by HargaRata2 desc




--Supervisor kalian yang ada di USA Branch, ingin agar salah satu karyawannya bertugas membawakan presentasi di USA. 
--Karyawannya harus yang sangat mengenal Amerika dan bagus bahasa inggrisnya, oleh karena itu harus yang berasal dari USA. 
--Ia ingin bertanya kepada setiap karyawannya yang ada di database via telphone. Jabarkanlah seluruh karyawan anda 
--dengan nama lengkap dan title of courseynya, beserta nomor telponnya.

use Northwind

select *
from Employees

select CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) NamaLengkap, HomePhone, Country
from Employees
where Country = 'USA'



--Gudang penyimpanan memiliki banyak section, dan tidak semua section memiliki besar ruang dan luas yang sama. 
--Di antara beberapa section tersebut ada 2 ruangan yang paling kecil. Stock dan warehouse management ingin membagi setiap section 
--untuk setiap category product, sehingga satu macam category akan di kelompokan dan di simpan dalam satu section. Management ingin mengetahui, 
--2 category product yang jumlah unit in stocknya paling sedikit, untuk disimpan pada 2 ruangan section yang paling kecil juga, agar menghemat tempat. 
--Tunjukan 2 Category beserta total unit in stocknya yang jumlahnya paling sedikit kepada management.

use Northwind

select *
from Products

select *
from Categories

select top 2 cat.CategoryName, sum(prod.UnitsInStock) totalUnit
from Categories cat
join Products prod on cat.CategoryID = prod.CategoryID
group by cat.CategoryName
order by totalUnit





-- 2024-01-26

--CTE
--Common Table Expression (CTE) adalah hasil sementara yang dapat digunakan sebagai referensi dalam pernyataan SQL selanjutnya.

select * from Employees

;WITH EmployeeRegionNull as (
	select * from Employees
	where Region is null
), EmployeeRegionWA as (
	select * from Employees
	where Region = 'WA'
)
select EmployeeID, CONCAT(FirstName, ' ', LastName) as Fullname
from EmployeeRegionNull
union
select EmployeeID, CONCAT(FirstName, ' ', LastName) as Fullname
from EmployeeRegionWA

select * from Customers

;with CustomerRegionNull as(
select * from Customers
where Region is null
),
CustomerRegionNotNull as (
select * from Customers
where Region is not null
)
select CustomerID, CompanyName, ContactName from CustomerRegionNull
union
select CustomerID, CompanyName, ContactName from CustomerRegionNotNull

select distinct CategoryID from Products

--PIVOT
--Pivot table merupakan ringkasan data statistik yang dikemas dalam bagan khusus.
--dengan cte
;with ProductTotal as (
select SupplierID, CategoryID, COUNT(1) TotalProduk
from Products
group by SupplierID, CategoryID
)
select pvt.* 
from ProductTotal
pivot( sum(TotalProduk)
for CategoryId in([1],[2],[3],[4],[5],[6],[7],[8]) ) as pvt


--tidak dengan cte
select pvt.* from(
select SupplierID, CategoryID, COUNT(1) TotalProduk
from Products
group by SupplierID, CategoryID
) as tblSumber
pivot(sum(TotalProduk) 
for CategoryId in ([1],[2],[3],[4],[5],[6],[7],[8])) as pvt

--cara menghilangkan null pada col
select ISNULL(null, 0) + 10

select * from Categories

select * from Suppliers

select pvt.CompanyName, ISNULL([Beverages],0) Beverages, ISNULL([Condiments], 0) Condiments, ISNULL([Confections], 0) Confections, ISNULL([Dairy Products], 0) DairyProducts,
ISNULL([Grains/Cereals],0) GrainsOrCereals, ISNULL([Meat/Poultry],0) MeatOrPoultry, ISNULL([Produce],0) Produce, ISNULL([Seafood],0) Seafood
from (
select sup.CompanyName, cat.CategoryName, COUNT(1)TotalProduk 
from Categories cat
join Suppliers sup on cat.CategoryID = sup.SupplierID
group by sup.CompanyName, cat.CategoryName
) as tblBaru
pivot(sum(TotalProduk)
for CategoryName in ([Beverages],[Condiments],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood] ) ) as pvt


select SupplierID, ProductName, COUNT(1) TotalProduk
from Products
group by SupplierID, ProductName

select pvt.* from(
select SupplierID, ProductName, COUNT(1) TotalProduk
from Products
group by SupplierID, ProductName
) as tblSumber
pivot(sum(TotalProduk)
for ProductName in ([Alice Mutton],[Aniseed Syrup],[Boston Crab Meat],[Camembert Pierrot],[Carnarvon Tigers],[Chai],[Chang]) ) as pvt


select * from Categories
select * from Products

--benar
select * from(
select s.CompanyName, c.CategoryName, ProductID
from Products p
join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on p.SupplierID = s.SupplierID
) as tbl
PIVOT(COUNT(ProductId) for CategoryName 
in ([Test],[Condiments],[Beverages],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood])
) as pvt


--tambah kolom dan baris total
select 
CompanyName, 
pvt.Condiments,
pvt.Beverages,
pvt.Confections,
pvt.[Dairy Products],
pvt.[Grains/Cereals],
pvt.[Meat/Poultry],
pvt.Produce,
pvt.Seafood,
(pvt.Condiments + 
pvt.Beverages + 
pvt.Confections + 
pvt.[Dairy Products] + 
pvt.[Grains/Cereals] + 
pvt.[Meat/Poultry] + 
pvt.Produce + 
pvt.Seafood) as Total 
from(
select s.CompanyName, c.CategoryName, ProductID
from Products p
join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on p.SupplierID = s.SupplierID
) as tbl
PIVOT(COUNT(ProductId) for CategoryName 
in ([Test],[Condiments],[Beverages],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood],[Total])
) as pvt

UNION ALL

select 'Total',
SUM(pvt.Condiments), 
sum(pvt.Condiments),
sum(pvt.Beverages),
sum(pvt.Confections),
sum(pvt.[Dairy Products]),
sum(pvt.[Grains/Cereals]),
sum(pvt.[Meat/Poultry]),
sum(pvt.Produce),
sum(pvt.Seafood),
sum(pvt.Total)
from (
select s.CompanyName, c.CategoryName, ProductID
from Products p
join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on p.SupplierID = s.SupplierID
) as tbl
PIVOT(COUNT(ProductId) for CategoryName 
in ([Test],[Condiments],[Beverages],[Confections],[Dairy Products],[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood],[Total])
) as pvt


--versi trainer kak Vina
;with TablePivot as (
	select *, (
	pvt.Condiments + 
	pvt.Beverages + 
	pvt.Confections + 
	pvt.[Dairy Products] + 
	pvt.[Grains/Cereals] + 
	pvt.[Meat/Poultry] + 
	pvt.Produce + 
	pvt.Seafood
) as Total 
from (
		select s.CompanyName, c.CategoryName, ProductID
		from Products p
		join Categories c on p.CategoryID = c.CategoryID
		join Suppliers s on p.SupplierID = s.SupplierID
	) as tbl
		PIVOT(COUNT(ProductId) for CategoryName 
		in ([Test],[Condiments],[Beverages],[Confections],[Dairy Products],
		[Grains/Cereals],[Meat/Poultry],[Produce],[Seafood])
	) as pvt
)
select * from TablePivot

union all

select 'Total',
SUM(Condiments), 
sum(Condiments),
sum(Beverages),
sum(Confections),
sum([Dairy Products]),
sum([Grains/Cereals]),
sum([Meat/Poultry]),
sum(Produce),
sum(Seafood),
sum(Total)
from TablePivot




--VAARIABLE

--DECLARE @NAMAVARIABLE AS TIPEDATA
DECLARE @ANGKAPERTAMA AS INT

--DECLARE @NAMAVARIABLE AS TIPEDATA = VALUE
DECLARE @ANGKAKEDUA AS INT = 10

set @ANGKAPERTAMA = 100
set @ANGKAPERTAMA = 50


select @ANGKAPERTAMA + 10, @ANGKAKEDUA
select @ANGKAPERTAMA, @ANGKAKEDUA
print @ANGKAKEDUA
print concat(@ANGKAPERTAMA, @ANGKAKEDUA)

go
declare @angkakedua as int = 100
select @ANGKAKEDUA

--BIGINT, INT, TINYINT

declare @namalengkap as varchar(40) = (
select concat(FirstName, ' ', LastName) as Fullname
from Employees
where EmployeeID = 1
)

Select @namalengkap




declare @namadepan as varchar(20) = 'Alvenio',
		@namaBelakang as varchar(20) = 'Farhan'

--UPPER, Membuat TEXT pada karakter menjadi Besar semua
--LOWER, Membuat TEXT pada karakter menjadi Kecil semua
select UPPER(@namadepan), LOWER(@namaBelakang)

--SUBSTRING, untuk menghilangkan karakter/text pada kalimat pilihan
select SUBSTRING(CONCAT(@namadepan, ' ', @namabelakang), 3, 10)


--len untuk hitung karakter
--datalength hitung bit
select LEN(@namadepan), DATALENGTH(@namadepan)

--patindex cari karakter untuk pertamakalinya
declare @companyname as varchar(100) = 'Indocyber Global Teknologi'
select PATINDEX('%A%', @companyname)

--sama persis dengan yang dicari
select CHARINDEX('O', @companyname)

--menghapus kanan dan kiri karakter
--ada RTRIM untuk hapus kanan, ada LTRIM untuk hapus kiri
select TRIM(' Alvenio ')

--GO, sebelm declare untuk menjalankan data yang dipilih setelah Query GO
go
declare @companyname as varchar(100) = 'Indocyber Global Teknologi'

--LEFT, mengambil karakter dari kiri
--RIGHT,  mengambil karakter dari kanan
select left (@companyname, 3), RIGHT(@companyname, 5)

--REPLICATE,Mengulangi data/karakter sebanyak data yg kita mau
select REPLICATE('WK', 4)

go
declare @companyname as varchar(100) = 'Indocyber Global Teknologi'

--REPLACE, untuk mengganti data pilihan kita
select REPLACE(@companyname, 'Indocyber', 'Indonesia')

select REPLACE('12345', '5', '1')

--REVERSE, untuk melakukan kebalikan pada data/karakter
select REVERSE('Indonesia')

--Compatibility Level refers to the way SQL Server operates in relation to a specific version of SQL Server. 
alter database northwind set compatibility_level = 130;

declare @kumpulanNamaHewan as varchar(max) = 'Kucing, Anjing, Kelinci, Kuda'

select value as [Hewan] from string_split(@kumpulanNamaHewan, ',')


--STR mengubah value ke tipe data string
select CustomerID as id, CompanyName from Customers
union
select str(SupplierID), CompanyName from Suppliers


go
declare @namadepan as varchar(20) = 'viNA',
@namabelakang as varchar(20) = 'SeptiAni'

--CONCAT, untuk menggabungkan data/karakter pilihan kita
select concat(@namadepan, ' ', @namabelakang)

set @namadepan ='Vina'
set @namabelakang = 'Septiani'

select concat(@namadepan, ' ', @namabelakang) FullName

go
declare @namadepan as varchar(20) = 'viNA',
@namabelakang as varchar(20) = 'SeptiAni'
select 'Vina Septiani',
CONCAT(UPPER(SUBSTRING(@namadepan, 1, 1)),
LOWER(SUBSTRING(@namadepan, 2, LEN(@namadepan))), ' ',
UPPER(SUBSTRING(@namabelakang, 1, 1)),
LOWER(SUBSTRING(@namabelakang, 2, LEN(@namabelakang)))
)

go
declare @namadepan as varchar(20) = 'alVENIO',
@namabelakang as varchar(20) = 'FarHAn'

select 'Alvenio Farhan',
CONCAT(upper(SUBSTRING(@namadepan, 1, 1)),
LOWER(SUBSTRING(@namadepan, 2, LEN(@namadepan))), ' ',
upper(SUBSTRING (@namabelakang, 1,1)),
LOWER(SUBSTRING (@namabelakang, 2, LEN(@namabelakang))))


go
declare @angkapertama as int = 10;
declare @angkakedua as int = 20;
declare @persen as decimal(5,2);
declare @uang as decimal(7,2) = 2000.22;

select @uang * 2

--SQRT, untuk akar pangkat
--POWER, untuk pangkat
select SQRT(144), POWER(2,3)


go
declare @uang as decimal(7,2) = 2000.22;
--pembulatan
--CEILING, Pembulatan ke atas
--FLOOR, Pembulatan ke bawah
select CEILING(@uang), FLOOR(@uang)
--ROUND, membulatkan angka ke sejumlah tempat desimal tertentu.
select ROUND(@uang, 0), ROUND(@uang, 1), ROUND(@uang,2)


--format menjadi string bukan numerik/number
go
declare @uang as decimal(18,0) = 25000;
--C curency, N numerik, G general
select FORMAT(@uang, 'C', 'id-ID'), --indo
FORMAT(@uang, 'N', 'id-ID'),
FORMAT(@uang, 'G', 'id-ID'),
FORMAT(@uang, 'C', 'en-US') --dolar





-- 2024-01-29

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

--TRY_PARSE untuk convert error, untuk handle error jenis parsing
select TRY_PARSE('abc' as int)


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

/*
Soal 1 - Alvenio Farhan Prayogo

Tampilkan data ke 3 - 5 nama lengkap serta title karyawan dan total ongkos kirim dari order yang  mereka layani, diurutkan berdasarkan 
total ongkos kirim terbesar. 
*/

select * from Orders
select * from Employees

select CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName)) NamaLengkap, sum(ord.Freight) TotalOngkir
from Orders ord
join Employees emp on ord.EmployeeID = emp.EmployeeID
group by CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName))
order by TotalOngkir desc
offset 2 rows 
fetch next 3 rows only




/*
Soal 2 - Alvenio Farhan Prayogo

Buat tabel pivot Laporan tiap Karyawan berapa kali order menggunakan Pengiriman yang sama. Jadi menampilkan Nama 
Lengkap Karyawan dan nama Pengirimnya
*/

;with Tabel as (
select CONCAT(e.FirstName, ' ', e.LastName) FullName , s.CompanyName, o.OrderID
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
join Employees e on o.EmployeeID = e.EmployeeID
)
select pvt.* from Tabel
pivot(count(OrderID) for CompanyName 
in ([Speedy Express], [United Package], [Federal Shipping]) 
) as pvt



/*
Soal 3 - Edwin Desemsky

Tampilkan 3 data berupa nama lengkap pegawai beserta title of courtesynya yang berusia lebih dari 20 tahun sejak hari ini
yang paling banyak melayani customer dengan range tahun 1996 hingga 1997  dan diurutkan dari yang terkecil hingga terbesar 
berdasarkan total customer yang telah dilayani 
*/


select top 3 concat(e.TitleOfCourtesy,' ',concat(e.FirstName,' ',e.LastName))  [Nama Lengkap Pegawai], count(ord.CustomerID) [Customer yang Dilayani]
from Employees e
join orders ord on ord.EmployeeID = e.EmployeeID
where DATEDIFF(year,e.BirthDate,getdate()) > 20 and datename(year,ord.OrderDate) between 1996 and 1997
group by e.TitleOfCourtesy,e.FirstName,e.LastName
order by [Customer yang Dilayani] asc;

/*
Soal 4 - Edwin Desemsky

Buatlah laporan pemesanan barang yang terbuat dari bahan botol(bottles),kaleng (cans),dan box (boxes) tiap tahun (1996,1997,1998) 
dan total jumlah pemesanan tiap produknya dari tahun 1996-1998
note: sumbu x:tahun , sumbu y:  nama produk

*/

select pvt.ProductName,pvt.[1996],pvt.[1997],pvt.[1998],(pvt.[1996] + pvt.[1997] + pvt.[1998]) [Total]
FROM(	select ord.OrderID, p.ProductName,datename(Year,ord.OrderDate) TahunPemesanan
		from Products p
		join [Order Details] ordet on ordet.ProductID = p.ProductID
		join Orders ord on ord.OrderID = ordet.OrderID
		where  p.QuantityPerUnit like '%bottles%' or p.QuantityPerUnit like '%cans%' or p.QuantityPerUnit like '%boxes%'
)AS tabelBaru
PIVOT(count(OrderID) for tabelBaru.TahunPemesanan IN ([1996], [1997], [1998])) as pvt

/*
Soal 5 - Bunga Fairuz

Tampilkan nama kontak dan nomer telepon customer yang pernah membeli produk yang stoknya habis dan sudah diskontinu
*/
select distinct c.ContactName, c.Phone
from Orders o
join (select od.OrderID, p.ProductID, p.ProductName
	from [Order Details] od
	join Products p on p.ProductID = od.ProductID
	where p.Discontinued = 1 and p.UnitsInStock <= 0) orderProduct on orderProduct.OrderID = o.OrderID
join Customers c on c.CustomerID = o.CustomerID



/*
Soal 6 - Bunga Fairuz

Buatlah laporan total ongkos kirim (freight) untuk masing-masing shipper company dalam satu tahun pada 
tahun (1996, 1997, 1998) dengan nilai total ongkir pembulatan ke atas tanpa angka nol di belakang koma 
1996, 1997, 1998 (sumbu x)
List shipper company name (sumbu y)
*/

SELECT pvt.ShipCompany [Ship Company], 
	cast(CEILING([1996]) as bigint) [1996], 
	cast(CEILING([1997]) as bigint) [1997],
	cast(CEILING([1998]) as bigint) [1998]
FROM (
	select s.CompanyName as ShipCompany, DATENAME(YEAR, ShippedDate) as yearShipped, Freight
	from Orders o
	join Shippers s on s.ShipperID = o.ShipVia
)AS orderShip
PIVOT(SUM(orderShip.Freight) 
FOR orderShip.yearShipped IN ([1996], [1997], [1998])) AS pvt

/*
Soal 7 - Anan Sosmita

Tampilkan data nama produk, nama kategori dimana ReOrderLevel lebih tinggi dari 20 dan diurutkan dari ReOrderLevel paling tinggi. 
kemudian ambilah data ke 6 dan 7
*/

select p.ProductName, c.CategoryName, p.ReorderLevel
from Products p
join Categories c on c.CategoryID = p.CategoryID
where p.ReorderLevel >20
order by p.ReorderLevel DESC
offset 5 row
fetch next 2 row only

/*
Soal 8 - Anan Sosmita

tampilkan 3 data  supplier yang terdiri dari nama perusahaan, kota dan negara sebagai alamat lengkap perusahaan,
nama produk yang di supply, serta harga rata-rata produk di negara Norway,Denmark,Finland, dan Spain 
dan diurutkan berdasarkan harga rata-rata produk yang paling tinggi
*/

select top 3 concat (s.CompanyName,' ', s.City,' ', s.Country)[Alamat Lengkap Perusahaan], p.ProductName, 
avg(p.UnitPrice) [Harga Rata-rata Produk]
from Products p
join Suppliers s on s.SupplierID = p.SupplierID
where Country in ('Norway','Denmark','Finland','Spain')
group by s.CompanyName, s.City, s.Country,  p.ProductName
order by [Harga Rata-rata Produk] DESC

/*
Soal 9 - Afifah
Tampilkan harga produk tertinggi di tiap nama company supplier yg berawalan huruf a,i,u,e,o
dan diiurutkan dari harga tertinggi
 */

select s.CompanyName, max(UnitPrice) hargaMax
from Suppliers s
inner join Products p on s.SupplierID=p.SupplierID
where s.CompanyName like 'a%' OR s.CompanyName like 'i%' OR s.CompanyName Like 'u%' Or s.CompanyName like 'e%' or s.CompanyName like 'o%'
group by s.CompanyName
order by hargaMax desc


/*
Soal 10 - Afifah

Buat tabel pivot laporan jumlah pengiriman pesanan yang dilayani oleh masing-masing employee (fullname) ke 
negara uk, usa, brazil, germany, dan venezuela di tahun 1998 dan dikirim melalui speedy Express.
Laporan berisi nama lengkap employee(sumbu y), country(sumbu x)
 */ 

 select *
from
(select concat (emp.FirstName, ' ', emp.LastName) fullname, ord.ShipCountry, ord.OrderID
from Employees as emp
join orders as ord on emp.employeeID=ord.EmployeeID
join Shippers as ship on ord.ShipVia=ship.ShipperID
where ord.ShipCountry in ('UK', 'USA', 'Brazil', 'Germany', 'Venezuela') and DATENAME (YEAR, ord.ShippedDate) = 1998 and ship.CompanyName = 'Speedy Express'
) tbl
pivot (
	count(OrderID) for ShipCountry in ([UK], [USA], [Brazil], [Germany],[Venezuela])
	) pvt





-- 2024-01-30

use Northwind
--Tulis query SQL untuk menemukan 2 karyawan dengan pengalaman kerja terlama dan 2 karyawan dengan selisih pengalaman kerja terbesar

select * from Employees

select FirstName, HireDate, DATEDIFF(YEAR, HireDate,GETDATE()) Pengalamankerja
from Employees
order by Pengalamankerja desc


--video (SOAL AMBIGU)
select top 2 CONCAT(FirstName, ' ', LastName) [Terlama], CONCAT(FirstName, ' ', LastName) [Selisih Terbesar] 
from Employees
order by DATEDIFF(YEAR, HireDate, GETDATE())



--Tampilkan 3 data berupa nama lengkap pegawai beserta title of courtesynya yang berusia lebih dari 20 tahun sejak hari ini--yang paling banyak melayani customer dengan range tahun 1996 hingga 1997  dan diurutkan dari yang terkecil hingga terbesar --berdasarkan total customer yang telah dilayaniselect * from Employeesselect * from Customersselect * from Ordersselect CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) NamaLengkap, COUNT(ord.CustomerID) Customerfrom Employees empjoin Orders ord on emp.EmployeeID = ord.EmployeeIDwhere DATEDIFF(YEAR, BirthDate,GETDATE()) >=20 and DATENAME(YEAR, OrderDate) between 1996 and 1997group by emp.TitleOfCourtesy, emp.FirstName, emp.LastNameorder by Customer asc--videoselect top 3 CONCAT(e.TitleOfCourtesy, ' ', e.FirstName, e.LastName) NamaLengkap, COUNT(o.CustomerID) CustomerDilayanifrom Employees ejoin Orders o on e.EmployeeID = o.EmployeeIDwhere DATEDIFF(year, e.BirthDate, GETDATE()) > 20 and DATENAME(year, o.OrderDate) between 1996 and 1997group by e.TitleOfCourtesy, e.FirstName, e.LastNameorder by CustomerDilayani asc--Buatkan laporan karyawan dengan Title of Courtesy Mr yang menangani order yang dihitung berdasarkan tanggal order dibuat--dengan sumbu x adalah bulan januari hingga december pada tahun 1997 dan sumbu Y adalah Nama employee --dengan TitleofCourtesy Mr dengan total banyaknya orderan yang diproses karyawan tersebut dalam satu tahun--dan diurutkan berdasarkan jumlah order yang terbanyak diproses oleh karyawan tersebut--X januari - des--Y nama employeeselect * from Employeesselect * from Orders/*;with tabel as (select CONCAT(emp.TitleOfCourtesy, ' ', emp.FirstName, ' ', emp.LastName) NamaLengkap, ord.OrderIDfrom Employees empjoin Orders ord on emp.EmployeeID = ord.EmployeeIDwhere emp.TitleOfCourtesy = 'Mr.'and datename(year, ord.orderdate) = '1997'group by emp.TitleOfCourtesy ,emp.FirstName, emp.LastName)*/--video;with PivRes as (select * from (select CONCAT(e.FirstName, ' ', e.LastName) FullName, DATENAME(MONTH,o.OrderDate) Bulan, COUNT(*) Ordersfrom Employees ejoin Orders o on e.EmployeeID = o.EmployeeIDwhere DATENAME(YEAR, o.OrderDate) = 1997 and e.TitleOfCourtesy = 'Mr.'group by e.FirstName, e.LastName, o.OrderDate) SourcePIVOT(Count(Orders) for Bulan in ([January],[February], [March], [April], [May], [June],								[July], [August], [September], [October], [November], [December])	) as pvt)select *, ([January] +[February] +[March] +[April] +[May]+[June] +[July] +[August] +[September] +[October] +[November] +[December]) Totalfrom PivResorder by Total desc--union all--select sum(January) ,--sum(February) ,--sum(March) ,--sum(April) ,--sum(May),--sum(June) ,--sum(July) ,--sum(August) ,--sum(September) ,--sum(October) ,--sum(November) ,--sum(December)--from PivRes--Buatkan laporan untuk karyawan yang berumur lebih dari 65 tahun dan sudah bekerja selama lebih dari 30 tahun--yang berhasil menjual produk berdasarkan perusahaan pengiriman--tampilkan nama lengkap karyawan, dan nama perusahaan pengirimanselect * from Employeesselect * from Ordersselect * from Shippers;with tabel as (select CONCAT(emp.FirstName, ' ', emp.LastName) NamaLengkap, s.CompanyName, ord.OrderIDfrom Employees empjoin Orders ord on emp.EmployeeID = ord.EmployeeIDjoin Shippers s on emp.EmployeeID = s.ShipperIDwhere DATEDIFF(YEAR, BirthDate,GETDATE()) > 65 and DATEDIFF(YEAR, HireDate,GETDATE()) > 30)select *from tabelpivot(count(OrderID) for CompanyNamein ([Speedy Express], [United Package], [Federal Shipping])) as pvt--video;with tabel as (select CONCAT(FirstName, ' ', LastName) FullName, o.EmployeeID, s.CompanyNamefrom Employees ejoin Orders o on e.EmployeeID = o.EmployeeIDjoin Shippers s on s.ShipperID = o.ShipViawhere DATEDIFF(YEAR, HireDate, GETDATE()) > 30 and DATEDIFF(YEAR, BirthDate, GETDATE()) > 65)select pvt.*from tabelpivot( count(EmployeeID) for CompanyName in ([Speedy Express], [United Package], [Federal Shipping]))as pvt/* Tampilkan nama lengkap yang berasal dari tabel employees sesuai dengan format daftar pustaka. (Dimana nama belakang diposisikan pada bagian depan serta dipisahkan dengan tanda koma dan pastikan huruf awal dari setiap nama depan atau belakang harus huruf kapital)*/select * from Employeesselect CONCAT(UPPER(SUBSTRING(emp.LastName, 1, 1)),
LOWER(SUBSTRING(emp.LastName, 2, LEN(emp.LastName))), ', ',
UPPER(SUBSTRING(emp.FirstName, 1, 1)),
LOWER(SUBSTRING(emp.FirstName, 2, LEN(emp.FirstName)))
) FormatName--CONCAT(emp.LastName, ',', ' ', emp.FirstName) FormatNamefrom Employees emp/*tampilkan order id, nama produk, categori produk, unitprice, quantity, buatlah juga total unit Price, total quantity, total bayar per baris dan total bayar dari semua pembayaran yang diorder lebih dari tahun 1996 dan quantity yang diorder lebih dari sama dengan 70 buah dan status produk yang discountinue, dengan catatan total bayar menggunakan format US dollar*/select * from Productsselect * from [Order Details]select * from Ordersselect * from Categoriesselect o.OrderID, p.ProductName, cat.CategoryName, p.UnitPrice, od.Quantity, (p.UnitPrice * od.Quantity)TotalBayarfrom Products pjoin [Order Details] od on p.ProductID = od.ProductIDjoin Orders o on od.OrderID = o.OrderIDjoin Categories cat on cat.CategoryID = p.CategoryIDwhere DATEDIFF(YEAR, o.OrderDate,GETDATE()) > 1996 and od.Quantity >= 70 and p.Discontinued = 1--videoselect od.OrderID, p.ProductName, c.CategoryName, p.Discontinued, od.UnitPrice, od.Quantity, FORMAT(SUM(od.UnitPrice*od.Quantity), 'C', 'en-US') TotalBayarfrom [Order Details] odjoin Orders o on od.OrderID = o.OrderIDjoin Products p on od.ProductID = p.ProductIDjoin Categories c on p.CategoryID = c.CategoryIDwhere DATENAME(YEAR, o.OrderDate) > 1996 and od.Quantity >= 70 and p.Discontinued = 1group by od.OrderID, p.ProductName, c.CategoryName, od.UnitPrice, od.Quantity, p.Discontinuedunion allselect '','','','', sum(od.UnitPrice) TotalUnitPrice, sum(od.Quantity) TotalQuantity, FORMAT(SUM(od.UnitPrice*od.Quantity), 'C', 'en-US') TotalBayarfrom [Order Details] odjoin Orders o on od.OrderID = o.OrderIDjoin Products p on od.ProductID = p.ProductIDjoin Categories c on p.CategoryID = c.CategoryIDwhere DATENAME(YEAR, o.OrderDate) > 1996 and od.Quantity >= 70 and p.Discontinued = 1--Tampilkan employee Id, nama lengkap employee, deskripsi region, dan --dimana region nya adalah Northern dan employee teritori Id diatas 45000 --serta umur employee hingga saat ini diatas 50 tahun dimana tabel y adalah --EmployeeID dan tabel x adalah Nama Lengkap, deskripsi region, dan deskripsi teritori yang dibuat pivot--dan diurutkan berdasarkan nama lengkapselect * from Employeesselect * from Region/*;with tabel as (select emp.EmployeeID, CONCAT(emp.FirstName, ' ', emp.LastName) NamaLengkap, reg.RegionDescriptionfrom Employees empjoin Region reg on reg.RegionID = emp.EmployeeIDwhere DATEDIFF(YEAR, emp.BirthDate,GETDATE()) > 50 and reg.RegionDescription = 'Northern')select *from tabelPIVOT(COUNT(EmployeeID) for NamaLengkap 
in ([])
) as pvt
*/

--video

select * from (
select e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) NamaLengkap, t.TerritoryID, r.RegionDescription, t.TerritoryDescription
from EmployeeTerritories et
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
join Employees e on et.EmployeeID = et.EmployeeID
where t.RegionID = 3 and et.TerritoryID >= 45000 and DATEDIFF(YEAR, BirthDate, GETDATE()) >= 50
) as tabel
PIVOT( count(TerritoryID) for TerritoryDescription in ([Findlay],[Racine],[Southfield], [Troy], [Bloomfield Hills], [Roseville], [Minneapolis])
) as pvt


--Manajemen ingin tahu produk yang terjual dengan harga diatas 50 di bulan januari tahun 1997 yang mendapatkan diskon. --Tampilkan order id, nama produk, harga produk, diskon, tanggal pengiriman, dan harga produk setelah mendapatkan diskon.--VIDEO HILANGselect * from Productsselect * from Ordersselect * from [Order Details]select o.OrderID, p.ProductName, p.UnitPrice, od.Discount, o.ShippedDate, ((p.UnitPrice*od.Quantity)-((p.UnitPrice*od.Quantity)*od.Discount)) HargaDiskonfrom Products pjoin [Order Details] od on p.ProductID = od.ProductIDjoin Orders o on o.OrderID = od.OrderIDwhere p.UnitPrice > 50 and DATENAME(YEAR, o.OrderDate) = 1997 and DATENAME(MONTH, o.OrderDate) = 'January' and od.Discount != 0group by o.OrderID--Tampilkan nama produk, nama lengkap employee dan banyak setiap produk --dari detail order yang dipertanggungjawabkan oleh Employee yang berumur kurang dari 64 tahun, --diurutkan berdasarkan nama produkselect * from Productsselect * from Employeesselect * from Ordersselect * from [Order Details]select p.ProductName, CONCAT(emp.FirstName, ' ', emp.LastName) NamaLengkap, count(distinct od.Quantity) BanyakProdukfrom Employees empjoin Orders o on emp.EmployeeID = o.EmployeeIDjoin [Order Details] od on od.OrderID = o.OrderIDjoin Products p on p.ProductID = od.ProductIDwhere DATEDIFF(YEAR, o.OrderDate, GETDATE()) < 64group by p.ProductName, emp.FirstName, emp.LastNameorder by p.ProductName--videoselect p.ProductName, CONCAT(e.FirstName, ' ', e.LastName) FullName, SUM(od.Quantity) Jumlahfrom Employees ejoin Orders o on e.EmployeeID = o.EmployeeIDjoin [Order Details] od on od.OrderID = o.OrderIDjoin Products p on od.ProductID = p.ProductIDwhere DATEDIFF(YEAR, BirthDate, GETDATE()) < 64group by p.ProductName, e.FirstName, e.LastNameorder by p.ProductName asc--Tampikan negara dan kota shipper kemudian tampilkan banyak pengiriman masing-masing kota dari tahun 1996-1999, --sumbu X merupkan tahun dan subu Y berupa negara dan kotaselect * from Shippersselect * from Ordersselect * from (
select o.ShipCountry, o.OrderID, o.ShippedDate, DATENAME(YEAR, o.ShippedDate) YearShipper
from Orders o
join Shippers s on s.ShipperID = o.ShipVia
where DATENAME(YEAR, o.ShippedDate) between 1996 and 1999
) Tabel
pivot(
count(OrderID) for YearShipper in ([1996],[1997],[1998],[1999])
) pvt

--video
select * from (
select OrderID, ShipCity, ShipCountry
from Orders
where DATENAME(YEAR, ShippedDate) between 1996 and 1999
) tabel
pivot(count(ShipCountry) for OrderId in ([1996],[1997],[1998],[1999])
) pvt




--Urutkan Jumlah orderan dari yang terbesar ke terkecil pada territory 'Edison', 'Philadelphia', 'Atlanta', 'Orlando', 'Racine' tahun 1997

select * from Orders
select * from Territories

select t.TerritoryDescription ,COUNT(o.OrderID) TotalOrderan
from Orders o
join Employees emp on emp.EmployeeID = o.EmployeeID
join EmployeeTerritories et on et.EmployeeID = emp.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
where t.TerritoryDescription in ('Edison', 'Philadelphia', 'Atlanta', 'Orlando', 'Racine') and DATENAME(YEAR, o.OrderDate) = 1997
group by t.TerritoryDescription
order by TotalOrderan desc





--Pada awal tahun 1999 Manejer pemasaran membutuhkan sebuah laporan  pendapatan penjualan  --berdasarkan tahun sebelumnya yang dimana laporan tersebut akan di pakai untuk mengambil--keputusan menyetok lebih banyak produk yang laku terjual. Manajer hanya meminta 10 produk--terlaku serta besar pendapatanselect * from Productsselect * from Employees--videoselect top 10 p.ProductName, sum(od.UnitPrice* od.Quantity) TotalPendapatanfrom Orders ojoin [Order Details] od on od.OrderID = o.OrderIDjoin Products p on p.ProductID = od.ProductIDwhere YEAR(o.OrderDate) = 1998group by p.ProductNameorder by sum(od.Quantity) desc--tampilkan nama perusahaan, nama produk, dan negara perusahaan tersebut yang memiliki produk discontinuedselect * from Productsselect * from Suppliersselect s.CompanyName, p.ProductName, s.Country, p.Discontinuedfrom Products pjoin Suppliers s on p.SupplierID = s.SupplierIDwhere p.Discontinued <> 0--Buatkan laporan reporting menggunakan PIVOT dengan kondisi seperti berikut, --Untuk sumbu X-nya adalah CategoryName, --Untuk sumbu Y-nya adalah Nama Bulan dalam tahun 1997.select * from Categoriesselect * from Ordersselect o.OrderDatefrom Categories cjoin Products p on c.CategoryID = p.CategoryIDjoin [Order Details] od on od.ProductID = p.ProductIDjoin Orders o on o.OrderID = od.OrderIDwhere YEAR(o.OrderDate) = 1997--Karena inflasi, harga produk perlu disesuaikan, produk yang dari UK akan naik harga 25%, produk dari USA 20%, dan dari Australia 10%, --Mohon bikin report yang ada nama company supplier, negara supplier, nama produk, dan harga yang baru, --mengecualikan produk yang sudah di discontinue, mengurutkan makai countryselect * from Productsselect * from Suppliers/*select s.CompanyName, s.Country, p.ProductName,sum(p.UnitPrice*25/100)+p.UnitPrice)from Suppliers sjoin Products p on s.SupplierID = p.SupplierID */ --video select CompanyName, Country, ProductName, NewUnitPrice from( select s.CompanyName, s.Country, p.ProductName, FORMAT(ROUND((UnitPrice * 1.25),2), 'N', 'en-US') NewUnitPrice, Discontinued from Products p join Suppliers s on s.SupplierID = p.SupplierID where s.Country = 'UK' union all select s.CompanyName, s.Country, p.ProductName, FORMAT(ROUND((UnitPrice * 1.2),2), 'N', 'en-US') NewUnitPrice, Discontinued from Products p join Suppliers s on s.SupplierID = p.SupplierID where s.Country = 'USA' union all  select s.CompanyName, s.Country, p.ProductName, FORMAT(ROUND((UnitPrice * 1.10),2), 'N', 'en-US') NewUnitPrice, Discontinued from Products p join Suppliers s on s.SupplierID = p.SupplierID where s.Country = 'Australia' ) tbl where Discontinued = 0 order by Country--Tampilkan total berapa banyak order pada setiap shipper dimulai dari tahun 1996 - 1998,-- tampilkan menjadi sebuah pivot sumbu x adalah tahun dan sumbu y adalah nama company/ID dengan ketentuan freight lebih besari dari sama dengan 25select * from Ordersselect * from Shippers;with tbl as (select count(o.OrderID) JumlahOrder, s.CompanyName ,o.Freightfrom Orders ojoin Shippers s on s.ShipperID = o.ShipViawhere year(ShippedDate) between 1996 and 1998 and o.Freight >= 25group by s.CompanyName, s.ShipperID, o.ShipVia)/*pivot(count(JumlahOrder) for CompanyName in ([Speedy Express], [United Package], [Federal Shipping])) pvt*/--videoselect *from (select s.ShipperID, s.CompanyName, o.OrderID, DATENAME(YEAR, o.ShippedDate) YearShipperfrom Orders ojoin Shippers s on o.ShipVia = s.ShipperIDwhere s.ShipperID in (1,2,3) and CAST(o.Freight as decimal) >= 15) tblPIVOT( count(orderid) for YearShipper in ([1996],[1997],[1998])) pvt--Tampilkan 5 nama supplier yang memiliki id ganjil dimana menyuplai barang yang bukan pecah belah seperti --botol, kaca, toples dengan harga diatas 10 ribu dengan format rupiah indonesia dari yang terbesarselect * from Suppliersselect * from Productsselect top 5 s.SupplierID, s.CompanyName, FORMAT(p.UnitPrice * 15000, 'C' , 'id-ID') PriceInIDRfrom Suppliers sjoin Products p on s.SupplierID = p.SupplierIDwhere s.SupplierID % 2 != 0 and p.UnitPrice >= 10 and (p.QuantityPerUnit not like '%bottles%' or p.QuantityPerUnit not like '%glass%' or p.QuantityPerUnit not like '%jars%')order by p.UnitPrice desc--Buatkan laporan pendapatan (unitOrder*UnitPrice) dengan sumbu x adalah Nama Kategori yang dijumlahkan setiap barisnya dan--sumbu y adalah nama produk beserta total setiap kategorinya.select * from [Order Details]select * from Productsselect * from Categories--videoselect ProductName,ISNULL([Condiments],0) [Condiments],ISNULL([Confections],0) [Confections],ISNULL([Dairy Products],0)[Dairy Products],ISNULL([Grains/Cereals],0)[Grains/Cereals],ISNULL([Meat/Poultry],0)[Meat/Poultry],ISNULL([Produce],0)[Produce],ISNULL([Seafood],0)[Seafood],(ISNULL([Condiments],0) +ISNULL([Confections],0) +ISNULL([Dairy Products],0)+ISNULL([Grains/Cereals],0)+ISNULL([Meat/Poultry],0)+ISNULL([Produce],0)+ISNULL([Seafood],0)) [Total X]from (select (UnitPrice * UnitsOnOrder) Pendapatan, CategoryName, ProductNamefrom Products pjoin Categories c on p.CategoryID = c.CategoryIDjoin Suppliers s on p.SupplierID = s.SupplierID) tblPIVOT(sum(Pendapatan) for CategoryName in ([Condiments], [Confections], [Dairy Products], [Grains/Cereals],[Meat/Poultry], [Produce], [Seafood])) pvt--TAMPILKAN NAMA CUSTOMER, NO TELPON DAN NEGARANYA, YANG DIMANA CUSTOMER TERSEBUT BERASAL DARI NEGARA --JERMAN, MEKSIKO DAN INGGRIS DAN TIDAK MEMPUNYAI NOMOR FAX SERTA URUTKAN CONTACT NAME BERDASARKAN ABJADselect * from Customersselect c.ContactName, c.Phone, c.Countryfrom Customers cwhere c.Country in ('Germany','Mexico', 'UK') and c.Fax is nullorder by c.ContactName/*Perusahaan ingin memberikan laptop pada masing masing karyawan, dimana laptop tersebut memiliki password sebanyak 15 digit yang dibuat dengan aturan sebagai berikut : - Digit pertama merupakan employeeID- Digit kedua & ketiga adalah tanggal lahir karyawan tersebut - Digit ke 4 - 7 adalah tahun masuk karyawan tersebut- Digit ke 8 & 9  adalah 2 digit terakhir dari HomePhone karyawan tersebut- Digit ke 10 - 14 adalah 5 digit TerritoryID asal kota karyawan tersebut- Digit ke 15 adalah RegionID asal kota karyawan tersebutTampilkan nama panjang & password untuk karyawan yang memiliki employeeID 1, 4 & 8 secara berurutan*/select * from Employeesselect * from Territoriesselect CONCAT(e.FirstName, ' ', e.LastName), (e.EmployeeID), DATENAME(DAY, BirthDate) TglLahir, DATENAME(YEAR, HireDate) TahunMasuk, SUBSTRING(HomePhone,13,2), SUBSTRING(t.TerritoryID, 3,2), (t.TerritoryID), (t.RegionID)from Employees ejoin EmployeeTerritories et on e.EmployeeID = et.EmployeeIDjoin Territories t on et.TerritoryID = t.TerritoryIDwhere e.EmployeeID = 1 or e.EmployeeID = 4 or e.EmployeeID = 8--videoselectCONCAT(e.FirstName, ' ', e.LastName) FullName,RIGHT(e.EmployeeID, 1),RIGHT(CONCAT('0', datepart(day, e.birthdate)),2),RIGHT(e.HomePhone, 2),LEFT(et.TerritoryID,5),LEFT(t.RegionID,1)from Employees ejoin EmployeeTerritories et on e.EmployeeID = et.EmployeeIDjoin Territories t on et.TerritoryID = t.TerritoryID-- 2024-01-31--suplier name,nama produk, unit price, untuk produk yang memiliki nilai unitprice paling tinggi di tiap suppliernya

select * from Products
select * from Suppliers

;with tbl as(
select s.SupplierID,s.CompanyName, p.ProductName, p.UnitPrice
from Products p
join Suppliers s on p.SupplierID = s.SupplierID
group by s.SupplierID, s.CompanyName, p.ProductName, p.UnitPrice
)
select distinct SupplierID from tbl
order by UnitPrice desc



;with tbl as (
select s.SupplierID,  MAX(p.UnitPrice) Harga
from Suppliers s
join Products p on s.SupplierID = p.SupplierID
group by s.SupplierID
)
select s.SupplierID, s.CompanyName, p.ProductName, p.UnitPrice
from tbl
join Suppliers s on s.SupplierID = tbl.SupplierID
join Products p on p.SupplierID = tbl.SupplierID
where UnitPrice = Harga
order by tbl.SupplierID




/*
setiap tabel wajib punya PK
setiap tabel hanya boleh punya 1 PK


PK Komposit terdiri dari 2 kolom PK, ada di dalam table relasi many to many

*/




use Northwind--tampilkan 3 data  supplier yang terdiri dari nama perusahaan, kota dan negara sebagai alamat lengkap perusahaan,--nama produk yang di supply, serta harga rata-rata produk di negara Norway,Denmark,Finland, dan Spain --dan diurutkan berdasarkan harga rata-rata produk yang paling tinggiselect * from Suppliersselect * from Productsselect top 3 s.CompanyName, CONCAT(s.Country,', ', s.City) AlamatPerusahaan, p.ProductName, AVG(UnitPrice) Rata2Produkfrom Suppliers sjoin products p on s.SupplierID = p.SupplierIDwhere Country in ('Norway', 'Denmark', 'Finland', 'Spain')group by s.Country, s.CompanyName, s.City, p.ProductNameorder by Rata2Produk desc--Buatlah laporan total ongkos kirim (freight) untuk masing-masing shipper company dalam satu tahun pada --tahun (1996, 1997, 1998) dengan nilai total ongkir pembulatan ke atas tanpa angka nol di belakang koma --1996, 1997, 1998 (sumbu x)--List shipper company name (sumbu y)select * from Shippersselect * from Ordersselect * from (select s.CompanyName, convert(int,CEILING(sum(o.Freight))) OngkosKirim, DATENAME(YEAR,o.ShippedDate) Tahunfrom Shippers sjoin Orders o on s.ShipperID = o.ShipViawhere DATENAME(YEAR,o.ShippedDate) between 1996 and 1998 -- and DATENAME(YEAR,o.ShippedDate) is not nullgroup by s.CompanyName, o.ShippedDate, o.Freight) tblPIVOT(sum(OngkosKirim) for Tahun in ([1996],[1997],[1998])) pvt--Seorang bos ingin mempromosikan seorang pegawai dimana pegawai tersebut sudah bekerja selama 8 tahun atau lebih dan berumur 40 tahun atau lebih dan karyawan --tersebut harus berasal kota yg terletak pada eastern atau western region juga jabatan karyawan tersebut bukan manager/vice president.--NOTE : (tampilkan nama panjangnya saja) (tahun patokan yg dipakai adalah 2000)select * from Employeesselect * from Regionselect CONCAT(e.FirstName, ' ', e.LastName) FullNamefrom Employees ejoin EmployeeTerritories et on e.EmployeeID = et.EmployeeIDjoin Territories t on t.TerritoryID = et.TerritoryIDjoin Region r on r.RegionID = t.RegionIDwhere DATEDIFF( Year, e.HireDate, '2000') >= 8 and DATEDIFF( Year, e.BirthDate, '2000') >= 40 and r.RegionDescription in ('Eastern','Western') ande.Title not like '%Manager%' and e.Title not like '%Vice President%'group by e.FirstName, e.LastName--Tampilkan nama kontak dan nomer telepon customer yang pernah membeli produk yang stoknya habis dan sudah diskontinuselect * from Customersselect * from Productsselect distinct c.ContactName, c.Phonefrom Customers cjoin Orders o on c.CustomerID = o.CustomerIDjoin [Order Details] od on o.OrderID = od.OrderIDjoin Products p on od.ProductID = p.ProductIDwhere p.UnitsInStock = 0 and p.Discontinued = 1order by c.ContactName asc--Keluarkan Contact name Customer dan full name employee yang menghandle customer tersebut dan juga berapa total order dari customer.--Employee Berasal dari Country USA, dan employee yang dikeluarkan yang sudah bekerja 5 tahun/1825 hari saat ship orderselect * from Customersselect * from Employeesselect * from Ordersselect c.ContactName, CONCAT(e.FirstName, ' ', e.LastName) FullName, COUNT(1) TotalOrderfrom Customers cjoin Orders o on c.CustomerID = o.CustomerIDjoin Employees e on o.EmployeeID = e.EmployeeIDwhere e.Country = 'USA' and DATEDIFF(YEAR, e.HireDate, o.ShippedDate) >= 5 -- or DATEDIFF(DAY, o.ShippedDate, GETDATE()) = 1825group by c.ContactName, CONCAT(e.FirstName, ' ', e.LastName)--Tuliskan query SQL untuk menemukan 1 produk yang memiliki harga rata-rata tertinggi di antara produk-produk yang memiliki stok di bawah rata-rataselect * from Ordersselect * from Productsselect p.ProductName, AVG(p.UnitPrice) Rata2Harga, AVG(p.UnitsInStock) Rata2Stokfrom Products pgroup by p.ProductNameorder by Rata2Harga desc, Rata2Stok asc;with RataHarga as (select AVG(p.UnitPrice) HargaRatafrom Products p ),RataStok as (select AVG(p.UnitsInStock) Stokfrom Products p)select top 1 p.ProductName, p.UnitPrice, p.UnitsInStockfrom RataHarga, RataStok, Products pwhere p.UnitPrice > HargaRata and p.UnitsInStock < Stokorder by HargaRata desc, Stok asc--TAMPILKAN NAMA PRODUK, NAMA KATEGORI PRODUK DARI MAKANAN YANG MEMILIKI RASA MANIS --DAN MEMILIKI HARGA DI URUTAN NO 3 DARI YANG TERTINGGIselect * from Productsselect * from Categoriesselect p.ProductName, c.CategoryNamefrom Categories cjoin Products p on c.CategoryID = p.CategoryIDwhere c.Description like '%sweet%'order by p.UnitPrice descoffset 2 rows fetch next 1 rows only/*1.Tolong Buatkan Query untuk mengambil TOP 3 data, dengan EmployeeID (2,3,5,7), pada Tahun 1998 saja. Dan yang ditampilkan adalah : - EmployeeIDnya Dengan nama [ID Karyawan]- Nama Perusahaan ShipVia Dengan nama [Nama Perusahaan]- ShipCountry- UnitPriceDiurutkan berdasarkan ShipCountry dari yang terkecil (A - Z) dan UnitPrice terbesar*/select * from Employeesselect * from Shippersselect * from Ordersselect * from Productsselect top 3 CONCAT(e.EmployeeID, ' ',e.FirstName, ' ', e.LastName) FullName, s.CompanyName, o.ShipCountry, p.UnitPricefrom Employees ejoin Orders o on e.EmployeeID = o.EmployeeIDjoin Shippers s on o.ShipVia = s.ShipperIDjoin [Order Details] od on od.OrderID = o.OrderIDjoin Products p on p.ProductID = od.ProductIDwhere e.EmployeeID in (2,3,5,7) and o.OrderDate = '1998'order by o.ShipCountry asc, p.UnitPrice desc--Keluarkan sapaan beserta nama lengkap (C1) dan umur ketika di-hire dalam tahun (C2) untuk dua orang pegawai --yang ketika di-hire berusia paling tua (R1) dan berusia paling muda (R2). Sehingga dihasilkan 2 buah kolom (C)--dan 2 buah baris (R)select * from Employees;with tbl1 as (select top 1 CONCAT(e.FirstName, ' ', e.LastName) NamaLengkap, DATEDIFF(YEAR, e.BirthDate, e.HireDate) Usiafrom Employees eorder by Usia desc),tbl2 as (select top 1 CONCAT(e.FirstName, ' ', e.LastName) NamaLengkap, DATEDIFF(YEAR, e.BirthDate, e.HireDate) Usiafrom Employees eorder by Usia asc)select * from tbl1union allselect * from tbl2--2024-02-01use Sekolah

--create alter drop
--insert update delete(Hapus spesifik) truncate(Hapus Semua)

--insert
--insert into namatable(nama kolom)
--values (....?), (....?)

insert into MataPelajaran (Nama)
values
('Bahasa Indonesia'), ('Bahasa Inggris'), ('Agama'),('Matematika'),
('Biologi'), ('Fisika'), ('Kimia')

select * from Guru

insert into Guru
(NIP, NamaLengkap,TempatLahir,TanggalLahir,JenisKelamin,TanggalMulaiBekerja, NoTelepon, Alamat, IsHonorer, Gelar
,Gaji, Tunjangan)
values
('1234567893', 'Bobi Dewa', 'Semarang', '1990-04-18',
'L','2024-02-01', '08582733827', 'Jl. Maju Maundur Oke', 1, 'S.Pd',
6500000, 500000),
('1234567891', 'Caca', 'Bandung', '1980-01-20',
'P','2005-11-12', '085578712381', 'Jl. Maju Terus', 1, 'S.Pd',
6500000, 500000)

Select * from Guru
select * from MataPelajaran

--truncate table MataPelajaran

--update
--gunakan where untuk lebih spesifik

update Guru
set Gelar = 'S.Pd',
	NamaLengkap = 'Joko Priyatno'
where NIP = '1234567892'

update guru 
set NoTelepon = '085827338274'
where NIP = '1234567893'

--delete
delete from Guru

--truncate
--tidak bisa apabila ada relasi(FK)
truncate table matapelajaran

--memulai delete dan reset memulai dari 1
DBCC CHECKIDENT ('MataPelajaran', RESEED, 0)







--create alter drop
use master
drop database Sekolah

--create database
create database Sekolah
go
use Sekolah

--guru & MataPelajaran
drop table MataPelajaran
create table MataPelajaran(
--coloum
Id int identity(1,1),
Nama varchar(100),
Constraint PK_Sekolah_Id Primary Key (Id)
)

/*
create table Guru(
NIP varchar(10) NOT NULL,
NamaLengkap varchar(100) NOT NULL,
TempatLahir varchar(50) NOT NULL,
TanggalLahir datetime NOT NULL,
JenisKelamin char(1) NOT NULL,
TanggalMulaiBekerja datetime NOT NULL,
NoTelepon varchar(13),
Alamat varchar(500) NOT NULL,
IsHonorer bit NOT NULL,
Gelar varchar(30) CONSTRAINT DF_Gelar DEFAULT 'S.Pd',
Gaji money NOT NULL,
Tunjangan money NOT NULL

CONSTRAINT PK_GURU_NIP PRIMARY KEY (NIP),
CONSTRAINT UQ_NoTelepon UNIQUE (NoTelepon)
)
*/

/*
--PK hanya 1 dalam 1 tabel
create table dbo.Kopetensi(
NIP varchar(10),
IdMataPelajaran int
--PK Komposit
CONSTRAINT PK_Kopetensi PRIMARY KEY (NIP,IdMataPelajaran)
)
*/

alter table dbo.Kopetensi
add
constraint FK_Guru_Nip Foreign Key (Nip) References dbo.Guru(NIP)

alter table dbo.Kopetensi
add
constraint FK_MataPelajaran_Id Foreign Key (IdMataPelajaran) References dbo.MataPelajaran(Id)



select * from Guru
Select * from MataPelajaran
Select * from Kopetensi


--menambah kolom tabel
alter table Kopetensi
add DeleteDate datetime null


--mengubah kolom
alter table Kopetensi
alter column DeleteDate datetime not null

--menghapus kolom
alter table kopetensi
drop column DeleteDate

--rename kolom
--ALTER TABLE tableName RENAME COLUMN oldcolname TO newcolname datatype(length);


insert into Kopetensi 
(NIP,IdMataPelajaran)
values (1234567891, 2), (1234567892, 7)

--insert into select
--bisa memasukkan dari database lain
-- from Univ.dbo.Dosen (Contoh)

--select into from
--bisa buat tabel baru, tidak termasuk primary key. Apabila Tabel belum  ada bisa menggunakan ini.
-- into Dosen(Contoh)

--select harus disamakan dengan tabel yang akan di insert/dimasukkan/dituju





-- temporary table
--tabel sementara
--# satu local (Satu lembar Kerja)
-- ## global (Bisa di lembar kerja lain)

select NIP, NamaLengkap, Gaji, Tunjangan
into #tempDataGuru
from Guru

select * from #tempDataGuru

drop table #tempDataGuru





-- OUTPUT : INSERT UPDATE DELETE, INSERTED DELETED

-- INSERTED : VALUE TERBARU

INSERT INTO MataPelajaran(Nama)
OUTPUT inserted.Id,inserted.Nama
values('Seni Budaya')

update MataPelajaran
set Nama = 'Komputer'
output deleted.Nama, inserted.Nama
where Id = 1



delete from MataPelajaran
output deleted.Id, deleted.Nama
where Id = 1





-- 2024-02-02

--EXCERCISE 2

use Northwind

--7) HRD ingin tahu jumlah karyawan di setiap region. Kalian diminta untuk menghitung jumlah karyawan 
--di setiap region di East, Northern, Western dan Southern. Tunjukan lah total jumlah employee di setiap Region Description. 
--Di urutkan dari Total Employee terbanyak ke yang paling sedikit, apabila ada yang jumlahnya sama, maka urutkan dari Region description secara ascending.


select * from Employees
select* from EmployeeTerritories
select * from Territories
select * from Region

select r.RegionDescription, count(t.RegionID) JumlahKaryawan
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
where r.RegionDescription in ('Eastern', 'Northern', 'Western', 'Southern')
group by r.RegionDescription
order by JumlahKaryawan desc, r.RegionDescription asc 





--8)Buatlah sebuah buku telpon untuk seluruh entitas di dalam database, termasuk Customers, Employees dan Supplier. 
--Buku telpon terdiri dari 3 column, yaitu Full Name atau nama lengkap setiap entitas, dan nomor phone setiap entitas, 
--dan column yang menentukan jenis entitas, apakah customer, employee atau supplier. List phone book ini di urutkan secara descending z-a 
--berdasarkan nama dari entitas

select * from Customers
select * from Employees
select * from Suppliers

select * from (
select c.ContactName, c.Phone, ('Customers')Jenis
from Customers c
union
select CONCAT( e.FirstName,' ', e.LastName), e.HomePhone, ('Employee')Jenis
from Employees e
union 
select s.ContactName,s.Phone, ('Suppliers')Jenis
from Suppliers s
) tbl
order by ContactName desc




--﻿9) Diadakan ngobrol dan meeting empat mata dari 1 orang pihak supplier dan 1 orang karyawan pihak internal untuk membahas feedback dari seorang supplier, 
--mengenai sistem distribusi baru dari perusahaan. Yang jadi masalah adalah saat ini adalah liburan Natal, semua employee sudah berlibur 
--dan pulang kembali ke negara masing-masing. Yang ingin management lakukan adalah menelfon salah satu available employee yang saat ini 
--sedang di negaranya dan menelfon salah satu available supplier yang dimana berada di lokasi negara yang sama dengan yang employee saat ini 
--sedang menetap. Management ingin menelfon untuk kesediaan mereka bertemu dan membicarakan sistem baru yang saat ini sedang di level prototype, 
--karena ini urgent jadi harus secepat mungkin dilakukan. Buatkan lah list kombinasi dari supplier dan employee, dimana mereka sedang berada di lokasi 
--yang sama saat ini.List tersebut harus memiliki informasi: Negara mereka sedang berada, nama supplier, nama employee dan nomor phone keduanya.

select * from Suppliers
select * from Employees

select e.Country, CONCAT( e.FirstName,' ', e.LastName) NamaEmployee, e.HomePhone, (s.ContactName) NamaSupplier, s.Phone
from Employees e
cross join Suppliers s
where e.Country in ('USA','UK')
order by e.Country 





--﻿10) Management ingin melihat Jumlah employee berdasarkan Job Title (Jabatan/Pekerjaan dan Pangkat) 
--di setiap Region (Northern, Eastern, Southern, Western). Buatlah sebuah table dengan format di bawah ini
--,dimana setiap table cell berisi informasi total employeenya.Job TitleJabatan 1...Jabatan 2...Jabatan 3...NorthernEasternUrutkan berdasarkan alphabet job titlenya dari A-Z

select * from Employees
select * from Region

select * from (
select e.Title, r.RegionDescription, e.EmployeeID
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
) tbl
PIVOT(count(EmployeeID) for RegionDescription in ([Northern],[Eastern], [Southern], [Western])
) pvt



-- 2024-02-02
--EXCERCISE 3

use Northwind

--﻿11) Management memiliki beberapa vault atau penyimpanan dengan security brankas, 
--untuk barang- barang dengan total asset paling mahal. Beberapa total asset terbesar direncanakan untuk di simpan dalam vault. 
--Urutkan dari total asset termahal sampai yang termurah. Tapi pastikan kalau semua aset yang di laporkan harus yang masih diproduksi, 
--bukan yang sudah discontinue.

select * from Products

select p.ProductName
from Products p
where p.Discontinued = 0
order by UnitPrice desc




--12) Tampilkan seluruh nama lengkap pekerja, beserta umurnya sampai saat ini. 
--Urutkan para pekerja dari yang tertua sampai yang paling muda.

select * from Employees

select CONCAT(FirstName, ' ', LastName) NamaLengkap, DATEDIFF(YEAR, BirthDate, GETDATE()) Usia
from Employees
order by Usia desc





--﻿14) Management ingin melihat total variasi product di dalam setiap invoice pembelian. 
--List informasi setiap pembelian Order ID, Order Date (format: 01 Januari 2021) dan Total Jenis Productnya.Urutkan berdasarkan
--tanggal ordernya dari yang paling lama ke yang paling baru.

select * from Products
select * from [Order Details]
select * from Orders

select o.OrderID, CONCAT( DATENAME(DAY, o.OrderDate),' ', DATENAME(MONTH, o.OrderDate), ' ', DATENAME(YEAR,o.OrderDate)) Tanggal, COUNT(p.ProductID) JenisProduk
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
group by o.OrderID, o.OrderDate
order by Tanggal desc




-- 2024-02-02

use Sekolah

/*
declare @dafarguru table = (
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru
)
*/

--select @daftarguru

--membuat variable tabel baru, lawan dari temp table
--semua ada plus minusnya
create type HonorGuru as table (
NIP varchar(10),
NamaLengkap varchar(100),
IsHonorer bit,
Gaji money,
Tunjangan money
)

declare @daftarGuru as HonorGuru

/*
declare @daftarGuru as HonorGuru = (
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru
)
*/
insert into @daftarGuru
values ('432912', 'Alvenio Farhan', 1, 5000000, 0)


insert into @daftarGuru
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru

select * from @daftarGuru






--PIVOT DINAMIS

declare @queryString varchar(max);
declare @columnPivot varchar(max);

select @columnPivot = CONCAT(@columnPivot, '[', CategoryName, '], ')
from Northwind.dbo.Categories
where CategoryID % 2 = 0

--Bisa Juga memakai
--select @columnPivot = CONCAT(@columnPivot, QUOTENAME(CategoryName), ', ')
--from Northwind.dbo.Categories
--where CategoryID % 2 = 0

set @queryString='
select * from (
select s.CompanyName as SupplierName,
c.CategoryName, p.ProductID
from Northwind.dbo.Products p
join Northwind.dbo.Suppliers s on p.SupplierID=s.SupplierID
join Northwind.dbo.Categories c on p.CategoryID=c.CategoryID
)tbl
pivot(count(tbl.ProductID) for CategoryName in (' + LEFT(@ColumnPivot, LEN(@columnpivot)-1) +'))pvt
'
--execute/exec
exec (@queryString)

--end

--select * from (
--select s.CompanyName as SupplierName,
--c.CategoryName, p.ProductID
--from Northwind.dbo.Products p
--join Northwind.dbo.Suppliers s on p.SupplierID=s.SupplierID
--join Northwind.dbo.Categories c on p.CategoryID=c.CategoryID
--)tbl
--pivot(count(tbl.ProductID) for CategoryName in (' + LEFT(@ColumnPivot, LEN(@columnpivot)-1)+'))pvt





-- 2024-02-05
--UJIAN 1



--membuat database
create database MarketPlace

--menjalankan database
go
use MarketPlace

-- Tabel untuk Akun
CREATE TABLE Akun (
    AkunID varchar(10) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    Pass VARCHAR(50) NOT NULL,
    TglRegister DATETIME NOT NULL,
    RoleAkun VARCHAR(50) NOT NULL

	CONSTRAINT PK_Akun_AkunID PRIMARY KEY (AkunID),
	CONSTRAINT UQ_AkunID UNIQUE (AkunID)
);


-- Tabel untuk Admin
CREATE TABLE Admin (
    AdminID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL

	CONSTRAINT PK_Admin_AdminID PRIMARY KEY (AdminID),
	CONSTRAINT UQ_AdminID UNIQUE (AdminID),
	constraint FK_Admin_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Kota
CREATE TABLE Kota (
    KotaID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	NamaKota VARCHAR(50) NOT NULL

	CONSTRAINT PK_Kota_KotaID PRIMARY KEY (KotaID),
	CONSTRAINT UQ_KotaID UNIQUE (KotaID),
	constraint FK_Kota_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Pembeli
CREATE TABLE Pembeli (
    PembeliID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL,
	TanggalLahir date not null,
	TempatLahir varchar(50),
	JenisKelamin Varchar(10)

	CONSTRAINT PK_Pembeli_PembeliID PRIMARY KEY (PembeliID),
	CONSTRAINT UQ_PembeliID UNIQUE (PembeliID),
	constraint FK_Pembeli_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_Pembeli_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Penjual
CREATE TABLE Penjual (
    PenjualID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaDepan VARCHAR(50) NOT NULL,
    NamaBelakang VARCHAR(50) NOT NULL,
	TanggalLahir date not null,
	TempatLahir varchar(50),
	JenisKelamin Varchar(10),
	Alamat Varchar(100)

	CONSTRAINT PK_Penjual_PenjualID PRIMARY KEY (PenjualID),
	CONSTRAINT UQ_PenjualID UNIQUE (PenjualID),
	constraint FK_Penjual_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_Penjual_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk AlamatPembeli
CREATE TABLE AlamatPembeli (
    AlamatPembeliID varchar(10) NOT NULL,
    AkunID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	AlamatDetail VARCHAR(100) NOT NULL
    
	CONSTRAINT PK_AlamatPembeli_AlamatPembeliID PRIMARY KEY (AlamatPembeliID),
	CONSTRAINT UQ_AlamatPembeliID UNIQUE (AlamatPembeliID),
	constraint FK_AlamatPembeli_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID),
	constraint FK_AlamatPembeli_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Toko
CREATE TABLE Toko (
    TokoID varchar(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaToko VARCHAR(50) NOT NULL,
	AlamatToko Varchar(100) Not null
    
	CONSTRAINT PK_Toko_TokoID PRIMARY KEY (TokoID),
	CONSTRAINT UQ_TokoID UNIQUE (TokoID),
	constraint FK_Toko_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk Ekspedisi
CREATE TABLE Ekspedisi (
    EkspedisiID varchar(10) NOT NULL,
	AdminID VARCHAR(10) NOT NULL,
	KotaID VARCHAR(10) NOT NULL,
	NamaEkspedisi VARCHAR(50) NOT NULL,
	OngkirPerKm int Not null
    
	CONSTRAINT PK_Ekspedisi_EkspedisiID PRIMARY KEY (EkspedisiID),
	CONSTRAINT UQ_EkspedisiID UNIQUE (EkspedisiID),
	constraint FK_Ekspedisi_AdminID Foreign Key (AdminID) References dbo.Admin(AdminID),
	constraint FK_Ekspedisi_KotaID Foreign Key (KotaID) References dbo.Kota(KotaID)
);


-- Tabel untuk ProdukKategori
CREATE TABLE Kategori (
    KategoriID varchar(10) NOT NULL,
	AdminID VARCHAR(10) NOT NULL,
	NamaKategori VARCHAR(50) NOT NULL
    
	CONSTRAINT PK_Kategori_KategoriID PRIMARY KEY (KategoriID),
	CONSTRAINT UQ_KategoriID UNIQUE (KategoriID),
	constraint FK_Kategori_AdminID Foreign Key (AdminID) References dbo.Admin(AdminID)
);


-- Tabel untuk Wallet
CREATE TABLE Wallet (
    WalletID varchar(10) NOT NULL,
	AkunID VARCHAR(10) NOT NULL,
	Nominal int NOT NULL
    
	CONSTRAINT PK_Wallet_WalletID PRIMARY KEY (WalletID),
	CONSTRAINT UQ_WalletID UNIQUE (WalletID),
	constraint FK_Wallet_AkunID Foreign Key (AkunID) References dbo.Akun(AkunID)
);


-- Tabel untuk Produk
CREATE TABLE Produk (
    ProdukID varchar(10) NOT NULL,
	KategoriID VARCHAR(10) NOT NULL,
	TokoID VARCHAR(10) NOT NULL,
	NamaProduk Varchar(100),
	Harga int not null,
	Deskripsi varchar(100),
	Stok int,
	TglMulaiJual datetime
    
	CONSTRAINT PK_Produk_ProdukID PRIMARY KEY (ProdukID),
	CONSTRAINT UQ_ProdukID UNIQUE (ProdukID),
	constraint FK_Produk_KategoriID Foreign Key (KategoriID) References dbo.Kategori(KategoriID),
	constraint FK_Produk_TokoID Foreign Key (TokoID) References dbo.Toko(TokoID)
);
ALTER TABLE Produk
ADD MinQuantity int not null;


-- Tabel untuk Diskusi
CREATE TABLE Diskusi (
    DiskusiID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Question varchar(200)
    
	CONSTRAINT PK_Diskusi_DiskusiID PRIMARY KEY (DiskusiID),
	CONSTRAINT UQ_DiskusiID UNIQUE (DiskusiID),
	constraint FK_Diskusi_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Diskusi_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);


-- Tabel untuk Review
CREATE TABLE Review (
    ReviewID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Rating Varchar(5),
	Question varchar(200)
    
	CONSTRAINT PK_Review_ReviewID PRIMARY KEY (ReviewID),
	CONSTRAINT UQ_ReviewID UNIQUE (ReviewID),
	constraint FK_Review_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Review_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);



-- Tabel untuk Cart
CREATE TABLE Cart (
    CartID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	Quantity int not null
    
	CONSTRAINT PK_Cart_CartID PRIMARY KEY (CartID),
	CONSTRAINT UQ_CartID UNIQUE (CartID),
	constraint FK_Cart_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Cart_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);


-- Tabel untuk Transaksi
CREATE TABLE Transaksi (
    TransaksiID varchar(10) NOT NULL,
	PembeliID VARCHAR(10) NOT NULL,
	PenjualID VARCHAR(10) NOT NULL,
	EkspedisiID VARCHAR(10) NOT NULL,
	TotalTransaksi int,
	TanggalTransaksi datetime
    
	CONSTRAINT PK_Transaksi_TransaksiID PRIMARY KEY (TransaksiID),
	CONSTRAINT UQ_TransaksiID UNIQUE (TransaksiID),
	constraint FK_Transaksi_PembeliID Foreign Key (PembeliID) References dbo.Pembeli(PembeliID),
	constraint FK_Transaksi_PenjualID Foreign Key (PenjualID) References dbo.Penjual(PenjualID),
	constraint FK_Transaksi_EkspedisiID Foreign Key (EkspedisiID) References dbo.Ekspedisi(EkspedisiID)
);


-- Tabel untuk Pembayaran
CREATE TABLE Pembayaran (
    PembayaranID varchar(10) NOT NULL,
	TransaksiID VARCHAR(10) NOT NULL,
	WalletID VARCHAR(10) NOT NULL,
	Jumlah int not null,
	TanggalPembayaran datetime
    
	CONSTRAINT PK_Pembayaran_PembayaranID PRIMARY KEY (PembayaranID),
	CONSTRAINT UQ_PembayaranID UNIQUE (PembayaranID),
	constraint FK_Pembayaran_TransaksiID Foreign Key (TransaksiID) References dbo.Transaksi(TransaksiID),
	constraint FK_Pembayaran_WalletID Foreign Key (WalletID) References dbo.Wallet(WalletID)
);


-- Tabel untuk TransaksiDetail
CREATE TABLE TransaksiDetail (
    TransaksiDetailID varchar(10) NOT NULL,
	TransaksiID VARCHAR(10) NOT NULL,
	ProdukID VARCHAR(10) NOT NULL,
	QuantityTransaksi int not null,
	SubTotalTransaksi int
    
	CONSTRAINT PK_TransaksiDetail_TransaksiDetailID PRIMARY KEY (TransaksiDetailID),
	CONSTRAINT UQ_TransaksiDetailID UNIQUE (TransaksiDetailID),
	constraint FK_TransaksiDetail_TransaksiID Foreign Key (TransaksiID) References dbo.Transaksi(TransaksiID),
	constraint FK_TransaksiDetail_ProdukID Foreign Key (ProdukID) References dbo.Produk(ProdukID)
);




--Data Untuk Tabel Akun
insert into Akun
values ('1','admin1','admin1','2024-02-05','Admin'),
('2','admin2','admin2','2024-02-05','Admin'),
('3','pembeli1','pembeli1','2024-02-05','Pembeli'),
('4','pembeli2','pembeli2','2024-02-05','Pembeli'),
('5','penjual1','penjual1','2024-02-05','Penjual'),
('6','penjual2','penjual2','2024-02-05','Penjual')
;
select *
from Akun

--Data Untuk Tabel Admin
insert into Admin
values ('1','1','Alvenio','Farhan'),
('2','2','Budi','Pekerti');
select *
from Admin


--Data Untuk Tabel Admin
insert into Kota
values('1','1','Semarang'),
('2','2','Jakarta'),
('3','3','Bandung'),
('4','4','Semarang'),
('5','5','Jakarta'),
('6','6','Bandung')
;
select * from Kota



--Data Untuk Tabel Pembeli
insert into Pembeli
values('1','3','3','Alisa','Magda','1980-02-05','Bandung','Wanita'),
('2','4','4','Gundahar','Aziz','1995-11-28','Semarang','Pria')
;
select * from Kota
select * from Pembeli
update Pembeli
set TempatLahir = 'Semarang'
where PembeliID = 2


--Data Untuk Tabel Penjual
insert into Penjual
values ('1','5','5','Jia','Alfred','1995-01-30','Jakarta','Wanita','Jalan Terus'),
('2','6','6','Sandhya','Justinas','1989-08-18','Bandung','Pria','Jalan Maju')
;
select * from Penjual



--Data Untuk Tabel AlamatPembeli
insert into AlamatPembeli
values ('1','3','3','Jalan Bandung Tengah'),
('2','4','4','Jalan Semarang Selatan')
;
select * from AlamatPembeli


--Data Untuk Tabel Toko
insert into Toko
values ('1','5','Berkah Jaya','Jalan Jakarta Utara'),
('2','6','Maju Jaya','Jalan Bandung Barat')
;
select * from Toko


--Data Untuk Tabel Ekspedisi
insert into Ekspedisi
values ('1','1','1','TIKI','500'),
('2','2','2','JNE','700')
;
select * from Ekspedisi


--Data Untuk Tabel Ekspedisi
insert into Kategori
values ('1','1','Pakaian'),
('2','2','Makanan')
;
select * from Kategori

--Data Untuk Tabel Wallet
insert into Wallet
values ('1','3','50000'),
('2','4','100000'),
('3','5','20000'),
('4','6','150000')
;
select * from Wallet

----Data Untuk Tabel Produk
insert into Produk
values ('1','1','1','Baju Anak','30000','Baju Anak Lucu','5','2022-05-05','1'),
('2','2','2','Cireng','10000','Cireng Enak','10','2024-02-05','1')
;
select * from Produk
select * from Kategori
select * from Toko

--Data Untuk Tabel Diskusi
insert into Diskusi
values ('1','1','1','Adakah Baju Ukuran S?'),
('2','2','2','Ada varian rasa apa saja?')
;
select * from Diskusi


--Data Untuk Tabel Review
insert into Review
values ('1','1','1','4','Packing kurang rapi'),
('2','2','2','2','Rasanya aneh')
;
select * from Review


--Data Untuk Tabel Cart
insert into Cart
values ('1','1','1','2'),
('2','2','2','1')
;
select * from Cart


--Data Untuk Tabel Transaksi
insert into Transaksi
values('1','1','1','1','60000','2024-02-05'),
('2','2','2','1','10000','2024-02-04')
;
select * from Transaksi
select * from Penjual
select * from Ekspedisi
select * from Produk


--Data Untuk Tabel TransaksiDetail
insert into transaksidetail
values ('1','1','1','2','60000'),
('2','2','2','1','10000')
;
select * from transaksidetail
select * from Transaksi


--Data Untuk Tabel Pembayaran
insert into Pembayaran 
values ('1', '1', '1' ,'80000' ,'2024-02-05'),
('2', '2', '2' ,'31000' ,'2024-02-04')
;
select * from pembayaran 
select * from Ekspedisi
select * from Wallet
select * from transaksidetail
select * from Transaksi

select * from Cart
select * from Produk


