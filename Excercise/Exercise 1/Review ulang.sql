--Manajemen ingin tahu perusahaan shipper mana yang paling populer dan yang paling mengantarkan banyak order di sepanjang masa. 
--Keluarkan nama 1 perusahaan shipper yang paling populer dengan total ordernya.

use Northwind

select *
from Shippers

select *
from Orders

select ship.CompanyName PerusahaanPopular, count(ord.ShipVia) TotalOrder
from Shippers ship, Orders ord
where ShipperID = shipvia
--right join Orders ord on ship.ShipperID = ord.OrderID
group by ship.CompanyName
order by TotalOrder desc


--Ingin diketahui seluruh Territory penjualan, beserta nama lengkap karyawan yang bekerja di territory tersebut. 
--Baik ada ataupun tidak ada karyawan, territory description harus tetap ditunjukan.

use Northwind

select *
from Territories

select *
from EmployeeTerritories

select *
from Employees

select CONCAT(emp.TitleOfCourtesy, ' ', emp.FirstName, ' ', emp.LastName) NamaLengkap, ter.TerritoryDescription
from EmployeeTerritories et
right join Territories ter on et.TerritoryID = ter.TerritoryID
join Employees emp on et.EmployeeID = emp.EmployeeID



--Kerugian di sisi penjualan bisa disebabkan oleh banyak scenario, salah satunya adalah kerusakaan product-product di tempat penyimpanan, 
--terutama barang pecah belah. Beberapa kemasan product-product ini memang mudah pecah, karena sebagian terbuat dari glasses (gelas kaca), 
--bottle (botol), dan jars (toples). Karena itu management membuatkan lemari penyimpanan baru yang lebih aman untuk barang pecah belah, 
--tetapi management kesulitan untuk menetukan barang yang mana yang harus di simpan lemari yang aman ini. Buatlah laporan dengan informasi nama product, 
--nama perusahaan supplier, nama category, jumlah quantity dalam kemasan dan unit in stock di penyimpanan, dimana semua barang tersebut memiliki kemasan 
--pecah belah berupa gelas kaca, botol atau toples.


use Northwind

select *
from Products

select *
from Suppliers

select *
from Categories

select prod.ProductName, sup.CompanyName, cat.CategoryName, prod.QuantityPerUnit, prod.UnitsInStock
from Products prod
join Suppliers sup on prod.SupplierID = sup.SupplierID
join Categories cat on prod.CategoryID = cat.CategoryID
where prod.QuantityPerUnit like '%glasses%' or prod.QuantityPerUnit like '%bottle%' or prod.QuantityPerUnit like '%jars%'



--Management ingin mengetahui rata-rata harga product-product per unitnya yang berasal dari supplier yang berada di negara-negara Eropa, 
--yaitu Germany, Spain, Sweden, Italy, Norway, Denmark, Netherland, Finland, dan France. Management ingin terus bekerja sama dengan supplier dari Eropa, 
--selama harga rata-rata productnya 50 dolar kebawah. Tunjukan harga rata-rata barang untuk setiap negara di Eropa, lalu tampilkan berurutan dari yang 
--tertinggi harga rata-ratanya sampai yang terendah, terkecuali yang harga rata-rata barangnya di atas 50 dollar.

use Northwind

select *
from Suppliers

select *
from Products

select avg(prod.UnitPrice) HargaRata2, sup.Country
from Products prod
join Suppliers sup on prod.SupplierID = sup.SupplierID
where sup.Country in ('Germany', 'Spain', 'Sweden', 'Italy', 'Norway', 'Denmark', 'Netherland', 'Finland', 'France')
group by sup.Country
having not avg(prod.UnitPrice) > 50
order by HargaRata2 desc




--Supervisor kalian yang ada di USA Branch, ingin agar salah satu karyawannya bertugas membawakan presentasi di USA. 
--Karyawannya harus yang sangat mengenal Amerika dan bagus bahasa inggrisnya, oleh karena itu harus yang berasal dari USA. 
--Ia ingin bertanya kepada setiap karyawannya yang ada di database via telphone. Jabarkanlah seluruh karyawan anda 
--dengan nama lengkap dan title of courseynya, beserta nomor telponnya.

use Northwind

select *
from Employees

select CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) NamaLengkap, HomePhone, Country
from Employees
where Country = 'USA'



--Gudang penyimpanan memiliki banyak section, dan tidak semua section memiliki besar ruang dan luas yang sama. 
--Di antara beberapa section tersebut ada 2 ruangan yang paling kecil. Stock dan warehouse management ingin membagi setiap section 
--untuk setiap category product, sehingga satu macam category akan di kelompokan dan di simpan dalam satu section. Management ingin mengetahui, 
--2 category product yang jumlah unit in stocknya paling sedikit, untuk disimpan pada 2 ruangan section yang paling kecil juga, agar menghemat tempat. 
--Tunjukan 2 Category beserta total unit in stocknya yang jumlahnya paling sedikit kepada management.

use Northwind

select *
from Products

select *
from Categories

select top 2 cat.CategoryName, sum(prod.UnitsInStock) totalUnit
from Categories cat
join Products prod on cat.CategoryID = prod.CategoryID
group by cat.CategoryName
order by totalUnit