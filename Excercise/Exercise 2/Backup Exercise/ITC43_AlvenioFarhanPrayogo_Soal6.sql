--6. Region data.sql
--Atasan ingin mengetahui data jumlah territory dan jumlah karyawan yang bekerja di satu Region.
--Tolong buatlah laporan berupa, nama region, jumlah territory di dalam region tersebut dan jumlah 
--karyawan yang di assign pada region tersebut.

select * from Territories
select * from Employees
select * from EmployeeTerritories
select * from Region

select r.RegionDescription, count(t.TerritoryID)JumlahTerritory, count(distinct e.EmployeeID)JumlahKaryawam
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
join Region r on t.RegionID = r.RegionID
group by r.RegionDescription