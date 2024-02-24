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
