--4) Subject of Major.sql
--Siswa ingin mengetahui apa saja detail subject dari suatu major yang namanya mereka sudah ketahui.
--Buatlah procedure yang bisa list informasi subject dari nama, deskripsi, level, dan costnya, berdasarkan dari nama major yang diinput. 
--Nama major sifatnya akan di search dari kata-kata yang mengandung inputan dari procedure, misalnya di search “network” maka akan keluar seluruh 
--informasi subject dari major Internetworking, networking and cyber security, dan lain sebagainya.
--(Note: apabila deskripsi dari subject kosong, harus diganti dengan “Ask student call center for this subject information”, dan seluruh 
--level harus di tulis di outputnya dengan nama lengkap, misalnya B jadi Bachelor)

select * from Student
select * from Subject
select * from Major

select m.ID
from Major m
where m.Name like '%majorName%'

select s.Name, s.Description, 
		CASE 
               WHEN s.Level = 'B' THEN 'Bachelor'
               WHEN s.Level = 'M' THEN 'Master'
               WHEN s.Level = 'P' THEN 'Phd'
               ELSE 'TidakDiketahui'
           END AS Level,
		s.Cost
from Subject s
join Major m on s.MajorID = m.ID
where m.Name like '%Enterprise%'


drop procedure GetDetailSubject
create procedure GetDetailSubject(@majorname varchar(50))
as
begin


select s.Name, s.Description, 
		CASE 
               WHEN s.Level = 'B' THEN 'Bachelor'
               WHEN s.Level = 'M' THEN 'Master'
               WHEN s.Level = 'P' THEN 'Phd'
               ELSE 'TidakDiketahui'
           END AS Level,
		s.Cost
from Subject s
join Major m on s.MajorID = m.ID
where m.Name like CONCAT('%', @majorname, '%') 

end

execute GetDetailSubject @majorname = 'Enterprise'