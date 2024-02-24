--5. Total Omzet Product.sql
--Diinginkan informasi mengenai product berupa, nama product, nama kota dari mana product ini di 
--supply, dan jumlah total uang yang pernah dihasilkan northwind dari hasil penjualan product ini.
--(Note: ini bukan profitnya, karena tidak ada harga jual dan harga beli sehingga mustahil menghitung 
--profit. Ini lebih seperti omset/omzet, yaitu total penjualan nya sendiri).
--Hati-hati, karena harga product di katalog berbeda dengan harga pada saat penjualan.
--(Note: tidak memperdulikan discount

select * from  Products
select * from Suppliers
select * from [Order Details]

select p.ProductName, s.City, sum(od.Quantity * od.UnitPrice)TotalOmset
from Products p
join Suppliers s on p.SupplierID = s.SupplierID
join [Order Details] od on p.ProductID = od.ProductID
group by p.ProductName, s.City
order by p.ProductName