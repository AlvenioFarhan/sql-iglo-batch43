--Tampilkan semua nama produk beserta harga satuan (UnitPrice) dari tabel Products.

select ProductName,UnitPrice
from Products

--Hitung total jumlah produk yang tersedia (UnitsInStock) untuk setiap kategori produk.

--select COUNT(ProductID) JumlahProduk
--from Products
--where UnitsInStock > 0

SELECT CategoryID, SUM(UnitsInStock) AS TotalUnitsInStock
FROM Products
GROUP BY CategoryID;

--Temukan nama dan alamat pelanggan yang berada di kota 'London'.

select ContactName, Address
from Customers
where City = 'London'

SELECT CompanyName, Address, City, Country
FROM Customers
WHERE City = 'London';


--Tampilkan nama-nama produk yang memiliki harga satuan (UnitPrice) di atas rata-rata harga satuan semua produk.

select ProductName, UnitPrice
from products
where UnitPrice > (select AVG(UnitPrice)Rata2
from Products)

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);



--Hitung total harga pesanan (dalam USD) untuk setiap pesanan, 
--dengan mempertimbangkan jumlah produk yang dibeli, harga satuan produk, dan diskon yang diberikan (jika ada).

select * from Orders
select * from [Order Details]

select OrderID, FORMAT(SUM(Quantity * (unitprice - (UnitPrice * Discount))), 'C' , 'en-US' )Total
from [Order Details] od
group by od.OrderID

SELECT OrderID, SUM(Quantity * (UnitPrice - (UnitPrice * Discount))) AS TotalOrderPrice
FROM [Order Details]
GROUP BY OrderID;




--Tampilkan daftar karyawan yang memiliki jabatan (Title) 'Sales Representative' dan berada di kota 'Seattle'.

select *
from Employees

select CONCAT(FirstName, ' ', LastName) FullName
from Employees
where Title = 'Sales Representative' and City = 'Seattle'

SELECT FirstName, LastName, City, Title
FROM Employees
WHERE Title = 'Sales Representative' AND City = 'Seattle';



--Temukan lima pelanggan dengan total nilai pesanan terbesar (dalam USD).

select * from Orders
select * from [Order Details]

select top 5 o.CustomerID, FORMAT(SUM(od.UnitPrice * od.Quantity), 'C', 'en-US') JumlahOrder
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
group by o.CustomerID
order by JumlahOrder desc

SELECT CustomerID, SUM(Quantity * (UnitPrice - (UnitPrice * Discount))) AS TotalOrderPrice
FROM [Order Details] od
join Orders o on od.OrderID = o.OrderID
GROUP BY CustomerID
ORDER BY TotalOrderPrice DESC
LIMIT 5;


--Hitung jumlah produk yang telah dihentikan (Discontinued) untuk setiap kategori produk.

select * from Products
select * from Categories

select CategoryID,  COUNT(ProductName) JumlahProduk 
from Products
where Discontinued = 1
group by CategoryID

SELECT CategoryID, COUNT(*) AS DiscontinuedProductsCount
FROM Products
WHERE Discontinued = 1
GROUP BY CategoryID;


--Tampilkan daftar produk yang masih tersedia di stok (UnitsInStock > 0) dan sedang tidak dalam proses pemesanan (UnitsOnOrder = 0).

select * from Products

select ProductName
from Products
where UnitsInStock > 0 and UnitsOnOrder = 0

SELECT ProductName, UnitsInStock, UnitsOnOrder
FROM Products
WHERE UnitsInStock > 0 AND UnitsOnOrder = 0;


--Temukan nama-nama produk yang dibeli oleh setiap pelanggan yang berada di kota 'Berlin', beserta jumlah produk yang dibeli.

select * from Products
select * from Customers
select * from [Order Details]
select * from Orders

select p.ProductName, c.CustomerID, c.ContactName, COUNT(o.OrderID)JumlahOrder
from Products p
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
join Customers c on o.CustomerID = c.CustomerID
where c.City = 'Berlin'
group by p.ProductName, c.CustomerID, c.ContactName


SELECT c.CompanyName, p.ProductName, od.Quantity
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE c.City = 'Berlin';









--Buatlah sebuah fungsi yang menghitung total harga pesanan (dalam USD) untuk sebuah pesanan tertentu, berdasarkan OrderID yang diberikan.

select * from Orders
select * from [Order Details]

drop function TotalHargaPesanan
create function TotalHargaPesanan (@id int)
returns money as
begin

declare @total money

select @total = (
select sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as TotalHarga
from [Order Details] od
where od.OrderID = @id
)

return @total
end

select dbo.TotalHargaPesanan(10248) as TotalOrder




--Buatlah sebuah fungsi yang menerima CustomerID sebagai parameter dan mengembalikan jumlah total pesanan (dalam USD) yang dibuat oleh pelanggan tersebut.

select * from Orders
select * from [Order Details]

select FORMAT(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)), 'C', 'en-US' ) as TotalOrder
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
where o.CustomerID = 'VINET'

