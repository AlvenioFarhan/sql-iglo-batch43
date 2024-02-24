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



--Tampilkan 3 data berupa nama lengkap pegawai beserta title of courtesynya yang berusia lebih dari 20 tahun sejak hari ini
LOWER(SUBSTRING(emp.LastName, 2, LEN(emp.LastName))), ', ',
UPPER(SUBSTRING(emp.FirstName, 1, 1)),
LOWER(SUBSTRING(emp.FirstName, 2, LEN(emp.FirstName)))
) FormatName
in ([])
) as pvt


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


--Manajemen ingin tahu produk yang terjual dengan harga diatas 50 di bulan januari tahun 1997 yang mendapatkan diskon. 
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





--Pada awal tahun 1999 Manejer pemasaran membutuhkan sebuah laporan  pendapatan penjualan  