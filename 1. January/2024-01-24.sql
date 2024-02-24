use Northwind;
--select CategoryID , CategoryName, Description
--from Categories
--where CategoryID >= 4 and CategoryID <=8;

/*
5 select [kolom]
1 from [table name]
1 join [table name]
2 where [kondisi]
3 group by [kolom]
4 having [kolom] ketika ada aggregate function sql
6 order by [kolom]

Penghubung 2 kondisi:
OR
AND

tidak sama dengan
!=
<>

3 value :
1. scalar = 1 data
select 'Alvenio'

2. list value = 1 list/lebih dari 1 scalar

3. tabel value = banyak data/list



*/


select CustomerID, CompanyName, Country
from Customers
where Country in ('Germany', 'Mexico', 'Argentina');

--Distinct untuk menghilangkan data yang double/sama
--Count untuk menghitung banyaknya Jumlah pada Category ID
select distinct COUNT (CategoryID)
from Categories;


select * from Products --where CategoryID = 1

--Count untuk mengetahui hasil jumlah pada product ID
select CategoryID, count(ProductID) TotalProduct
from Products
group by CategoryID

-- sum untuk melakukan penjumlahan 
select CategoryID, sum(UnitsOnOrder) TotalProduct
from Products
group by CategoryID

--AVG/Average untuk melakukan rata"
select CategoryID, AVG(UnitPrice) TotalHarga
from Products
group by CategoryID

--Max mengambil data harga tertinggi
select CategoryID, max(UnitPrice) TotalHarga
from Products
group by CategoryID

--Min mengambil data harga terendah
select CategoryID, min(UnitPrice) 'Total Harga'
from Products
group by CategoryID

--HAVING pada SQL memiliki fungsi yang sama seperti WHERE, namun digunakan untuk menerapkan kondisi pada agregate function
select CategoryID, min(UnitPrice) MinUnitPrice
from Products
group by CategoryID
having min(UnitPrice) >= 10

select COUNT(CategoryID)
from Products

select *
from Products

select CategoryID, COUNT(distinct UnitPrice) TotalJenisPrice
from Products
group by CategoryID;

select *
from Products
order by ProductName asc;

select *
from Products
order by ProductName desc;

select *
from Products
order by CategoryID asc, ProductName desc;

--count(1) untuk memanipulasi tabel baru
select CategoryID, COUNT(1) TotalProduct
from Products
group by CategoryID
order by TotalProduct

