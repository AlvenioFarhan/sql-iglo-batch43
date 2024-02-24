--10) Major Total Cost.sql
--Ingin diprediksi oleh setiap siswa, apabila mereka mengambil seluruh subject pada satu major, 
--berapa biaya total biaya yang harus diambilnya. Tampilkan; Rank, Major Name, Major Type dan Total Cost.
--Buatlah nomor ranking, apabila ada major dengan harga yang sama, maka dia akan menduduki peringkat yang sama.
--(Note: Major Type harus ditampilkan yang lengkap, apakah Full Major, Sub Major, atau Elective)


select * from Major
select * from Subject


select	RANK() over (order by sum(s.Cost) desc) RANK,
		m.Name,
		CASE
           WHEN m.Type = 'FM' THEN 'Full-Major'
           WHEN m.Type = 'SM' THEN 'Sub-Major'
           WHEN m.Type = 'EL' THEN 'Elective'
           ELSE 'TidakDiketahui'
       END AS Type,
		SUM(s.Cost) TotalCost
from Major m
join Subject s on m.ID = s.MajorID
group by m.name, Type
order by TotalCost desc
