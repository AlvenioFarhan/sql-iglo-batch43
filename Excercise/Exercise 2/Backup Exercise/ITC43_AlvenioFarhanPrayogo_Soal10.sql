--10. Region total sales.sql
--Ingin diketahui total penjualan yang dihasilkan oleh setiap Region tempat employee ditugaskan.
--Keluarkan informasi berupa nama region (region description) dengan total penjualannya.
--Berapa untuk Eastern, Western, Northern dan Southern. (Note: tidak memperdulikan discount)

select * from Region
select * from Employees
select * from Orders
select * from [Order Details]

select r.RegionDescription, sum(od.UnitPrice * od.Quantity)TotalPenjualan
from Region r
join Territories t on r.RegionID = t.RegionID
join EmployeeTerritories et on t.TerritoryID = et.TerritoryID
join Employees e on et.EmployeeID = e.EmployeeID
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = od.OrderID
group by r.RegionDescription