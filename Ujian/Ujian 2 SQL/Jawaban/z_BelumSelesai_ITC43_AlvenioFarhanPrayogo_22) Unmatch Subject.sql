--BELUM SELESAI
--22) Unmatch Subject.sql
--Setiap major memiliki level, baik bachelor, master, maupun phd, begitu pula dengan setiap subject. 
--Level setiap major dan subject tidak perlu selalu match atau cocok. Pada major phd, subject phd, bachelor dan 
--master diperbolehkan, pada major master subject dengan level bachelor dan master diperbolehkan, tetapi pada major 
--bachelor hanya subject bachelor yang diperbolehkan. List seluruh subject yang levelnya tidak match dengan level majornya 
--(bukan yang melanggar aturan, yang tidak match saja), lalu keluarkan informasi, Major Name dan Subject Name, tetapi seluruh 
--Subject Namenya harus yang masih aktif, atau tidak ada tanggal NonActiveDate.


select * from Major
select * from Subject

select m.Name as MajorName, s.Name as SubjectName
from Major m
join Subject s on m.ID = s.MajorID








SELECT m.Name as MajorName, s.Name as SubjectName
FROM Major m
JOIN Subject s ON m.ID = s.MajorID
WHERE 
    (m.Level = 'Bachelor' AND s.Level <> 'Bachelor') OR
    (m.Level = 'Master' AND s.Level = 'Phd') OR
    (m.Level = 'Phd' AND s.Level IN ('Bachelor', 'Master')) AND
    (s.NonActiveDate IS NULL OR s.NonActiveDate > GETDATE());
