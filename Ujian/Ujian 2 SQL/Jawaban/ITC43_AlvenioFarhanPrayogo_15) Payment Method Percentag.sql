--15) Payment Method Percentage.sql
--Ingin diketahui trend cara pembayaran/ payment method dari awal pertama kali enrollment. 
--Hitung berapa persen setiap payment method dipakai untuk transaksi dari semua transaksi yang ada. 
--(Note: payment method harus ditulis nama lengkapnya). Kurang lebih outputnya harus seperti dibawah ini:
--Payment Method	Percentage
--Credit Card	40%
--Auto Collection	20%
--Cheque	10%
--Bank Transfer	30%

select * from Enrollment

select (COUNT(*) * 100) / (SELECT COUNT(*) FROM Enrollment) AS Percentage
FROM Enrollment

select 
	CASE 
        WHEN e.PaymentMethod = 'AC' THEN 'Auto Collection'
        WHEN e.PaymentMethod = 'CC' THEN 'Credit Card'
        WHEN e.PaymentMethod = 'CH' THEN 'Cheque'
        WHEN e.PaymentMethod = 'BT' THEN 'Bank Transfer'
		ELSE 'BelumPayment'
    END AS PaymentMethod,
	CONCAT(FORMAT((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Enrollment), '0.00') ,'%') AS Percentage
from Enrollment e
WHERE e.PaymentMethod IS NOT NULL
group by e.PaymentMethod

