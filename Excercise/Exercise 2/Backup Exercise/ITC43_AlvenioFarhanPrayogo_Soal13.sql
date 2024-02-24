--13. Category price range.sql
--Ingin diketahui berapa harga termahal dan harga termurah product di setiap macam category product.
--Keluarkan informasi berupa nama kategori, harga product termahal di kategori ini, dan harga termurah 
--di category ini. (Note: tidak memperdulikan discount)

select * from Products
select * from Categories

select c.CategoryName , MAX(p.UnitPrice)HargaTermahal, MIN(p.UnitPrice)HargaTerendah
from Categories c
join Products p on c.CategoryID = p.CategoryID
group by c.CategoryName