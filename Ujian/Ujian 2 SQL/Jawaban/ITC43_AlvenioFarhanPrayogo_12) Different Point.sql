--12) Different Point.sql
--Setiap major atau jurusan terdiri dari beberapa subject / mata pelajaran. Setiap major memiliki total credit point, 
--dimana seharusnya total credit point milik major adalah penjumlahan dari semua credit point milik subject. 
--Tapi kenyataannya tidak selalu begitu, di sini ada perbedaan antara total credit point milik major dan total penjumlahan 
--credit point milik subject. Buatlah list major dengan total credit pointnya, lalu buatlah perbandingan antara total credit point 
--milik major dengan credit point subject.
--Contohnya:
--Major Name	Total Credit Point	Different with subject
--Major 1	48	24
--Major 2	48	-12
--Ini berarti total point subject dari Major 1 lebih 24 point dari total credit point majornya (berarti total credit point 
--subject Major 1 adalah 72) dan Subject dari Major 2 totalnya hanya 36.


select * from Major
select * from Subject


select s.MajorID, SUM(s.CreditPoint) CreditPoint
from Subject s
group by s.MajorID

select m.Name, m.TotalCreditPoint,
		m.TotalCreditPoint - 
							(select SUM(s.CreditPoint) CreditPoint
							from Subject s where s.MajorID = m.ID
							group by s.MajorID) PerbedaanPoint
from Major m