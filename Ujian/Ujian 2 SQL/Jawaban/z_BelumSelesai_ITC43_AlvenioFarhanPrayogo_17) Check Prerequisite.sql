--BELUM SELESAI
--17) Check Prerequisite.sql
--Pre-requisite adalah subject/mata pelajaran yang harus diselesaikan sebelum sebuah subject diambil atau di enroll. 
--Sebagian subject tidak memiliki pre-requisite yang artinya bisa langsung saja di ambil.
--Mahasiswa tidak ingin repot-repot mencari tahu pre-requisite apa saja yang harus dipenuhi sebelum dia mau mengambil subject, 
--mahasiswa ingin agar dia hanya mendapat jawaban bisa atau tidak bisa dia mengambil subject ini berdasarkan pre-requisitenya. 
--Jadi, buatlah sebuah function dimana function tersebut menerima input Student Number dan Subject Code, lalu function akan 
--mengembalikan output berupa bit/boolean, True(1) untuk bisa diambil, False(0) untuk tidak bisa diambil.

select * from Student
select * from Subject