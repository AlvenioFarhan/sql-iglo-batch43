--23) Cost Changes.sql
--Terkadang harga setiap subject bisa berubah, ada yang naik dan ada yang turun. Naik turunnya harga sebuah subject bisa dilihat 
--pada data enrollment, fee yang dibayar oleh siswa adalah harga subject pada saat enrollment dibayar (transaction date), 
--harga subject pada subject master data adalah harga saat ini. List seluruh subject yang mengalami perubahan harga sesuai 
--dengan data pada enrollment. Keluarkan informasi dalam; Subject Code, Subject Name, Current Price (harga sekarang), 
--Transaction Date, Price on Transaction (harga pada saat transaksi)

select * from Subject
select * from Enrollment

select s.Code SubjectCode, s.Name SubjectName, s.Cost AS HargaTerbaru, e.TransactionDate, e.Fee AS HargaLampauTransaksi,
		IIF(s.cost > e.fee, 'Harga Naik', 'Harga Turun') StatusHarga
from Enrollment e
join Period p on e.PeriodID = p.ID
join Competency c on p.CompetencyID = c.ID
join Subject s on c.SubjectID = s.ID
where s.Cost != e.Fee
