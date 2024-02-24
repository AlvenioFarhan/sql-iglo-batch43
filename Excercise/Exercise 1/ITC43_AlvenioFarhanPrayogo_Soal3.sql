--Kerugian di sisi penjualan bisa disebabkan oleh banyak scenario, salah satunya adalah kerusakaan product-product di tempat penyimpanan, terutama barang pecah belah. 
--Beberapa kemasan product-product ini memang mudah pecah, karena sebagian terbuat dari glasses (gelas kaca), bottle (botol), dan jars (toples). 
--Karena itu management membuatkan lemari penyimpanan baru yang lebih aman untuk barang pecah belah, tetapi management kesulitan untuk menetukan 
--barang yang mana yang harus di simpan lemari yang aman ini. Buatlah laporan dengan informasi nama product, nama perusahaan supplier, nama category, 
--jumlah quantity dalam kemasan dan unit in stock di penyimpanan, dimana semua barang tersebut memiliki kemasan pecah belah berupa gelas kaca, botol atau toples.

use Northwind

select *
from Products

select *
from Suppliers

select *
from Categories


select pro.ProductName, sup.CompanyName, cat.CategoryName, pro.QuantityPerUnit, pro.UnitsInStock
from Products pro
join Suppliers sup on pro.SupplierID = sup.SupplierID
join Categories cat on pro.CategoryID = cat.CategoryID
where pro.QuantityPerUnit like '%bottle%' or pro.QuantityPerUnit like '%glass%' or pro.QuantityPerUnit like '%jar%'


