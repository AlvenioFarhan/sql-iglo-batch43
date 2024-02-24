--18) Major Popularity on Gender.sql
--Ingin diketahui apakah adanya trend satu penjurusan/major terhadap jenis kelamin. 
--Tunjukan lah perbandingan jumlah siswa pada table pivot jenis kelamin dan major.
--Major Name	Male	Female
--Major 1		
--Major 2		
--(Note: Ada mahasiswa yang mengambil double major, artinya dia punya lebih dari satu major, maka mahasiswa itu akan dihitung lebih dari 1)

select * from Major
select * from StudentMajor
select * from Student

select * from(
select m.Name as MajorName, s.StudentNumber,
		CASE 
            WHEN s.Gender = 'M' THEN 'Male'
            WHEN s.Gender = 'F' THEN 'Female'            
            ELSE 'TidakDiketahui'
       END AS Gender
from Student s
join StudentMajor sm on s.StudentNumber = sm.StudentNumber
join Major m on sm.MajorID = m.ID
) tbl
pivot(count(StudentNumber)for Gender in ([Male],[Female])
) pvt
