--6) Previous Grade.sql
--Team pengurus applicant ingin mengetahui tinggi rendahnya nila rata-rata di setiap institusi pendidikan(sekolah/universitas) siswa sebelumnya. 
--Hitung rata-rata nilai siswa yang dikelompokan berdasarkan institusinya.

select * from EducationHistory

select distinct eh.Institution Institution,
		AVG(eh.Grade) Ratarata
from EducationHistory eh
group by eh.Institution