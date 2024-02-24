--15. Order without discount.sql
--Hitung berapa jumlah order yang ada di dalam northwind, dimana order tersebut tidak ada discount 
--sama sekali di dalamnya. Hasil yang diinginkan hanya 1 angka jumlah order tersebut

select * from [Order Details]
select * from Orders

select COUNT(tbl.OrderID) JumlahOrder
from (
select od.OrderID, SUM(Discount) Diskon
from [Order Details] od
group by od.OrderID
) tbl
where Diskon = 0