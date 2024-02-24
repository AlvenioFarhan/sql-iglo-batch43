/*
Soal 1 - Alvenio Farhan Prayogo

Tampilkan data ke 3 - 5 nama lengkap serta title karyawan dan total ongkos kirim dari order yang  mereka layani, diurutkan berdasarkan 
total ongkos kirim terbesar. 
*/

select * from Orders
select * from Employees

select CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName)) NamaLengkap, sum(ord.Freight) TotalOngkir
from Orders ord
join Employees emp on ord.EmployeeID = emp.EmployeeID
group by CONCAT(emp.TitleOfCourtesy,' ', concat(emp.FirstName, ' ', emp.LastName))
order by TotalOngkir desc
offset 2 rows 
fetch next 3 rows only




/*
Soal 2 - Alvenio Farhan Prayogo

Buat tabel pivot Laporan tiap Karyawan berapa kali order menggunakan Pengiriman yang sama. Jadi menampilkan Nama 
Lengkap Karyawan dan nama Pengirimnya
*/

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



/*
Soal 3 - Edwin Desemsky

Tampilkan 3 data berupa nama lengkap pegawai beserta title of courtesynya yang berusia lebih dari 20 tahun sejak hari ini
yang paling banyak melayani customer dengan range tahun 1996 hingga 1997  dan diurutkan dari yang terkecil hingga terbesar 
berdasarkan total customer yang telah dilayani 
*/


select top 3 concat(e.TitleOfCourtesy,' ',concat(e.FirstName,' ',e.LastName))  [Nama Lengkap Pegawai], count(ord.CustomerID) [Customer yang Dilayani]
from Employees e
join orders ord on ord.EmployeeID = e.EmployeeID
where DATEDIFF(year,e.BirthDate,getdate()) > 20 and datename(year,ord.OrderDate) between 1996 and 1997
group by e.TitleOfCourtesy,e.FirstName,e.LastName
order by [Customer yang Dilayani] asc;

/*
Soal 4 - Edwin Desemsky

Buatlah laporan pemesanan barang yang terbuat dari bahan botol(bottles),kaleng (cans),dan box (boxes) tiap tahun (1996,1997,1998) 
dan total jumlah pemesanan tiap produknya dari tahun 1996-1998
note: sumbu x:tahun , sumbu y:  nama produk

*/

select pvt.ProductName,pvt.[1996],pvt.[1997],pvt.[1998],(pvt.[1996] + pvt.[1997] + pvt.[1998]) [Total]
FROM(	select ord.OrderID, p.ProductName,datename(Year,ord.OrderDate) TahunPemesanan
		from Products p
		join [Order Details] ordet on ordet.ProductID = p.ProductID
		join Orders ord on ord.OrderID = ordet.OrderID
		where  p.QuantityPerUnit like '%bottles%' or p.QuantityPerUnit like '%cans%' or p.QuantityPerUnit like '%boxes%'
)AS tabelBaru
PIVOT(count(OrderID) for tabelBaru.TahunPemesanan IN ([1996], [1997], [1998])) as pvt

/*
Soal 5 - Bunga Fairuz

Tampilkan nama kontak dan nomer telepon customer yang pernah membeli produk yang stoknya habis dan sudah diskontinu
*/
select distinct c.ContactName, c.Phone
from Orders o
join (select od.OrderID, p.ProductID, p.ProductName
	from [Order Details] od
	join Products p on p.ProductID = od.ProductID
	where p.Discontinued = 1 and p.UnitsInStock <= 0) orderProduct on orderProduct.OrderID = o.OrderID
join Customers c on c.CustomerID = o.CustomerID



/*
Soal 6 - Bunga Fairuz

Buatlah laporan total ongkos kirim (freight) untuk masing-masing shipper company dalam satu tahun pada 
tahun (1996, 1997, 1998) dengan nilai total ongkir pembulatan ke atas tanpa angka nol di belakang koma 
1996, 1997, 1998 (sumbu x)
List shipper company name (sumbu y)
*/

SELECT pvt.ShipCompany [Ship Company], 
	cast(CEILING([1996]) as bigint) [1996], 
	cast(CEILING([1997]) as bigint) [1997],
	cast(CEILING([1998]) as bigint) [1998]
FROM (
	select s.CompanyName as ShipCompany, DATENAME(YEAR, ShippedDate) as yearShipped, Freight
	from Orders o
	join Shippers s on s.ShipperID = o.ShipVia
)AS orderShip
PIVOT(SUM(orderShip.Freight) 
FOR orderShip.yearShipped IN ([1996], [1997], [1998])) AS pvt

/*
Soal 7 - Anan Sosmita

Tampilkan data nama produk, nama kategori dimana ReOrderLevel lebih tinggi dari 20 dan diurutkan dari ReOrderLevel paling tinggi. 
kemudian ambilah data ke 6 dan 7
*/

select p.ProductName, c.CategoryName, p.ReorderLevel
from Products p
join Categories c on c.CategoryID = p.CategoryID
where p.ReorderLevel >20
order by p.ReorderLevel DESC
offset 5 row
fetch next 2 row only

/*
Soal 8 - Anan Sosmita

tampilkan 3 data  supplier yang terdiri dari nama perusahaan, kota dan negara sebagai alamat lengkap perusahaan,
nama produk yang di supply, serta harga rata-rata produk di negara Norway,Denmark,Finland, dan Spain 
dan diurutkan berdasarkan harga rata-rata produk yang paling tinggi
*/

select top 3 concat (s.CompanyName,' ', s.City,' ', s.Country)[Alamat Lengkap Perusahaan], p.ProductName, 
avg(p.UnitPrice) [Harga Rata-rata Produk]
from Products p
join Suppliers s on s.SupplierID = p.SupplierID
where Country in ('Norway','Denmark','Finland','Spain')
group by s.CompanyName, s.City, s.Country,  p.ProductName
order by [Harga Rata-rata Produk] DESC

/*
Soal 9 - Afifah
Tampilkan harga produk tertinggi di tiap nama company supplier yg berawalan huruf a,i,u,e,o
dan diiurutkan dari harga tertinggi
 */

select s.CompanyName, max(UnitPrice) hargaMax
from Suppliers s
inner join Products p on s.SupplierID=p.SupplierID
where s.CompanyName like 'a%' OR s.CompanyName like 'i%' OR s.CompanyName Like 'u%' Or s.CompanyName like 'e%' or s.CompanyName like 'o%'
group by s.CompanyName
order by hargaMax desc


/*
Soal 10 - Afifah

Buat tabel pivot laporan jumlah pengiriman pesanan yang dilayani oleh masing-masing employee (fullname) ke 
negara uk, usa, brazil, germany, dan venezuela di tahun 1998 dan dikirim melalui speedy Express.
Laporan berisi nama lengkap employee(sumbu y), country(sumbu x)
 */ 

 select *
from
(select concat (emp.FirstName, ' ', emp.LastName) fullname, ord.ShipCountry, ord.OrderID
from Employees as emp
join orders as ord on emp.employeeID=ord.EmployeeID
join Shippers as ship on ord.ShipVia=ship.ShipperID
where ord.ShipCountry in ('UK', 'USA', 'Brazil', 'Germany', 'Venezuela') and DATENAME (YEAR, ord.ShippedDate) = 1998 and ship.CompanyName = 'Speedy Express'
) tbl
pivot (
	count(OrderID) for ShipCountry in ([UK], [USA], [Brazil], [Germany],[Venezuela])
	) pvt