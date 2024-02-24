use Northwind

--7) HRD ingin tahu jumlah karyawan di setiap region. Kalian diminta untuk menghitung jumlah karyawan 
--di setiap region di East, Northern, Western dan Southern. Tunjukan lah total jumlah employee di setiap Region Description. 
--Di urutkan dari Total Employee terbanyak ke yang paling sedikit, apabila ada yang jumlahnya sama, maka urutkan dari Region description secara ascending.


select * from Employees
select* from EmployeeTerritories
select * from Territories
select * from Region

select r.RegionDescription, count(t.RegionID) JumlahKaryawan
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
where r.RegionDescription in ('Eastern', 'Northern', 'Western', 'Southern')
group by r.RegionDescription
order by JumlahKaryawan desc, r.RegionDescription asc 





--8)Buatlah sebuah buku telpon untuk seluruh entitas di dalam database, termasuk Customers, Employees dan Supplier. 
--Buku telpon terdiri dari 3 column, yaitu Full Name atau nama lengkap setiap entitas, dan nomor phone setiap entitas, 
--dan column yang menentukan jenis entitas, apakah customer, employee atau supplier. List phone book ini di urutkan secara descending z-a 
--berdasarkan nama dari entitas

select * from Customers
select * from Employees
select * from Suppliers

select * from (
select c.ContactName, c.Phone, ('Customers')Jenis
from Customers c
union
select CONCAT( e.FirstName,' ', e.LastName), e.HomePhone, ('Employee')Jenis
from Employees e
union 
select s.ContactName,s.Phone, ('Suppliers')Jenis
from Suppliers s
) tbl
order by ContactName desc




--﻿9) Diadakan ngobrol dan meeting empat mata dari 1 orang pihak supplier dan 1 orang karyawan pihak internal untuk membahas feedback dari seorang supplier, 
--mengenai sistem distribusi baru dari perusahaan. Yang jadi masalah adalah saat ini adalah liburan Natal, semua employee sudah berlibur 
--dan pulang kembali ke negara masing-masing. Yang ingin management lakukan adalah menelfon salah satu available employee yang saat ini 
--sedang di negaranya dan menelfon salah satu available supplier yang dimana berada di lokasi negara yang sama dengan yang employee saat ini 
--sedang menetap. Management ingin menelfon untuk kesediaan mereka bertemu dan membicarakan sistem baru yang saat ini sedang di level prototype, 
--karena ini urgent jadi harus secepat mungkin dilakukan. Buatkan lah list kombinasi dari supplier dan employee, dimana mereka sedang berada di lokasi 
--yang sama saat ini.List tersebut harus memiliki informasi: Negara mereka sedang berada, nama supplier, nama employee dan nomor phone keduanya.

select * from Suppliers
select * from Employees

select e.Country, CONCAT( e.FirstName,' ', e.LastName) NamaEmployee, e.HomePhone, (s.ContactName) NamaSupplier, s.Phone
from Employees e
cross join Suppliers s
where e.Country in ('USA','UK')
order by e.Country 





--﻿10) Management ingin melihat Jumlah employee berdasarkan Job Title (Jabatan/Pekerjaan dan Pangkat) 
--di setiap Region (Northern, Eastern, Southern, Western). Buatlah sebuah table dengan format di bawah ini
--,dimana setiap table cell berisi informasi total employeenya.Job TitleJabatan 1...Jabatan 2...Jabatan 3...NorthernEasternUrutkan berdasarkan alphabet job titlenya dari A-Z

select * from Employees
select * from Region

select * from (
select e.Title, r.RegionDescription, e.EmployeeID
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
) tbl
PIVOT(count(EmployeeID) for RegionDescription in ([Northern],[Eastern], [Southern], [Western])
) pvt




