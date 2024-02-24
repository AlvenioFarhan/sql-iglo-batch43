--17) Expensive Showoff.sql

;with RankSuppliers as (
select s.CompanyName, rank() over ( order by max(p.unitprice)desc) 'RankSuppliers'
from Suppliers s
join Products p on s.SupplierID = p.SupplierID
--join [Order Details] od on p.ProductID = od.ProductID
group by s.CompanyName
),
RankProduk as (
select s.CompanyName, p.ProductName, p.UnitPrice,
RANK() over (partition by s.companyname order by max(p.unitprice)desc) 'RankProduk'
from Suppliers s
join Products p on s.SupplierID = p.SupplierID
--join [Order Details] od on p.ProductID = od.ProductID
group by s.CompanyName, p.ProductName, p.UnitPrice
)
select rs.CompanyName, rs.RankSuppliers, rp.ProductName, rp.UnitPrice
from RankSuppliers rs
join RankProduk rp on  rs.CompanyName = rp.CompanyName
order by rp.UnitPrice desc, rp.ProductName asc












--18) Reordering Calculator.sql
drop function reorderCalculator
alter function reorderCalculator ()
returns money as
begin

--select * from Products

declare @hargaPembayaran money

select @hargaPembayaran = sum(ReorderLevel * UnitPrice)
from Products

return @hargaPembayaran
end

select dbo.reorderCalculator() as HasilTotalReorder









--19) Count Meat Order.sql

select * from Categories
select * from Products
select * from Orders

drop function CountMeatOrder
create function CountMeatOrder (@year as int)
returns int as
begin

declare @JumlahOrder int

select @JumlahOrder = (
select count(distinct o.OrderID) JumlahOrder
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Categories c on p.CategoryID = c.CategoryID
where c.CategoryName = 'Meat/Poultry' and YEAR(o.OrderDate) = @year
)

return @jumlahOrder
end

select dbo.CountMeatOrder(1996) as JumlahOrder










--20) Salesman Performance.sql

select * from Employees
select * from Orders
select * from [Order Details]

select sum(od.UnitPrice * od.Quantity) * 0.1  as TotalBonus
from Orders o
join Employees e on o.EmployeeID = e.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where YEAR(o.OrderDate) = 1996 and e.EmployeeID = 1

drop function BonusPerformance
create function BonusPerformance (@ID int, @year int)
returns money as
begin

declare @bonus money

select @bonus = (
select sum(od.UnitPrice * od.Quantity) * 0.1  as TotalBonus
from Orders o
join Employees e on o.EmployeeID = e.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
where YEAR(o.OrderDate) = @year and e.EmployeeID = @ID
)
return @bonus
end

select dbo.BonusPerformance(1, 1996) as Bonus









--21) Total Quantity Product Sold.sql

select * from Orders
select * from [Order Details]
select * from Products

select SUM(od.Quantity) TotalQuantity
from [Order Details] od
join Products p on od.ProductID = p.ProductID
join Orders o on od.OrderID = o.OrderID
where MONTH(o.OrderDate) = 07 and YEAR(o.OrderDate) = 1996 and p.ProductID = 2


drop function TotalQuantity
create function TotalQuantity (@ID int, @month int, @year int)
returns int as
begin

declare @total int

select @total = (
select SUM(od.Quantity) TotalQuantity
from [Order Details] od
join Products p on od.ProductID = p.ProductID
join Orders o on od.OrderID = o.OrderID
where MONTH(o.OrderDate) = @month and YEAR(o.OrderDate) = @year and p.ProductID = @ID
)

return @total
end

select dbo.TotalQuantity(2,7, 1996) as Bonus









--22) Income Fluctuation.sql

select * from Orders
select * from [Order Details]

SELECT 
    o.OrderDate as TanggalSekarang,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSekarang,
	LAG(o.OrderDate) OVER (ORDER BY o.OrderDate) TanggalSebelumnya,
    SUM(UnitPrice * od.Quantity * (1 - od.Discount)) - LAG(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) OVER (ORDER BY o.OrderDate) AS TotalSebelumnya
FROM 
    Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY 
    OrderDate;

