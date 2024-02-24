--9. Customer loyalty.sql
--Ingin diketahui nama perusahaan customer yang selama tahun 1997 berbelanja paling banyak di 
--northwind. Keluarkan informasi berupa, nama perusahaan customer, jumlah total belanja (tidak 
--termasuk ongkos kirimnya). Urutkan data dari customer yang berbelanja paling banyak ke yang paling 
--sedikit. (Note: tidak memperdulikan discount)select * from Customersselect * from Ordersselect * from [Order Details]select c.CompanyName, sum(od.UnitPrice * od.Quantity)TotalBelanjafrom Customers cjoin Orders o on c.CustomerID = o.CustomerIDjoin [Order Details] od on o.OrderID = od.OrderIDwhere DATENAME(YEAR, o.OrderDate) = 1997group by c.CompanyNameorder by TotalBelanja desc