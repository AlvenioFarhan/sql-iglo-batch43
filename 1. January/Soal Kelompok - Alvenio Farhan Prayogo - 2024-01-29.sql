-- soal 10 perkelompok

use Northwind

select * from Products
select * from Categories
select * from Suppliers
select * from Shippers
select * from Customers
select * from Employees
select * from Orders


/*
Soal GAGAL - Alvenio Farhan Prayogo
Tampilkan Nama Lengkap Karyawan, Nama company costumer,  yang dimana customernya tinggal di negara Mexico.
*/

select distinct CONCAT(emp.FirstName, ' ', emp.LastName) NamaLengkap, cus.CompanyName, cus.Country
from Orders ord
join Employees emp on ord.EmployeeID = emp.EmployeeID
join Customers cus on ord.CustomerID = cus.CustomerID
where cus.Country = 'Mexico'


/*
Soal 1 - Alvenio Farhan Prayogo
Tampilkan nama lengkap serta titlenya, dan total ongkir order dari karyawan yang sama, serta cari urutan paling berat muatan ke 3 - 5
*/

select CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName)) NamaLengkap, sum(ord.Freight) TotalMuatan
from Orders ord
join Employees emp on ord.EmployeeID = emp.EmployeeID
group by CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName))
order by TotalMuatan desc
offset 2 rows 
fetch next 3 rows only




/*
Soal 2 - Alvenio Farhan Prayogo
Buat Laporan tiap Karyawan berapa kali order menggunakan Pengiriman yang sama. Jadi menampilkan Nama Lengkap Karyawan dan nama Pengirimnya
*/

select * from Orders
select * from Shippers
select * from Employees

;with Tabel as (
select CONCAT(e.FirstName, ' ', e.LastName) FullName , s.CompanyName, o.OrderID
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
join Employees e on o.EmployeeID = e.EmployeeID
)
select pvt.* from Tabel
pivot(count(OrderID) for CompanyName 
in ([Speedy Express], [United Package], [Federal Shipping]) 
) as pvt