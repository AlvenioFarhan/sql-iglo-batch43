--bikin satu sp untuk proses terjadinya transaksi pembelian
--pakai custumer id saja, daftar barang apa yang mau dibeli
--pakai cart, jasa pengiriman siapa pakai id,siapa selesnya
--dengan harga ongkirnya dilihat dari totalquantity dikali 3 dolar

drop proc OrderTrans

create proc OrderTrans
	@keranjang  CART readonly,
	@IdEmp int,
	@IdCos nchar(5),
	@IdShipp int
as
begin
	declare @tableBerhasi TABLE (
	ProductID int,
	Quantity int,
	UnitPrice money
	)
	declare @tableGagal TABLE (
	ProductID int,
	pesan varchar(max)
	)
	declare @up money = 3,
			@index int = 1,
			@idProd int,
			@Berhasil bit
	declare @Ongkir money = (Select sum(Quantity*@up) from @keranjang),
			@bnyakBar int = (Select count(0) from @keranjang)
	declare @Shipname varchar(50) = (select CompanyName from Customers where CustomerID = @IdCos)
	declare @ShipAdres varchar(50) = (select c.Address from Customers c where CustomerID = @IdCos)
	declare @ShipCity varchar(50) = (select c.City from Customers c where CustomerID = @IdCos)
	declare @ShipRegion varchar(50) = (select c.Region from Customers c where CustomerID = @IdCos)
	declare @ShipPostal varchar(50) = (select c.PostalCode from Customers c where CustomerID = @IdCos)
	declare @ShipCounty varchar(50) = (select c.Country from Customers c where CustomerID = @IdCos)
	declare @waktusekarang datetime = getdate()
	while (@index <= @bnyakBar)
	begin
		set @idProd = (select productID from @keranjang
						order by productID
						offset @index-1 rows
						fetch next 1 rows only
						)
		declare @stokPro int = (
								select UnitsInStock from Products p
								where ProductID = @idProd
								)
		declare @discostinued bit = (
								select Discontinued from Products p
								where ProductID = @idProd
									)
		declare @unitPrice bit = (
								select UnitPrice from Products p
								where ProductID = @idProd
									)
		declare @qttpes int = (Select Quantity from @keranjang where productID= @idProd)

		if(@stokPro >0 or @discostinued = 0 )
		begin 
			if (@stokPro >= @qttpes)
			begin
				insert into @tableBerhasi
				values (@idProd,@qttpes,@unitPrice)
				set @Berhasil = 1
			end
			else
			begin
			if (@discostinued = 1)
			begin
				insert into @tableGagal
				values (@idProd,'Product Discontinui dan Pesanan Melebihi Stok Produk')
				set @Berhasil = 0
			end
			else
			begin
				insert into @tableGagal
				values (@idProd,'Pesanan Melebihi Stok Produk')
				set @Berhasil = 0
			end
			end 
		end
		else 
		begin
				insert into @tableGagal
				values (@idProd,'Product Discontinui dan Stok tidak ada')
				set @Berhasil = 0
		end
		
		set @index = @index + 1
	end 

	if(@Berhasil =1)
	begin
		insert into dbo.Orders
		(CustomerID,EmployeeID,OrderDate,ShipVia, Freight, 
		ShipName, ShipAddress, ShipCity,ShipRegion, ShipPostalCode, ShipCountry)
		values (@IdCos,@IdEmp,@waktusekarang,@IdShipp,@Ongkir,@Shipname,@ShipAdres,@ShipCity
				,@ShipRegion,@ShipPostal,@ShipCounty)
		declare @OrderID int = (select OrderID from Orders o
								where CustomerID = @IdCos and EmployeeID = @IdEmp 
								and OrderDate = @waktusekarang
								)
		insert into dbo.[Order Details]
		(OrderID, ProductID, UnitPrice, Quantity, Discount)
		select @OrderID,tb.ProductID, tb.UnitPrice, tb.Quantity,0 from @tableBerhasi tb
		declare @berhasilRow int = (select count(0)
									from @tableBerhasi
									),
				@inBerhasil int = 1

		while (@inBerhasil <= @berhasilRow)
		begin
			declare @idProdberhsil int = (select ProductID from @tableBerhasi
						order by ProductID
						offset @inBerhasil-1 rows
						fetch next 1 rows only
						)
			declare @qttberhasil int = (Select Quantity from @tableBerhasi where ProductID = @idProdberhsil)

			update Products
			set UnitsInStock = UnitsInStock - @qttberhasil
			where ProductID = @idProdberhsil

			set @inBerhasil += 1
		end

		select * from @tableBerhasi
	end
	else 
	begin
		select * from @tableGagal
	end
end




 declare @ker as cart 
 insert into @ker values (5,1), (4,1), (3,999)
 exec OrderTrans @keranjang = @ker, 	@IdEmp = 1,
	@IdCos = 'ALFKI',
	@IdShipp = 1

drop proc OrderTrans


--select * from Shippers
select * from Orders o
join [Order Details] od on o.OrderID = od.OrderID
order by OrderDate desc
--select * from Customers
--select * from [Order Details]
--select * from Products

select GETDATE()
select GETDATE()