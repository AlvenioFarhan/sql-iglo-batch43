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