drop function TotalPesanan
create function TotalPesanan (@id varchar(5))
returns money as
begin

declare @total money

select @total = (
select FORMAT(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)), 'C', 'en-US' ) as TotalOrder
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
where o.CustomerID = @id
)
return @total
end
select dbo.TotalPesanan('VINET') as Total	









--Buatlah sebuah prosedur penyimpanan untuk menambahkan produk baru ke dalam database, dengan parameter nama produk, harga, kategori, dan jumlah stok.

select * from Products

drop procedure AddNewProduct
CREATE PROCEDURE AddNewProduct(
    @product_name VARCHAR(50),
    @unit_price DECIMAL(10, 2),
    @category_id INT,
    @units_in_stock INT
)
as
BEGIN
    INSERT INTO Products (ProductName, UnitPrice, CategoryID, UnitsInStock)
    VALUES (@product_name, @unit_price, @category_id, @units_in_stock);
END;

execute AddNewProduct @product_name = 'Test', @category_id = 1, @unit_price = 30.60, @units_in_stock = 10

delete from Products
where ProductID = 78









--Buatlah sebuah fungsi yang menerima EmployeeID sebagai parameter dan mengembalikan jumlah total pesanan (dalam USD) yang diambil oleh karyawan tersebut.

select * from Employees
select * from [Order Details]
select * from Orders

select FORMAT(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)), 'C', 'en-US' ) as TotalPesanan
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
where e.EmployeeID = 1

drop function Pesanan
create function Pesanan (@id int)
returns money as
begin

declare @order money

select @order = (
select FORMAT(sum(od.UnitPrice * od.Quantity * (1 - od.Discount)), 'C', 'en-US' ) as TotalPesanan
from [Order Details] od
join Orders o on od.OrderID = o.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
where e.EmployeeID = @id
)

return @order
end

select dbo.Pesanan(1) as TotalPesanan









--Buatlah sebuah prosedur penyimpanan untuk mengubah alamat pelanggan berdasarkan CustomerID yang diberikan sebagai parameter.

select * from Customers

drop procedure UpdateAddress
CREATE PROCEDURE UpdateAddress(
    @IDCustomer VARCHAR(5),
    @Alamat Varchar(500)
)
as
BEGIN
    update Customers
	set Address = @Alamat
	where CustomerID = @IDCustomer
END;

execute UpdateAddress @IDCustomer = 'ALFKI' , @Alamat = 'Obere Str. 57'		









--Buatlah sebuah fungsi yang menerima ProductID sebagai parameter dan mengembalikan jumlah total produk yang terjual dari produk tersebut.

select * from Products
select * from [Order Details]

select sum(od.Quantity) TotalProdukTerjual
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
where p.ProductID = 11

drop function TotalProduk
create function TotalProduk(@id int)
returns int as
begin

declare @jumlah int

select @jumlah = (
select sum(od.Quantity) TotalProdukTerjual
from Products p 
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
where p.ProductID = @id
)

return @jumlah
end

select dbo.TotalProduk(11) as TotalProdukTerjual









--Buatlah sebuah prosedur penyimpanan untuk menghapus pesanan berdasarkan OrderID yang diberikan sebagai parameter.

select * from Orders
select * from [Order Details]

drop procedure DeleteDataOrder
create procedure DeleteDataOrder (
@orderID int
)
as 
begin

delete Orders
where OrderID = @orderID

delete [Order Details]
where OrderID = @orderID

end

execute DeleteDataOrder @orderID = 11087









--Buatlah sebuah fungsi yang menerima SupplierID sebagai parameter dan mengembalikan jumlah total produk yang disuplai oleh pemasok tersebut.

select * from Suppliers
select * from Products

select COUNT(ProductID) TotalProduk
from Products
where SupplierID = 1

drop function TotalProduk
create function TotalProduk(@id int)
returns int as
begin

declare @total int

select @total = (
select COUNT(ProductID) TotalProduk
from Products
where SupplierID = @id
)

return @total
end

select dbo.TotalProduk(1) TotalProduk









--Buatlah sebuah prosedur penyimpanan untuk mengupdate harga satuan (UnitPrice) dari sebuah produk berdasarkan ProductID yang diberikan sebagai parameter.

select * from Products

update Products
set UnitPrice = 90.00
where ProductID = 1

drop procedure UpdatePrice
create procedure UpdatePrice (
@productid int,
@harga money
)
as
begin

update Products
set UnitPrice = @harga
where ProductID = @productid

end

execute UpdatePrice @productid = 1, @harga = 18.00









--Buatlah sebuah fungsi yang menerima CategoryID sebagai parameter dan mengembalikan daftar produk 
--dalam kategori tersebut beserta jumlah total stok yang tersedia.

select * from Products

select SUM(UnitsInStock) JumlahStok
from Products
where CategoryID = 1

drop function CekStok
create function CekStok(@id int)
returns int as
begin

declare @cek int

select @cek = (
select SUM(UnitsInStock) JumlahStok
from Products
where CategoryID = @id
)

return @cek
end

select dbo.CekStok(1) JumlahStok