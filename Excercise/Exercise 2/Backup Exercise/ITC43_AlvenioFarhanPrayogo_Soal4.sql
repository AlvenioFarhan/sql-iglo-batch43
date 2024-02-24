--4. Discontinue order.sql
--Hitung ada berapa banyak jumlah order di dalam seluruh sejarah penjualan northwind dari awal sampai 
--akhir, yang pernah menjual product yang saat ini sudah discontinue. Hasil yang diharapkan bukan 
--berupa laporan, melainkan hanya satu angka (scalar) dalam bilangan bulat berupa jumlah ordernya

select * from Orders
select * from Products

select count(o.OrderID)JumlahTotalOrder
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Products p on p.ProductID = od.ProductID
where p.Discontinued = 1