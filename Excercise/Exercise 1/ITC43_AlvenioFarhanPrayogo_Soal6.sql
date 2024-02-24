--Gudang penyimpanan memiliki banyak section, dan tidak semua section memiliki besar ruang dan luas yang sama. Di antara beberapa section tersebut ada 
--2 ruangan yang paling kecil. Stock dan warehouse management ingin membagi setiap section untuk setiap category product, 
--sehingga satu macam category akan di kelompokan dan di simpan dalam satu section. Management ingin mengetahui, 2 category product yang 
--jumlah unit in stocknya paling sedikit, untuk disimpan pada 2 ruangan section yang paling kecil juga, agar menghemat tempat. Tunjukan 2 Category 
--beserta total unit in stocknya yang jumlahnya paling sedikit kepada management.

use Northwind

select *
from Products

select *
from Categories

select top 2 cat.CategoryName, sum(prod.UnitsInStock) TotalUnit
from Categories cat
join Products prod on cat.CategoryID = prod.CategoryID
where prod.UnitsInStock > 0
group by cat.CategoryName
order by TotalUnit
