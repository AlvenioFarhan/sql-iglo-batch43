--11. Total product from supplier.sql
--Ingin diketahui berapa jumlah macam product yang dihasilkan oleh setiap perusahaan supplier yang 
--masih diproduksi oleh supplier tersebut dan dijual di northwind. Keluarkan informasi pada laporan 
--berupa, nama perusahaan supplier dan jumlah macam product.select * from Productsselect * from Suppliersselect  s.CompanyName, count(p.ProductID)JumlahMacamProdukfrom Suppliers sjoin Products p on s.SupplierID = p.SupplierIDgroup by s.CompanyName