--Management ingin mengetahui rata-rata harga product-product per unitnya yang berasal dari supplier yang berada di negara-negara Eropa, yaitu 
--Germany, Spain, Sweden, Italy, Norway, Denmark, Netherland, Finland, dan France. Management ingin terus bekerja sama dengan supplier dari Eropa, 
--selama harga rata-rata productnya 50 dolar kebawah. Tunjukan harga rata-rata barang untuk setiap negara di Eropa, lalu tampilkan berurutan dari yang tertinggi 
--harga rata-ratanya sampai yang terendah, terkecuali yang harga rata-rata barangnya di atas 50 dollar.

use Northwind

select *
from Products

select *
from Suppliers;

select avg(pro.UnitPrice) RataRataHarga, sup.Country
from Products pro
join Suppliers sup on pro.SupplierID = sup.SupplierID
where sup.Country in ('Germany', 'Spain', 'Sweden', 'Italy', 'Norway', 'Denmark', 'Netherland', 'Finland', 'France')
group by sup.Country
having not avg(pro.UnitPrice) > 50
order by RataRataHarga desc
