--14) Completing Enrollment.sql
--Buatlah procedure yang bisa digunakan untuk menyelesaikan transaksi siswa yang masing pending di enrollment. 
--Procedure hanya akan meminta input parameter berupa payment method. Transaction date akan diambil dari hari ini, 
--atau hari saat procedure ini dijalankan dan feenya akan disesuaikan dengan harga subject saat ini.

select * from Subject
select * from Competency
select * from Period
select * from Enrollment

select * from Enrollment
where Status = 'PEN'

select s.Name as SubjectName, SUM(s.Cost)TotalPembayaran
from Subject s
join Competency c on s.ID = c.SubjectID
join Period p on c.ID = p.CompetencyID
join Enrollment e on p.ID = e.PeriodID
where e.Status = 'PEN' and e.PeriodID = 160
group by s.Name

drop procedure CompletingEnrollment
create procedure CompletingEnrollment(@MethodPembayaran varchar(2))
as 
begin

declare @date date

set @date = GETDATE()

update Enrollment
set TransactionDate = @date,
	Fee = (
	SELECT s.Cost FROM Subject s
	join Competency c on s.ID = c.SubjectID
	join Period p on c.ID = p.CompetencyID
	join Enrollment e on p.ID = e.PeriodID
	WHERE s.ID = e.ID
	),
	Status = 'COM'
	where Status = 'PEN'

end

execute CompletingEnrollment @MethodPembayaran = 'BT'