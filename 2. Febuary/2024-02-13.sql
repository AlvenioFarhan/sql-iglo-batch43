use Northwind

/*
Daftar Produk yang siap dijual (continue dan stok > 0)
*/

create view ProdukReady as (
select * from Products p
where p.Discontinued = 0 and p.UnitsInStock > 0
)

alter view ProdukReady as (
select p.ProductID, p.ProductName, p.UnitPrice
from Products p
where p.Discontinued = 0 and p.UnitsInStock > 0
)

select * 
into #tempProductReady
from Products p 
where p.Discontinued = 0 and p.UnitsInStock > 0

--View jika data sudah di update maka ketika ditampilkan juga akan terupdate
select * from ProdukReady
select * from #tempProductReady


--membuat laporan dengan table view (PIVOT)
select *
from (
select s.SupplierID, p.CategoryID, p.ProductID
from ProdukReady p
join Suppliers s on p.SupplierID = s.SupplierID
) tbl
pivot (count(productid)for categoryid in ([1], [2], [3])) pvt




--untuk membuat laporan data seluruh database
select * from INFORMATION_SCHEMA.COLUMNS







/*
Pengkondisian : 
1. IF
2. IF ELSE
3. IF, ELSE IF, ELSE
4. Function IIF
5. Case When
*/



--Function IIF
select p.ProductID, s.CompanyName, c.CategoryName, p.UnitsInStock, p.Discontinued, 
IIF(p.Discontinued = 0, 'Continue', IIF(p.Discontinued = 1, 'Discontinue', 'N/A')) StatusProduk
from Products p 
join Suppliers s on p.SupplierID = s.SupplierID
join Categories c on p.CategoryID = c.CategoryID



select e.EmployeeID, CONCAT(e.FirstName,' ',e.LastName) FullName, e.Country, e.Region,
IIF(e.Country = 'USA' and e.Region = 'WA', 'USA', IIF(e.country = 'UK' and e.region = 'WA', 'UK', 'NA'))
from Employees e



select e.EmployeeID, CONCAT(e.FirstName,' ',e.LastName) FullName, *
from Employees e


select ContactName SupplierContactName, CompanyName as Company from Suppliers
union
select ContactName CustomerContactName, CompanyName as Company from Customers
union
select CONCAT(FirstName, ' ', LastName), NULL as Company from Employees


--CASE WHEN
select tbl.CustomerContactName as FullName,	
case 
	when Company is null then 'Northwind'
	else Company
end as CompanyName
from (
select ContactName CustomerContactName, CompanyName as Company from Customers
union
select CONCAT(FirstName, ' ', LastName), NULL as Company from Employees
) tbl 




select p.ProductID, s.CompanyName, c.CategoryName, p.UnitsInStock, p.Discontinued, 
IIF(p.Discontinued = 0, 'Continue', IIF(p.Discontinued = 1, 'Discontinue', 'N/A')) StatusProduk,
case
	when p.Discontinued = 0 then 'Continue'
	when p.Discontinued = 1 then 'Discontinue'
	else 'N/A'
end as StatusProdukByCaseWhen
from Products p 
join Suppliers s on p.SupplierID = s.SupplierID
join Categories c on p.CategoryID = c.CategoryID




--Pengkondisian IF, IF ELSE, IF ELSE IF, DLL
declare @angka int=10,
		@index int = 5

--IF
if(@angka %2 = 0)
begin
	print 'Bilangan Genap'
end

--IF ELSE
if(@angka %2 = 0)
begin
	print 'Bilangan Genap'
end
else
begin
	print 'Bilangan Ganjil'
end

--IF, ELSE IF, ELSE
if(@angka %2 = 0)
begin
	print 'Bilangan Genap'
end
else if (@angka %2 = 1)
begin
	print 'Bilangan Ganjil'
end
else
begin
	print 'Bilangan Tak Dikenal'
end


--Soal
--employee id, nama lengkap, title, jabatan, gender
select * from Employees

select e.EmployeeID, e.TitleOfCourtesy, CONCAT(e.FirstName,' ', e.LastName) FullName, e.Title,
IIF(e.TitleOfCourtesy = 'Mr.' or e.TitleOfCourtesy = 'Dr.', 'Pria', 'Wanita') Gender
from Employees e


select e.EmployeeID, e.TitleOfCourtesy, CONCAT(e.FirstName,' ', e.LastName) FullName, e.Title,
IIF(e.TitleOfCourtesy = 'Mr.', 'Pria', IIF(e.TitleOfCourtesy = 'Dr.' or e.TitleOfCourtesy = 'Mrs.', 'NA', 'Wanita')) Gender
from Employees e



