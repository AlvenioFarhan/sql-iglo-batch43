--suplier name,nama produk, unit price, untuk produk yang memiliki nilai unitprice paling tinggi di tiap suppliernya

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