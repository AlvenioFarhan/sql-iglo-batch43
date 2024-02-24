-- 2024-02-13

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









--2024-02-15

/*Daftar Produk yang ready*/
drop function dbo.DataProductByCounter

create function DataProductByCounter(@index int)
returns table return
	select p.ProductID, p.UnitPrice, p.UnitsInStock
	from Products p
	where p.Discontinued = 0 and p.UnitsInStock > 0
	order by ProductID asc
	offset @index - 1 rows
	fetch next 1 rows only


drop function dbo.LustProductYangBisaDibeli

create function LustProductYangBisaDibeli(@uang money)
returns @resultTable table (ProductID varchar(100), Qty int)
as
begin
	
	declare @totalData int = (select Count(1) from dbo.ProdukReady),
	@index int = 1,
	@maxQty int = 2

	while(@index <= @totalData)
	begin

		declare @hargaSatuQty money = (select UnitPrice * 1 from dbo.DataProductByCounter(@index))
		declare @hargaDuaQty money = (select UnitPrice * 2 from dbo.DataProductByCounter(@index))

		if(((select UnitInStock from dbo.DataProductByCounter(@index)) >= @maxQty) and
			(@uang >= @hargaDuaQty or @uang >= @hargaSatuQty)
		)
		begin
			insert into @resultTable
			select ProductID, IIF(@uang >= @hargaDuaQty, 2, 1) as Qty
			from DataProductByCounter(@index)

			select @uang = @uang - IIF(@uang >= @hargaDuaQty, @hargaDuaQty, @hargaSatuQty)
			from DataProductByCounter(@index)
			
		end

		set @index = @index + 1

	end
	return
end



declare @uang money = 25,
		@keranjang Cart

insert into @keranjang

select k.*, p.UnitPrice * k.Qty
from @keranjang k
join Products p on k.ProductId = p.ProductID

select @uang as Uang,
dbo.[HitungPerkiraanTotalHargaBarang](@keranjang) TotalHargaBarang,
@uang - dbo.[HitungPerkiraanTotalHargaBarang](@keranjang) as SisaUang










--Ranking

--ROWNUMBER
select ROW_NUMBER() over (order by ProductId) 'Nomor Urut',
p.* 
from Products p

select ROW_NUMBER() over (partition by SupplierId order by ProductId) 'Nomor Urut Partition By',
ROW_NUMBER() over (order by ProductId) 'Nomor Urut',
p.* 
from Products p
order by SupplierID, ProductID


--RANK
--select RANK() over (partition by SupplierId order by ProductId) 'Nomor Urut Partition By',
select RANK() over (order by SupplierId) 'Nomor Urut',
p.* 
from Products p
order by SupplierID, ProductID



--Dense Rank
select DENSE_RANK() over (partition by SupplierId order by CategoryId) 'Nomor Urut',
p.* 
from Products p
order by SupplierID, ProductID



--LAG
select p.CategoryID, p.ProductID, p.UnitPrice ,LAG(UnitPrice) over (partition by CategoryId order by CategoryId) UnitPriceBefore
from Products p
order by CategoryID


--LEAD
select p.CategoryID, p.ProductID, p.UnitPrice ,LEAD(UnitPrice) over ( order by UnitPrice) UnitPriceAfter
from Products p
order by UnitPrice


--First_Value
select p.CategoryID, p.ProductID, p.UnitPrice ,FIRST_VALUE(UnitPrice) over (partition by CategoryId order by UnitPrice) FirstValue
from Products p
order by UnitPrice


--Last_Value
select p.CategoryID, p.ProductID, p.UnitPrice ,LAST_VALUE(UnitPrice) over (partition by CategoryId order by UnitPrice
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) LastValue
from Products p
order by UnitPrice






--Schema
create schema Customer
go
create table Customer.Pembeli
(
Id int identity (1,1) primary key,
NamaLengkap varchar(50)
)

select * from Customer.Pembeli






--Stored Procedure
create procedure DaftarCustomer
--@param int
as
begin
--isi SP
select * from Customers
end

execute DaftarCustomer



