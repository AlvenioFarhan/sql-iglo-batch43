drop procedure ShipperExperience

alter procedure ShipperExperience (@1996 int)
as
begin

select *
from(
select c.CategoryName, s.CompanyName, sum(od.Quantity) Jumlah
from Categories c
join Products p on c.CategoryID = p.CategoryID
join [Order Details] od on p.ProductID = od.ProductID
join Orders o on od.OrderID = o.OrderID
join Shippers s on o.ShipVia = s.ShipperID
where YEAR(o.ShippedDate) = 1996
group by c.CategoryName, s.CompanyName
) as tbl
pivot(
sum(Jumlah) for CompanyName in ([Speedy Express], [United Package], [Federal Shipping])
) pvt

end

EXEC ShipperExperience 1996







drop procedure showInvoice

alter procedure showInvoice (@show varchar(max))
as
begin

select concat(DATENAME(DAY, o.OrderDate),' ',DATENAME(Month, o.OrderDate),' ', DATENAME(YEAR, o.OrderDate)) OrderDate, 
		c.ContactName, 
		CONCAT( e.FirstName, ' ', e.LastName) Salesman, 
		s.CompanyName,
		concat(DATENAME(DAY, o.ShippedDate),' ',DATENAME(Month, o.ShippedDate),' ', DATENAME(YEAR, o.ShippedDate)) ShipDate,
		format(sum(((od.Quantity*od.UnitPrice)- ((od.Quantity*od.UnitPrice)* od.Discount))) + o.Freight, 'C', 'en-US') TotalCost
	 --Format(sum(( (1 - od.Discount) * od.UnitPrice * od.Quantity)) + o.Freight, 'C', 'en-US' )TT
from Orders o
join Customers c on o.CustomerID = c.CustomerID
join Employees e on o.EmployeeID = e.EmployeeID
join Shippers s on o.ShipVia = s.ShipperID
join [Order Details] od on o.OrderID = od.OrderID
where o.OrderID = 10263
group by 
concat(DATENAME(DAY, o.OrderDate),' ',DATENAME(Month, o.OrderDate),' ', DATENAME(YEAR, o.OrderDate)),
c.ContactName,
CONCAT( e.FirstName, ' ', e.LastName),
s.CompanyName,
concat(DATENAME(DAY, o.ShippedDate),' ',DATENAME(Month, o.ShippedDate),' ', DATENAME(YEAR, o.ShippedDate)),
o.Freight

select p.ProductName, s.CompanyName, od.Quantity, od.UnitPrice,
	FORMAT(((od.Quantity*od.UnitPrice)- ((od.Quantity*od.UnitPrice)* od.Discount)), 'C', 'en-US') Total
from Orders o 
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Suppliers s on p.SupplierID = s.SupplierID
where o.OrderID = 10263

end

EXEC showInvoice show











CREATE TYPE dbo.Cart AS TABLE
(
	ProductID INT NOT NULL primary key,
	Quantity INT NOT NULL
);



create procedure TransaksiOrder (
@customerID int,
@employeeID int,
@shipperID int,
@cart as CART readonly
)
as
begin
begin try
		begin transaction



		commit transaction 
end try

	begin catch
		select 'error'
		Rollback transaction
	end catch
end