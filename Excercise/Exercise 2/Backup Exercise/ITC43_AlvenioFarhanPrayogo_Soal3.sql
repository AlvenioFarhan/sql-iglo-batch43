--3. Total reorder cost.sql
--Ingin diketahui berapa banyak total biaya yang harus dikeluarkan untuk rencana pembelian barang di 
--setiap category barang. Jumlah quantity rencana pembelian product di informasikan di angka Reorder 
--Level. Pada northwind tidak diberikan informasi harga jual dan harga beli barang secara berbeda, 
--sehingga harga jual dan harga beli di anggap sama, yaitu Unit Pricenya. Laporan yang diminta adalah, 
--nama kategori, dan total biaya pembelian berikutnya (Reorder).

select * from Categories
select * from Products

select c.CategoryName, sum(p.UnitPrice * p.ReorderLevel)TotalBiayaReorder
from Categories c
join Products p on c.CategoryID = p.CategoryID 
group by c.CategoryName
