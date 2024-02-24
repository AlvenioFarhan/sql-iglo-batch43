use Sekolah

declare @dafarguru table = (
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru
)

select @daftarguru

--membuat variable tabel baru, lawan dari temp table
--semua ada plus minusnya
create type HonorGuru as table (
NIP varchar(10),
NamaLengkap varchar(100),
IsHonorer bit,
Gaji money,
Tunjangan money
)

declare @daftarGuru as HonorGuru


declare @daftarGuru as HonorGuru = (
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru
)

insert into @daftarGuru
values ('432912', 'Alvenio Farhan', 1, 5000000, 0)


insert into @daftarGuru
select NIP, NamaLengkap, IsHonorer, Gaji,Tunjangan
from Guru

select * from @daftarGuru






--PIVOT DINAMIS

declare @queryString varchar(max);
declare @columnPivot varchar(max);

select @columnPivot = CONCAT(@columnPivot, '[', CategoryName, '], ')
from Northwind.dbo.Categories
where CategoryID % 2 = 0

--Bisa Juga memakai
--select @columnPivot = CONCAT(@columnPivot, QUOTENAME(CategoryName), ', ')
--from Northwind.dbo.Categories
--where CategoryID % 2 = 0

set @queryString='
select * from (
select s.CompanyName as SupplierName,
c.CategoryName, p.ProductID
from Northwind.dbo.Products p
join Northwind.dbo.Suppliers s on p.SupplierID=s.SupplierID
join Northwind.dbo.Categories c on p.CategoryID=c.CategoryID
)tbl
pivot(count(tbl.ProductID) for CategoryName in (' + LEFT(@ColumnPivot, LEN(@columnpivot)-1) +'))pvt
'
--execute/exec
exec (@queryString)

--end

--select * from (
--select s.CompanyName as SupplierName,
--c.CategoryName, p.ProductID
--from Northwind.dbo.Products p
--join Northwind.dbo.Suppliers s on p.SupplierID=s.SupplierID
--join Northwind.dbo.Categories c on p.CategoryID=c.CategoryID
--)tbl
--pivot(count(tbl.ProductID) for CategoryName in (' + LEFT(@ColumnPivot, LEN(@columnpivot)-1)+'))pvt





