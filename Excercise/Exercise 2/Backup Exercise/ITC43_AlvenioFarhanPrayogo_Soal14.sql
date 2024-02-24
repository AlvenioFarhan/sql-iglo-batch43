--14. Total Order Discount.slq
--Ingin diketahui berapa besar total potongan harga (discount) yang diberikan northwind untuk setiap 
--order yang pernah ada. Informasi yang diminta adalah order id, total potongan harga pada order ini.

select * from Orders
select * from [Order Details]

select od.OrderID, sum(od.UnitPrice * od.Discount)TotalPotonganHarga
from [Order Details] od
group by od.OrderID