create proc DetailCustomer
@customerId varchar(10),
@shipCountry varchar(100)
as
begin
	--Info customer
	select * from Customers where CustomerID = @customerId

	--info Transaksi
	select * from Orders where CustomerID = @customerId and ShipCountry = @shipCountry
end

exec DetailCustomer @customerId = 'ALFKI', @shipCountry = 'Germany'




--bikin SP(Storage Procedure),untuk proses terjadinya transaksi pembelian, yang mana bisa menerima pembelinya/customerid, 
--daftar barang/produk apa yang mau dibeli, jasa pengiriman siapa/menggunakan id, siapa sales/employee nya yang mengangani transaksi tersebut
--dengan ketentuan harga ongkir dilihat dari total quantity dikali dengan 3$ 
drop proc TransaksiPembelian

alter procedure TransaksiPembelian 
--@OrderID INT,
@CustomerID varchar(10),
@ProductName varchar(100), 
@ShipperID int, 
@EmployeeName varchar(100)
--@Quantity varchar(10)
as
begin

select CustomerID from Customers where CustomerID = @CustomerID

select ProductID from Products where ProductName = @ProductName

--select * from Orders 

select ShipperID from Shippers where ShipperID = @ShipperID

select FirstName from Employees where EmployeeID = @EmployeeName

--select * from [Order Details] where Quantity = @Quantity

end

exec TransaksiPembelian 'ALFKI', 'Chai', '1', '1'



select * from Customers 
select * from Orders 
select * from Products 
select * from Shippers 
select * from Employees 
select * from [Order Details] 



 



 --Answer
 create function checkStock(@cart as CART readonly)
returns @output table(
	id int, Quantity int, status varchar(20)
) as
begin
	declare @count int = 0;
	declare @rowcart int = (select count(*) from @cart);

	while(@count < @rowCart)
	begin
		declare @pID int = (select productID from @cart
							order by productID
							offset @count rows
							fetch next 1 row only)
							
		declare @Quantity int = (select Quantity from @cart
							order by productID
							offset @count rows
							fetch next 1 row only)
		IF((select Discontinued from Products where ProductID = @pID) = 1 and (select UnitsInStock from Products where ProductID = @pID) < @Quantity )
		begin
			insert @output values (@pID, @Quantity, 'Produk Diskontinu')
		end
		ELSE IF((select UnitsInStock from Products where ProductID = @pID) < @Quantity)
		begin
			insert @output values (@pID, @Quantity, 'Stok tidak tersedia')
		end

		set @count += 1;
	end

	return

end



create proc TransaksiPembelian 
@CustomerID nchar(5),
@ShipperID int, 
@EmployeeID int,
@cart as CART readonly
as
begin

	declare @inserted as table(id int)
	-- input order
	insert into Orders
	output inserted.OrderID as id into @inserted
	values (
		@CustomerID,
		@EmployeeID,
		GETDATE(), --orderdate
		null, --RequiredDate
		null, -- ShippedDate
		@ShipperID, -- Shipvia
		null, --Freight
		(select ContactName from Customers where CustomerID = @CustomerID), --ShipName
		(select Address from Customers where CustomerID = @CustomerID), --ShipAddress
		(select City from Customers where CustomerID = @customerID), --ship city
		(select Region from Customers where CustomerID = @customerID), --ship region
		(select PostalCode from Customers where CustomerID = @customerID), -- ship postal code
		(select Country from Customers where CustomerID = @customerID) --ship country
	)

	declare @orderID int = (select id from @inserted)
	declare @rowcart int = (select COUNT(*) from @cart)

	declare @count int = 0
	declare @freight int = 0

	--input order detail
	while(@count > @rowcart)
	begin
	declare @pID int = (select productID from @cart
						order by productID
						offset @count rows
						fetch next 1 row only)

	declare @Quantity int = (select Quantity from @cart
							order by productID
							offset @count rows
							fetch next 1 row only)

	insert into [Order Details]
	values (
			@orderID,
			@pID,
			(select UnitPrice from Products where ProductID = @pID),
			@Quantity,
			0)


	--update stock product
	update Products set UnitsInStock = UnitsInStock - @Quantity
	where ProductID = @pID

	set @freight += @Quantity * 3;
	set @count += 1;
	end

	--isi ongkir
	update Orders set Freight - @freight
	where OrderID = @orderID

	--tampilkan row order
	select 'Transaksi Berhasil!' StatusOrder
	select * from Orders where OrderID = @orderID
	select * from [Order Details] where OrderID = @orderID

