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





