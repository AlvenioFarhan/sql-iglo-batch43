use MarketPlace

select * from Admin

select * from Review

select * from Transaksi
select * from TransaksiDetail

select * from Akun
select * from AlamatPembeli

select * from Diskusi

----Data Untuk Tabel Produk
insert into Produk
values ('3','1','1','Baju Remaja','20000','Baju Cakep','10','2022-05-07','1'),
('4','2','2','Batagor','5000','Batagor Gurih','20','2024-02-07','1')
;
select * from Produk
select * from Kategori
select * from Toko



/*
sisapa pun pembeli, dia membeli produk 3 2 bijihh, 4 juga 2 biji
harga barang, ongkir, total transaksi
*/


select * from Produk
select * from Pembeli
select * from Ekspedisi
select * from Transaksi
select * from TransaksiDetail


select p.Harga ,e.OngkirPerKm, ((p.Harga*2)+ (e.OngkirPerKm*500))TotalTransaksi
from Produk p
join TransaksiDetail td on p.ProdukID = td.ProdukID
join Transaksi t on t.TransaksiID = td.TransaksiID
join Ekspedisi e on t.EkspedisiID = e.EkspedisiID
join Pembeli pem on pem.PembeliID = t.PembeliID
where p.ProdukID = 3 and p.ProdukID = 4

group by p.Harga

declare @jumlahproduk as int = 2
select p.ProdukID, Harga*@jumlahproduk, e.OngkirPerKm
from Produk p, Ekspedisi e
where p.ProdukID = 3 or p.ProdukID = 4