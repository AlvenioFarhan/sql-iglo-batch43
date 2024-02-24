--8. Different price.sql
--Ingin diketahui perbedaan harga dari harga katalog product dengan harga di saat order barang tersebut. 
--Keluarkan informasi berupa order id, nama product yang ada pada detail order ini, harga product pada 
--saat penjualan, harga product asli, dan selisih harga product saat penjualan dan harga product saat ini. 
--(penurunan harga ditandai dengan nominal minus -)
--(Note: tidak memperdulikan discount)

select * from Products
select * from [Order Details]
select * from Orders

select o.OrderID, p.ProductName, od.UnitPrice, p.UnitPrice, (od.UnitPrice - p.UnitPrice)Selisih
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID