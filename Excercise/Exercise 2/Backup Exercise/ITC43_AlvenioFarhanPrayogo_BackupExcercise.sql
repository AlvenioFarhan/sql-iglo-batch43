use Northwind

--1. Employee performance after 1996.sql
--Atasan ingin mengetahui berapa jumlah penjualan yang dihasilkan setiap karyawannya setelah tahun 
--1996. Buatlah query yang menghasilkan laporan berisi, nama lengkap karyawannya dan total jumlah 
--ordernya setelah tahun 1996.select * from Ordersselect * from [Order Details]select * from Employeesselect CONCAT(e.FirstName, ' ', e.LastName)NamaLengkap, COUNT(o.OrderDate)JumlahOrderfrom Orders ojoin Employees e on o.EmployeeID = e.EmployeeIDjoin [Order Details] od on o.OrderID = od.OrderIDwhere DATENAME(YEAR, o.OrderDate) >= 1996group by e.FirstName, e.LastName--2. Employee total territory.sql
--HRD ingin mengetahui seberapa sibuk setiap karyawan yang ada di dalam northwind. Oleh karena itu 
--buatlah query yang mengeluarkan laporan nama lengkap karyawan dan berapa jumlah territory yang 
--ditugaskan pada employee tersebut. (Note: territory tempat dia ditugaskan)

select * from Employees
select * from EmployeeTerritories
select * from Territories

select CONCAT(e.FirstName, ' ', e.LastName)NamaLengkap, COUNT(et.TerritoryID)JumlahTerritory
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
group by e.FirstName, e.LastName





--3. Total reorder cost.sql
--Ingin diketahui berapa banyak total biaya yang harus dikeluarkan untuk rencana pembelian barang di 
--setiap category barang. Jumlah quantity rencana pembelian product di informasikan di angka Reorder 
--Level. Pada northwind tidak diberikan informasi harga jual dan harga beli barang secara berbeda, 
--sehingga harga jual dan harga beli di anggap sama, yaitu Unit Pricenya. Laporan yang diminta adalah, 
--nama kategori, dan total biaya pembelian berikutnya (Reorder).

select * from Categories
select * from Products

select c.CategoryName, sum(p.UnitPrice * p.ReorderLevel)TotalBiayaReorder
from Categories c
join Products p on c.CategoryID = p.CategoryID 
group by c.CategoryName





--4. Discontinue order.sql
--Hitung ada berapa banyak jumlah order di dalam seluruh sejarah penjualan northwind dari awal sampai 
--akhir, yang pernah menjual product yang saat ini sudah discontinue. Hasil yang diharapkan bukan 
--berupa laporan, melainkan hanya satu angka (scalar) dalam bilangan bulat berupa jumlah ordernya

select * from Orders
select * from Products

select count(o.OrderID)JumlahTotalOrder
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Products p on p.ProductID = od.ProductID
where p.Discontinued = 1





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

select p.ProductName, s.City, (od.Quantity * od.UnitPrice)TotalOmset
from Products p
join Suppliers s on p.SupplierID = s.SupplierID
join [Order Details] od on p.ProductID = od.ProductID






--6. Region data.sql
--Atasan ingin mengetahui data jumlah territory dan jumlah karyawan yang bekerja di satu Region.
--Tolong buatlah laporan berupa, nama region, jumlah territory di dalam region tersebut dan jumlah 
--karyawan yang di assign pada region tersebut.

select * from Territories
select * from Employees
select * from EmployeeTerritories
select * from Region

select r.RegionDescription, count(t.TerritoryID)JumlahTerritory, count(e.EmployeeID)JumlahKaryawam
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
where e.EmployeeID = r.RegionID
group by r.RegionDescription





--7. Federal Shipping order.sql
--Ingin diketahui berapa jumlah uang yang di hasilkan (omset/omzet) oleh setiap order yang mengirim 
--lewat perusahaan Federal Shipping. Laporan yang diminta adalah Order Id dan jumlah uang yang 
--dihasilkan oleh setiap order Id tersebut. (Note: jangan lupa menambahkan satu ongkos kirim (Freight) di 
--setiap order. Hati-hati, harga product saat penjualan berbeda dengan harga product saat ini)
--(Note: tidak memperdulikan discount)

select * from Shippers
select * from Orders
select * from [Order Details]