--soal
--buatkan view untuk menghitung kondisi setiap employee
--employee siapa, dan kota kondisi yang di dapat
--dengan kriteria employee dapat komisi jika dia berhasil setidaknya menjual 5 quantity dari yang dia jual

select * from Employees
select * from Orders
select * from [Order Details]

create view KomisiKaryawan2 as (
select tbl2.EmployeeID, sum(tbl2.Penjualan * tbl2.UnitPrice) Komisi
from(
select tbl.EmployeeID, (tbl.Quantity / 5) Penjualan, tbl.UnitPrice
from (
select e.EmployeeID,od.OrderID, od.Quantity, od.UnitPrice
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where od.Quantity > 5
) tbl
)tbl2
group by tbl2.EmployeeID
--order by Komisi desc
)

--versi kawan
create view KomisiKaryawan as (
select o.EmployeeID, SUM(CAST(od.Quantity/5 as int) * od.UnitPrice) TotalKomisi
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
where od.Quantity > 5
group by o.EmployeeID
--order by TotalKomisi asc
)

select * from dbo.KomisiKaryawan
select * from dbo.KomisiKaryawan2




--soal
--produk id, produk name
--produk" yang mengalami perubahan harga minimal 2 kali

select * from Products
select * from [Order Details]

select od.ProductID, od.OrderID, p.UnitPrice HargaMaster, od.UnitPrice HargaTransaksi
from Products p
join [Order Details] od on p.ProductID = od.ProductID
order by od.ProductID

select tbl.ProductID, tbl.ProductName
from (
select od.ProductID, p.ProductName, COUNT(distinct od.UnitPrice) JumlahPerubahan
from Products p
join [Order Details] od on p.ProductID = od.ProductID
where p.UnitPrice != od.UnitPrice
group by od.ProductID, p.ProductName
) tbl
where JumlahPerubahan >=2
order by JumlahPerubahan desc


--versi teman
select tbl.ProductID, tbl.ProductName
from (
select p.ProductID, p.ProductName, COUNT(distinct od.UnitPrice) Perubahan
from Products p
join [Order Details] od on od.ProductID = p.ProductID
where p.UnitPrice != od.UnitPrice
group by p.ProductID, p.ProductName
) tbl
where tbl.Perubahan >=2


--versi teman
with tbl1 as (
--dengan harga sama
select od.ProductID, od.UnitPrice, COUNT(1) TotalOrder
from Orders o
join [Order Details] od on od.OrderID = o.OrderID
group by od.ProductID, od.UnitPrice
),
tbl2 as (
--menghitung perubahan harga
select tbl1.ProductID, p.ProductName, COUNT(tbl1.ProductID) TotalPerubahan
from tbl1
join Products p on p.ProductID = tbl1.ProductID
group by tbl1.ProductID, p.ProductName
having COUNT(tbl1.ProductID) > 2
)
--menampilkan data
select ProductID, ProductName
from tbl2
order by tbl2.ProductID



--versi teman
with tbl1 as (
select od.ProductID, p.ProductName, COUNT(distinct od.UnitPrice) Total
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by od.ProductID, p.ProductName
having COUNT(distinct od.UnitPrice) > 2
)
select ProductID, ProductName from tbl1




--versi teman
select p.ProductName, od.ProductID, COUNT(distinct od.UnitPrice) Perubahan 
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Products p on p.ProductID = od.ProductID
group by p.ProductName, od.ProductID
having COUNT(distinct od.UnitPrice) > 2




--Jawaban dari kak vina
;with HargaNow as (
select GETDATE() TanggalBerlaku, p.ProductID, p.UnitPrice 
from Products p
order by ProductID asc
offset 0 rows
),  
HargaLampau as (
select o.OrderDate TanggalBerlaku, od.ProductID, od.UnitPrice
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
order by od.ProductID asc
offset 0 rows
),
HargaAll as (
select CONVERT(date, TanggalBerlaku) as TanggalBerlaku, ProductID, UnitPrice
from (
select * from HargaLampau
union 
select * from HargaNow
) tbl
order by tbl.ProductID asc, TanggalBerlaku asc
offset 0 rows
),
DaftarHarga as (
select ProductID, UnitPrice, MIN(TanggalBerlaku) StartDate, MAX(TanggalBerlaku) ExpriedDate
from HargaAll
group by ProductID, UnitPrice
order by ProductID asc, StartDate asc
offset 0 rows
)
--select * from DaftarHarga
select ProductID, COUNT(1)-1 TotalPerubahan
from DaftarHarga
group by ProductID
having COUNT(1)-1 >= 2






--looping

declare @angka int = 10,
		@index int = 1

while (@index <= @angka)
begin
	print @index
	set @index = @index+1;