end

select * from Products

declare @cID nchar(5) = 'ANATR',
		@sID int = 1,
		@eID int = 5,
		@cart CART;

insert into @cart values 
(3, 1), 
(2, 2),
(1, 3);

exec addOrderDataCheckQtyFirst @cID, @sID, @eID, @cart

select * from Products









--2024-02-16

--Transaction
drop proc InsertCategory

create proc InsertCategory
(
	@categoryName varchar(15),
	@desc varchar(500)
) as
begin
	begin try
		begin transaction 

			insert into Categories(CategoryName, Description, Picture)
			values (@categoryName, @desc, null)

			/*Error*/
			select parse('ABC' as int)
		commit transaction 
	end try

	begin catch
		select 'error'
		Rollback transaction
	end catch
end

exec InsertCategory @categoryName = 'Test1', @desc = 'Test1'

select * from Categories

DELETE Categories
WHERE  CategoryID in (12,13)









--Trigger

insert into Categories(CategoryName, Description, Picture)
	values('Test 2', null, null)

Drop Trigger showCategoryAfterInsert

create Trigger showCategoryAfterInsert
on dbo.categories
after insert 
as
begin
	select * from Categories
end









--2024-02-16
--SPTTRANSAKSIPEMBELI
--REVAN

-- Tugas Membuat SP
-- Terjadinya transaksi pembelian (Proses),
-- Menerima siapa Pembelinya (Customer ID), Daftar barang apa yang mau dibeli
-- Keranjang kemarin --> Terima dalam bentuk Table
-- Jasa Pengirimannya Siapa (ShipperID)
-- Siapa Salesnya (EmplooyeID)

-- Dengan ketentuan harga ongkir diliat dari, Total qty * 3$ --> Harga untuk ongkir.

-- Jika transaksi gagal disalah satunya, transaksinya gaggal
-- SPnya mengeluarkan --> Produk mana yang gagal.
-- Tidak boleh
-- Check --> Discountinue dan 
-- Transaksi terjadi menambahkan "Pesan berhasil"
-- Dicontinue 

create function cek(@daftarbarang as CART readonly)
returns @resulttable table (Id int, Qty int, Pesan varchar(50))
as 
begin
	declare @index int = 1
	declare @totalbaris int = (select COUNT(ProductID) from @daftarbarang)

	while(@index <= @totalbaris)
	begin
	declare @id int = (select ProductID from @daftarbarang order by ProductID offset @index-1 rows fetch next 1 rows only)
	declare @qty int = (select Quantity from @daftarbarang order by ProductID offset @index-1 rows fetch next 1 rows only)

	IF((select UnitsInStock from Products where ProductID = @id) < @qty)
	begin
		IF((select Discontinued from Products where ProductID = @id) = 0)
		begin
			insert into @resulttable
			values
			(@id, @qty, 'Stock Habis')
		end
		else 
		begin
			insert into @resulttable
			values
			(@id, @qty, 'Produk Discontinue')
		end
	end

	set @index = @index + 1
	end

return
end

create procedure transpembelian(
@customerid varchar(10),
@employeeid int,
@shipperid int,
@daftarbarang CART readonly
)
as 
begin
-- check stock
IF((select count(1) from cek(@daftarbarang)) > 0)
begin
select * from cek(@daftarbarang)
return
end

-- add data order
declare @output as table (
OrderID int
)

insert into Orders
(CustomerID, EmployeeID, OrderDate, ShipVia, Freight)
OUTPUT INSERTED.OrderID as OrderID into @output
values
(@customerid, @employeeid, GETDATE(), @shipperid, (select (SUM(Quantity) * 3) from @daftarbarang))

declare @orderidbaru int = (select OrderID from @output)

