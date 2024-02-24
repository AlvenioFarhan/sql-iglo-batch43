--9) Incoming Fee.sql
--Ingin diketahui jumlah total student fee yang sudah dibayar masuk ke kampus sampai dengan tanggal tertentu. 
--Buatlah fungsi yang menerima parameter tanggal, maka fungsi akan mengehitung dan mengeluarkan total hasil 
--perhitungan fee yang masuk sebelum tanggal tersebut.

select * from Enrollment

select SUM(e.Fee)
from Enrollment e
where e.Status = 'COM' and e.TransactionDate <= '2013-09-09 00:00:00.000'

drop function TotalIncome
create function TotalIncome(@tanggal date)
returns money as
begin

declare @total money

select @total = (
select SUM(e.Fee)
from Enrollment e
where e.Status = 'COM' and e.TransactionDate <= @tanggal
)

return @total
end

select dbo.TotalIncome('2013-09-09') JumlahStok
