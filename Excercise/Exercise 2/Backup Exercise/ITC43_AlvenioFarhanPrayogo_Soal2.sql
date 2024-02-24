--2. Employee total territory.sql
--HRD ingin mengetahui seberapa sibuk setiap karyawan yang ada di dalam northwind. Oleh karena itu 
--buatlah query yang mengeluarkan laporan nama lengkap karyawan dan berapa jumlah territory yang 
--ditugaskan pada employee tersebut. (Note: territory tempat dia ditugaskan)

select * from Employees
select * from EmployeeTerritories
select * from Territories

select CONCAT(e.FirstName, ' ', e.LastName)NamaLengkap, COUNT(et.TerritoryID)JumlahTerritory
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
group by e.FirstName, e.LastName