select o.OrderID, sum((od.UnitPrice * Quantity) + o.Freight)JumlahUangOrder
from Orders o
join Shippers s on o.ShipVia = s.ShipperID
join [Order Details] od on o.OrderID = od.OrderID
where s.CompanyName = 'Federal shipping'
group by o.OrderID





--8. Different price.sql
--Ingin diketahui perbedaan harga dari harga katalog product dengan harga di saat order barang tersebut. 
--Keluarkan informasi berupa order id, nama product yang ada pada detail order ini, harga product pada 
--saat penjualan, harga product asli, dan selisih harga product saat penjualan dan harga product saat ini. 
--(penurunan harga ditandai dengan nominal minus -)
--(Note: tidak memperdulikan discount)

select * from Products
select * from [Order Details]
select * from Orders

select o.OrderID, p.ProductName, od.UnitPrice, p.UnitPrice, (od.UnitPrice - p.UnitPrice)Selisih
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID





--9. Customer loyalty.sql
--Ingin diketahui nama perusahaan customer yang selama tahun 1997 berbelanja paling banyak di 
--northwind. Keluarkan informasi berupa, nama perusahaan customer, jumlah total belanja (tidak 
--termasuk ongkos kirimnya). Urutkan data dari customer yang berbelanja paling banyak ke yang paling 
--sedikit. (Note: tidak memperdulikan discount)select * from Customersselect * from Ordersselect * from [Order Details]select c.CompanyName, (od.UnitPrice * od.Quantity)TotalBelanjafrom Customers cjoin Orders o on c.CustomerID = o.CustomerIDjoin [Order Details] od on o.OrderID = od.OrderIDwhere DATENAME(YEAR, o.OrderDate) = 1997order by TotalBelanja desc--10. Region total sales.sql
--Ingin diketahui total penjualan yang dihasilkan oleh setiap Region tempat employee ditugaskan.
--Keluarkan informasi berupa nama region (region description) dengan total penjualannya.
--Berapa untuk Eastern, Western, Northern dan Southern. (Note: tidak memperdulikan discount)

select * from Region
select * from Employees
select * from Orders
select * from [Order Details]

select r.RegionDescription, sum(od.UnitPrice * od.Quantity)TotalPenjualan
from Region r
join Territories t on r.RegionID = t.RegionID
join EmployeeTerritories et on t.TerritoryID = et.TerritoryID
join Employees e on et.EmployeeID = e.EmployeeID
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
group by r.RegionDescription





--11. Total product from supplier.sql
--Ingin diketahui berapa jumlah macam product yang dihasilkan oleh setiap perusahaan supplier yang 
--masih diproduksi oleh supplier tersebut dan dijual di northwind. Keluarkan informasi pada laporan 
--berupa, nama perusahaan supplier dan jumlah macam product.select * from Productsselect * from Suppliersselect  s.CompanyName, count(p.ProductID)JumlahMacamProdukfrom Suppliers sjoin Products p on s.SupplierID = p.SupplierIDgroup by s.CompanyName--12. Supplier speciality.sql
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






--13. Category price range.sql
--Ingin diketahui berapa harga termahal dan harga termurah product di setiap macam category product.
--Keluarkan informasi berupa nama kategori, harga product termahal di kategori ini, dan harga termurah 
--di category ini. (Note: tidak memperdulikan discount)

select * from Products
select * from Categories

select c.CategoryName , MAX(p.UnitPrice)HargaTermahal, MIN(p.UnitPrice)HargaTerendah
from Categories c
join Products p on c.CategoryID = p.CategoryID
group by c.CategoryName






--14. Total Order Discount.slq
--Ingin diketahui berapa besar total potongan harga (discount) yang diberikan northwind untuk setiap 
--order yang pernah ada. Informasi yang diminta adalah order id, total potongan harga pada order ini.

select * from Orders
select * from [Order Details]

select od.OrderID, sum(od.UnitPrice * od.Discount)TotalPotonganHarga
from [Order Details] od
group by od.OrderID





--15. Order without discount.sql
--Hitung berapa jumlah order yang ada di dalam northwind, dimana order tersebut tidak ada discount 
--sama sekali di dalamnya. Hasil yang diinginkan hanya 1 angka jumlah order tersebut

select * from [Order Details]
select * from Orders

select COUNT(tbl.OrderID) JumlahOrder
from (
select od.OrderID, SUM(Discount) Diskon
from [Order Details] od
group by od.OrderID
) tbl
where Diskon = 0
