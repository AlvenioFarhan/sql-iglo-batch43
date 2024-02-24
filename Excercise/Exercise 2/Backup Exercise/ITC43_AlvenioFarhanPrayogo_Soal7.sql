--7. Federal Shipping order.sql
--Ingin diketahui berapa jumlah uang yang di hasilkan (omset/omzet) oleh setiap order yang mengirim 
--lewat perusahaan Federal Shipping. Laporan yang diminta adalah Order Id dan jumlah uang yang 
--dihasilkan oleh setiap order Id tersebut. (Note: jangan lupa menambahkan satu ongkos kirim (Freight) di 
--setiap order. Hati-hati, harga product saat penjualan berbeda dengan harga product saat ini)
--(Note: tidak memperdulikan discount)

select * from Shippers
select * from Orders
select * from [Order Details]

select o.OrderID, sum((od.UnitPrice * Quantity) + o.Freight)JumlahUangOrder
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
join [Order Details] od on o.OrderID = od.OrderID
where s.CompanyName = 'Federal shipping'
group by o.OrderID