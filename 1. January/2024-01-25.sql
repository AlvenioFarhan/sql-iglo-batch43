use Northwind;

select *
from Products;

select *
from Suppliers;

select ProductID, ProductName, SupplierID
from Products
where SupplierID is null
order by ProductID

--ASC/Asending untuk mengurutkan data sesuai abjad A-Z atau 1- 10(Data terkecil ke besar),dst
select top 10 * from Customers
order by city asc

--DESC/Desending untuk mengurutkan data kebalikan abjad Z-A atau 10-1(Data terbesar ke kecil),dst
select top 10 * from Customers
order by city desc

--OFFSET untuk menampilkan data dan Memulainya dari nomor data yang kita inginkan
--FETCH NEXT untuk memaksimalkan tampilan data yang kita inginkan
select * from Customers
order by city desc
offset 10 rows
fetch next 3 rows only

--TOP Untuk menampikkan data teratas
select top 3 * from Products
order by UnitPrice desc

--Dibawah adalah menggunakan Subquery
select SupplierID, CompanyName from Suppliers
where SupplierID in (select top 3 SupplierID from Products
order by UnitPrice desc)

select count(CategoryID) from Products
group by CategoryID

select CategoryID, count(1) TotalProduct
from Products
group by CategoryID

select * from (
select CategoryID, count(1) TotalProduct
from Products
group by CategoryID ) as tblBaru
where TotalProduct > 10

select *, (select max(UnitPrice) from Products) as tblBaru
from Suppliers

/*
--JOIN
inner join / join on
right join, on
left join, on
full join, on
cross join
self join
*/

--INNER JOIN
--JOIN adalah perintah dalam SQL yang berfungsi untuk menggabungkan informasi dari dua tabe

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
join Categories cat on prod.CategoryID = cat.CategoryID


--LEFT JOIN
--LEFT JOIN adalah fungsi yang digunakan untuk menggabungkan dan menampilkan seluruh data pada tabel kiri dan tabel kanan yang memenuhi kondisi JOIN

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
left join Categories cat on prod.CategoryID = cat.CategoryID

--RIGHT JOIN
--Menampilkan Semua Data Tabel Kanan: Dengan perintah RIGHT JOIN, Anda dapat menampilkan semua data dari tabel kanan (tabel kedua dalam pernyataan JOIN)

select prod.ProductID, prod.ProductName, cat.CategoryName
from Products prod
right join Categories cat on prod.CategoryID = cat.CategoryID

select *
from Products

select *
from Suppliers

select prod.ProductName, prod.UnitsInStock, sup.CompanyName
from Products prod
left join Suppliers sup on prod.SupplierID = sup.SupplierID
where UnitsInStock = 0;


--CROSS JOIN
--=adalah salah satu jenis join dalam SQL yang digunakan untuk menggabungkan setiap baris dari satu tabel dengan setiap baris dari tabel lainnya.
select emp.EmployeeID, cat.CategoryID 
from Employees emp
cross join Categories cat


--SELF JOIN
--adalah operasi penggabungan tabel dengan dirinya sendiri.
select prod.ProductName, *
from Products prod, Categories cat
where prod.CategoryID = cat.CategoryID



--jumlah total employee, jumlah total customer, jumlah total supplier

select count(emp.EmployeeID) JumlahEmp 
from Employees emp

select count(cus.CustomerID)
from Customers cus

select count(sup.SupplierID)
from Suppliers sup

--cara pertama
select count(distinct EmployeeID), count(distinct SupplierID), count(distinct CustomerID)
from Employees, Suppliers, Customers


--cara kedua

select emp.totalEmployee, cust.totalCustomer, sup.totalSupplier
from (
select 'A' PK, count(1) totalEmployee from Employees) emp
join (
select 'A' PK, count(1) totalCustomer from Customers)
cust on emp.PK = cust.PK
join (
select 'A' PK, count(1) totalSupplier from Suppliers)
sup on sup.PK = cust.PK


--Union
--menampilkan data dengan tabel yang berbeda(WAJIB sama untuk value nya!!)

/*
UNION menggabungkan dua atau lebih pernyataan SELECT dan menghapus rekaman duplikat, 
sedangkan UNION ALL menggabungkan hasil tanpa menghilangkan duplikat.
*/
select CompanyName as Name
from Customers cust
union
select CompanyName as Name
from Suppliers sup

--INTERSECT, yang ada di dalam kedua kolom, seperti inner join
select Country from Customers
intersect
select Country from Suppliers

--EXCEPT, yang tidak ada di kedua kolom
select Country from Customers
except
select Country from Suppliers

