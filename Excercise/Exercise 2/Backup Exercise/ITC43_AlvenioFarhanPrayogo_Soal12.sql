--12. Supplier speciality.sql
--Ingin diketahui berapa banyak jumlah category barang yang dihasilkan oleh setiap perusahaan supplier.
--Informasi yang harus dikeluarkan adalah, nama perusahaan supplier, negara asal supplier dan jumlah 
--category product yang dijual.

select * from Categories
select * from Suppliers
select * from Products

select s.CompanyName, s.Country, count(c.CategoryID)JumlahCategoryProdukTerjual
from Suppliers s
join Products p on s.SupplierID = p.SupplierID
join Categories c on p.CategoryID = c.CategoryID
where p.Discontinued = 0 
group by s.CompanyName, s.Country
order by s.CompanyName