-- add data order detail sejumlah row CART
declare @index int = 1
declare @totalbaris int = (select COUNT(ProductID) from @daftarbarang)
while(@index <= @totalbaris)
begin
declare @id int = (select ProductID from @daftarbarang order by ProductID offset @index-1 rows fetch next 1 rows only)
declare @qty int = (select Quantity from @daftarbarang order by ProductID offset @index-1 rows fetch next 1 rows only)

insert into [Order Details]
values
(@orderidbaru, @id, (select UnitPrice from Products where ProductID = @id), @qty, 0)
set @index = @index + 1
end

-- mengupdate table produk setelah di beli
update Products
set UnitsInStock = UnitsInStock - @qty
where ProductID = @id

-- menampilkan data order dan order detail yang sudah di tambah
select * from Orders where OrderID = @orderidbaru
select * from [Order Details] where OrderID = @orderidbaru
select * from [Order Details] as od
join Products as prod on od.ProductID = prod.ProductID
where OrderID = @orderidbaru
end


declare @cart as CART
insert into @cart values (1,10), (2,5), (3,3), (4,7)
exec transpembelian @customerid = 'VINET',  @employeeid = 1, @shipperid = 2, @daftarbarang = @cart










--2024-02-14
--calculateMaxItemsBought
--STAINLY

DROP FUNCTION MaxNumberOfProducts

CREATE FUNCTION MaxNumberOfProducts (
	@Budget MONEY
) RETURNS @Return TABLE (ProductID INT, Quantity INT)
BEGIN
	DECLARE @Index INT = 1,
			@TotalSpent MONEY = 0,
			@toAlter INT = 0

	DECLARE @TempTable TABLE (
		ProductID INT, 
		Quantity INT,
		UnitPrice MONEY, 
		[Total Price] MONEY
	)
	
	INSERT @TempTable
	SELECT
		ProductID,
		IIF(UnitsInStock >= 2, 2, 1),
		UnitPrice,
		IIF(UnitsInStock >= 2, UnitPrice * 2, UnitPrice) [Total Price]
	FROM Products
	WHERE Discontinued = 0 AND UnitsInStock > 0

	DECLARE @CurrTotal MONEY = 0,
			@TempIsolated MONEY = 0

	WHILE @TotalSpent < @Budget 
	BEGIN
		IF @Index > (SELECT COUNT(ProductID) FROM @TempTable)
		BEGIN
			BREAK
		END

		SET @CurrTotal = (SELECT SUM([Total Price]) FROM (SELECT TOP (@Index) * FROM @TempTable ORDER BY [Total Price] ASC) Src)
		IF @CurrTotal <= @Budget
		BEGIN
			SET @TotalSpent = @CurrTotal
			SET @Index += 1
		END
		ELSE
		BEGIN
			SET @TempIsolated = (SELECT UnitPrice FROM @TempTable ORDER BY [Total Price] ASC OFFSET (@Index - 1) ROWS FETCH NEXT 1 ROWS ONLY)
			IF @TotalSpent + @TempIsolated <= @Budget
			BEGIN
				SET @toAlter = 1
			END
			ELSE
			BEGIN
				SET @Index -= 1
			END
			BREAK
		END
	END

	INSERT @Return
	SELECT TOP (@Index) ProductID, 2 FROM @TempTable ORDER BY [Total Price] ASC 
		
	IF @toAlter = 1
	BEGIN
		UPDATE @Return
		SET Quantity = 1
		WHERE ProductID = (SELECT ProductID FROM @TempTable ORDER BY [Total Price] ASC OFFSET (@Index - 1) ROWS FETCH NEXT 1 ROWS ONLY)
	END
	RETURN
END

WITH TEST AS (
SELECT 
	R.ProductID, 
	R.Quantity, 
	P.UnitPrice, 
	R.Quantity * P.UnitPrice [Price Bought]
FROM dbo.MaxNumberOfProducts(260) R 
JOIN Products P 
	ON R.ProductID = P.ProductID
)

SELECT
	CONVERT(VARCHAR, ProductID),
	Quantity,
	[Price Bought]
FROM TEST
UNION ALL
SELECT
	'Total',
	0,
	SUM([Price Bought])
FROM TEST
UNION ALL
SELECT
	'Remainder',
	0,
	260 - SUM([Price Bought])
FROM TEST









