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


