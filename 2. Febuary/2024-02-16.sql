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