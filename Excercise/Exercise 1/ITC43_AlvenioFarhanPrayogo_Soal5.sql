--Supervisor kalian yang ada di USA Branch, ingin agar salah satu karyawannya bertugas membawakan presentasi di USA. 
--Karyawannya harus yang sangat mengenal Amerika dan bagus bahasa inggrisnya, oleh karena itu harus yang berasal dari USA. 
--Ia ingin bertanya kepada setiap karyawannya yang ada di database via telphone. Jabarkanlah seluruh karyawan anda dengan nama lengkap dan title of 
--courseynya, beserta nomor telponnya.

use Northwind

select * 
from Employees

select CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) NamaLengkap, HomePhone
from Employees
where Country = 'USA'