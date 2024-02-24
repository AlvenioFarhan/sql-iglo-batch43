--Ingin diketahui seluruh Territory penjualan, beserta nama lengkap karyawan yang bekerja di territory tersebut. 
--Baik ada ataupun tidak ada karyawan, territory description harus tetap ditunjukan.

use Northwind

select *
from Employees

select *
from EmployeeTerritories

select *
from Territories

select CONCAT(TitleOfCourtesy,' ',FirstName, ' ', LastName) NamaLengkap
from Employees

 select CONCAT(emp.TitleOfCourtesy,' ',emp.FirstName, ' ', emp.LastName) NamaLengkap, ter.TerritoryDescription
 from EmployeeTerritories et
 right join Territories ter on ET.TerritoryID = ter.TerritoryID
 join Employees emp on et.EmployeeID = emp.EmployeeID