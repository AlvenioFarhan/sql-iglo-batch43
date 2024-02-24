drop function checkStock

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







drop proc addOrderDataCheckQtyFirst

create PROC addOrderDataCheckQtyFirst
	@customerID as nchar(5),
	@shipperID as int, 
	@employeeID as int, 
	@cart as CART readonly
AS
BEGIN
	if((select count(*) from dbo.checkStock(@cart)) != 0)
	begin
		select * from dbo.checkStock(@cart)
		return
	end
	
	declare @inserted as table(id int)

	--input orders
	insert into Orders
	output INSERTED.OrderID as id into @inserted
	VALUES ( 
		@customerID,
		@employeeID,
		GETDATE(), -- orderdate
		null, --required date
		null, --shipped date
		@shipperID, --shipvia
		null, --freight
		(select ContactName from Customers where CustomerID = @customerID), --shipName
		(select Address from Customers where CustomerID = @customerID), --ship address
		(select City from Customers where CustomerID = @customerID), --ship city
		(select Region from Customers where CustomerID = @customerID), --ship region
		(select PostalCode from Customers where CustomerID = @customerID), -- ship postal code
		(select Country from Customers where CustomerID = @customerID) --ship country
	);

	declare @orderId int = (select id from @inserted)

	declare @rowCart int = (select count(*) from @cart)

	declare @count int = 0;
	declare @freight int = 0;

	--input order detail sesuai total row cart
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
		insert into [Order Details]
		values (@orderId, 
				@pID, 
				(select unitPrice from Products where ProductID = @pID),
				@Quantity,
				0);
		
		--update stock produk
		update Products set UnitsInStock = UnitsInStock - @Quantity
			where ProductID = @pID

		set @freight += @Quantity * 3;
		set @count += 1;
	end

	--isi ongkir
	update Orders set Freight = @freight
	where OrderID = @orderId

	--tampilkan row order
	select 'Transaksi Berhasil YEY!' [Status]
	select * from Orders where OrderID = @orderId
	select * from [Order Details] where OrderID = @orderId

END

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