end


--looping dengan if
declare @angka int = 10,
		@index int = 1

while (@index <= @angka)
begin
	print @index

	if(@index % 2 = 0)
	begin
		print 'Bilangan Genap'
	end

	set @index = @index+1;
end




--break dan continue
-- break itu berhenti/rem, jadi query selanjutnya itu langsung berhenti/ tidak di lanjut
--continue itu skip, jadi query selanjutnya itu langsung di skip atau tidak dibaca

--break
declare @angka int = 10,
		@index int = 1

while (@index <= @angka)
begin
	print @index

	if(@index % 2 = 0)
	begin
	break;
		print 'Bilangan Genap'
	end

	set @index = @index+1;
end




--continue
declare @angka int = 10,
		@index int = 1

while (@index <= @angka)
begin
	print @index

	if(@index % 2 = 0)
	begin
	continue;
		print 'Bilangan Genap'
	end

	set @index = @index+1;
end





--GOTO
--konsep baca krusor
declare @menu int = 2

if (@menu = 1) goto MenuSatu
if (@menu = 2) goto MenuDua
if (@menu = 3) goto MenuTiga

MenuSatu:
	print 'Cek Saldo'

MenuDua:
	print 'Transfer Pulsa'

MenuTiga:
	print 'Cek Masa Berlaku'





--TRY_PARSE untuk convert error, untuk handle error jenis parsing
select TRY_PARSE('abc' as int)

--try catch
begin try
	--select PARSE('abc' as int)
	select 'Hari ini Cerah'
	select DATEADD(DAY, 2, '13-12-2024')

end try
begin catch
	select 'ERROR WOI', ERROR_LINE() ErrorLine
end catch







--Function
--hampir mirip dengan view


--function scalar
create function HitungUsia (
	@birthdate as datetime
)
returns int as
begin
	return DATEDIFF(YEAR, @birthdate, GETDATE())
end

select e.EmployeeID, e.FirstName, dbo.HitungUsia(e.BirthDate) as Usia
from Employees e
drop function dbo.HitungUsia



--function table
create function GetProductByDiscontinueAndMinStock (
@discontinue bit,
@stock int
)
returns table return
select *
from Products
where Discontinued = @discontinue and UnitsInStock >= @stock

select * from dbo.GetProductByDiscontinueAndMinStock(1,1)
drop function dbo.GetProductByDiscontinueAndMinStock



--buat CART Type
create type CART as Table
(
productID INT NOT NULL PRIMARY KEY,
Quantity INT NOT NULL
);
select * from dbo.CART


--function table contoh soal
declare @daftarProduct as CART

insert into @daftarProduct
values (1, 10), (3, 10)

create function HitungPerkiraanTotalHargaBarang (
	/*Params*/
	@listBarang as CART readonly
)
returns money as
begin
	return (
	select SUM(p.UnitPrice * lb.Quantity)
	from @listBarang lb
	join Products p on lb.productID = p.ProductID

	)
end

select dbo.HitungPerkiraanTotalHargaBarang(@daftarProduct)
drop function dbo.HitungPerkiraanTotalHargaBarang





--SOAL
--produk dan quantity
--view, produk id, produk name, quantiti pembelian
--pembelian setiap produk tidak boleh lebih dari 2 
--buat function, return parameter money

select * from Products

create function Pembelian (@uang as money)
returns @HasilTable table (
ProductID int,
Quantity int,
Harga money,
SisaUang money
)
as
begin
	
	declare @baris int = 1;
	declare @id int
	declare @hargaperproduk money

	while (@uang >= 0 and @baris <= (select COUNT(ProductID) from Products where UnitsInStock > 0 and Discontinued = 0))
	begin

		set @id = (					
					select ProductID
					from (
						select ProductID, ROW_NUMBER() over (order by UnitPrice) as NomorBaris
						from Products
						where Discontinued = 0 and UnitsInStock > 0
						) as NomorProduk
					where NomorBaris = @baris
					)

		set @hargaperproduk = (
								select UnitPrice
								from Products 
								where ProductID = @id								
								);

		if (@uang >= @hargaperproduk)
		begin

			if (@uang >= @hargaperproduk * 2)
			begin

				set @uang = @uang - (@hargaperproduk * 2)

				insert into @HasilTable
				values (@id, 2, @hargaperproduk, @uang)

			end --end if

			else 
			begin

			set @uang = @uang - @hargaperproduk

			insert into @HasilTable
			values (@id, 1, @hargaperproduk, @uang)

			end --end else

		end --end if

		set @baris = @baris + 1

	end --end while

return
end --end function

select * from dbo.Pembelian(100)
drop function Pembelian