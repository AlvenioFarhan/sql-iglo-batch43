use Unicorn

drop function HitungCostKenaikan
create function HitungCostKenaikan(
	@totalloop int,
	@cost money,
	@persentase decimal
)
returns money
as
begin
	declare @result money = @cost

	while (@totalloop > = 1)
	begin
		set @result = @result + (@result * @persentase / 100)
		set @totalloop -= 1
	end

	return @result
end

drop type ListCode
create type ListCode as Table
(
	code varchar(10) 
);



declare @studentnumber as varchar(20) = '2012/01/0002',
	    @subjectcode as listcode

insert into @subjectcode 
values ('48024'),('31251'),('41025')



;with tableSubjectEnroll as(
select e.StudentNumber, c.SubjectID, sj.Code, count(1) TotalSubjectBerapaKali, dbo.HitungCostKenaikan(count(1), sj.Cost, 10) CostKenaikan
from Enrollment e
join Period p on e.PeriodID=p.id
join Competency c on p.CompetencyID=c.ID
join subject sj on c.SubjectID=sj.ID
where e.Status = 'com'
and e.StudentNumber = @studentnumber and sj.Code in (select code from @subjectcode)
group by e.StudentNumber, c.SubjectID, sj.Code, sj.Cost
), tbl2 as (
select @studentNumber as studentNumber, s.Code, s. Cost
from Subject s
where s.Code in (select Code from @subjectCode)
and s.Code not in (select Code from tableSubjectEnroll)
)
select tblAkhir.studentNumber, SUM(tblAkhir.Cost) Total 
from (
select * 
from tbl2
union
select s.StudentNumber, s.Code, s.CostKenaikan as Cost 
from tableSubjectEnroll s
) tblAkhir
group by tblAkhir.studentNumber



select * from Period
where EndDate is null

select * from EducationHistory









--keluarkan berapa banyak uang total dibuat untuk membayar pajak tutor
--pajak total dalam setahun naik 3%

select * from Tutor

--jarak waktu kerja
select DATEDIFF(MONTH, t.HireDate, '2010-12-01')
from Tutor t

--totalGajiBulanan
select t.BasicSalary + (t.BasicSalary * t.Allowance) TotalGaji
from Tutor t

select 
		CASE 
            WHEN t.EmployeeType in ('CA', 'PC') THEN  (t.BasicSalary + (t.BasicSalary * t.Allowance)) * 2
            ELSE (t.BasicSalary + (t.BasicSalary * t.Allowance)) * 1
		END AS GajiBulanan
from Tutor t


--gaji akhir pertahun+pajak
;with tblGajiBulanan as (
		
		select 
		CASE 
            WHEN t.EmployeeType in ('CA', 'PC') THEN  (t.BasicSalary + (t.BasicSalary * t.Allowance)) * 2
            ELSE (t.BasicSalary + (t.BasicSalary * t.Allowance)) * 1
		END AS GajiBulanan
		from Tutor t

)
select format((GajiBulanan * 12), 'C', 'en-US')  as GajiSetahun, format(((GajiBulanan * 12)*0.3),'C', 'en-US')  as Pajak, 
		format(((GajiBulanan * 12) - ((GajiBulanan * 12)*0.3)), 'C', 'en-US') as GajiAkhirPerTahun
from tblGajiBulanan


drop procedure GajiSetelahPajak
create procedure GajiSetelahPajak (@tahun int)
as begin

end

execute GajiSetelahPajak









--set HireDAte = '2024-01-01 00:00:00.000'
--where StaffNumber = 'CA01'

--create function PerhitunganPajak(
--@gaji money,
--@hire date,
--@persen decimal
--)
--returns as 
--begin

--	declare @i int = datediff(MONTH, @hire, getdate())

--	if(@i >= 12)
--	begin
--		set @gaji = (@gaji * 12 * @persen/100)
--	end
--	else
--	begin
--		set @gaji = (@gaji * @i * (@persen/12*@i)/100)
--	end
--return @gaji
--end


--select
--StaffNumber, 
--CONCAT(FirstName, ' ', MiddleName, ' ', LastName) as Name,
--FORMAT(dbo.PerhitunganPajak(BasicSalary, HireDate, 3), 'C', 'en-US') as Pajak,
--(BasicSalary * 1) as GajiTahunan,
--DATEDIFF(MONTH, HireDate, GETDATE()) as LamaKerjaDalamBulan
--from Tutor