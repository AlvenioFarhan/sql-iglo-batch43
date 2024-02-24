
-- buatlah fungsi untuk keluarkan daftar produk apa saja yang bisa dibeli dengan uang
-- maksimal membeli 2 quantity pada satu produk 

use Northwind
go

create view View_ProductTemp as(
	select ROW_NUMBER() OVER (ORDER BY pro.UnitPrice, pro.UnitsInStock desc) RowNumber, pro.ProductID, 
		pro.UnitPrice, pro.UnitsInStock
	from Products pro
	where pro.Discontinued = 0 and pro.UnitsInStock > 0
);

go

--select * from View_ProductTemp
--drop view View_ProductTemp

create function CariBarang (@uang as money)
returns @resultTable Table (
	ProductId int,
	Quantity int,
	SisaUang money
)
as
begin
	declare @i int = 1;
	
	while(@uang >= 0 and @i <= (select max(RowNumber) from Northwind.dbo.View_ProductTemp))
	begin 
		declare @Id int = (select vp.ProductID from View_ProductTemp vp where vp.RowNumber = @i)
		declare @pricePerProduct money = (select vp.UnitPrice from View_ProductTemp vp where vp.RowNumber = @i)
		declare @stock int = (select vp.UnitsInStock from View_ProductTemp vp where vp.RowNumber = @i)
		
		if ( (@uang >= @pricePerProduct * 2) and (@stock >= 2) )
		begin
			set @uang -= @pricePerProduct * 2
			insert into @resultTable values (@Id, 2, @uang)
			set @i += 1
		end

		else if ((@uang >= @pricePerProduct * 1) and (@stock >= 1))
		begin
			set @uang -= @pricePerProduct * 1
			insert into @resultTable values (@Id,1, @uang)
			set @i += 1
		end

		else
		begin
			set @i += 1
		end
	end
	return
end

--drop function CariBarang

go

declare @uang int = 100
select * from CariBarang(@uang)



