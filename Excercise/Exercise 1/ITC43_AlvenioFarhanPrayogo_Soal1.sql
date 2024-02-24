--Manajemen ingin tahu perusahaan shipper mana yang paling populer dan yang paling mengantarkan banyak order 
--di sepanjang masa. Keluarkan nama 1 perusahaan shipper yang paling populer dengan total ordernya.

use Northwind

select * 
from Shippers

select *
from Orders

select top 1 CompanyName PerusahaanPopular , count(ShipVia) TotalOrder
from Orders, Shippers
where ShipVia = ShipperID
group by CompanyName
order by count(ShipVia) desc
