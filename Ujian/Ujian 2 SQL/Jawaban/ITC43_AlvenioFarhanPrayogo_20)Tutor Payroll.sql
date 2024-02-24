--20)Tutor Payroll.sql
--Terdiri dari beberapa jenis Tutor berdasarkan tipe status ketenagakerjaannya, yaitu Full-time Contract, Full-time Permanent, 
--Part-time Contract, dan Casual. Setiap pekerja Full Time menerima gaji 1 kali dalam 1 bulan, sedangkan Part Time dan Casual 
--menerima 2 kali dalam 1 bulan. Sebagian pekerja Full Time Permanent menerima tunjangan(allowance) extra di gajinya dalam bentuk 
--persentase total gajinya. Apabila allowancenya 15, itu artinya gajinya akan ditambah 15% lagi dari gaji sebulannya.
--Hitung seluruh take home pay tutor (total pendapatan, sudah termasuk allowance) dalam waktu 1 bulan, dan keluarkan hasilnya dalam 
--column-column: Staff Number, Employee Full name, Employee Type, dan Take Homepay. (Note: Employee Type harus ditulis lengkap, 
--tidak boleh singkatan seperti FC, harus Full-time Contract).

select * from Tutor


select t.StaffNumber,
		CONCAT(t.FirstName, ' ', t.MiddleName, ' ', t.LastName) NamaLengkap,
		CASE 
            WHEN t.EmployeeType = 'FC' THEN 'Full-time Contract'
            WHEN t.EmployeeType = 'FP' THEN 'Full-time Permanent' 
			WHEN t.EmployeeType = 'PC' THEN 'Part-time Contract'
			WHEN t.EmployeeType = 'CA' THEN 'Casual'
            ELSE 'TidakDiketahui'
		END AS EmployeeType,
		CASE 
            WHEN t.EmployeeType IN ('FC', 'FP') THEN 
                (t.BasicSalary + (t.BasicSalary * ISNULL(t.Allowance, 0) / 100))
            WHEN t.EmployeeType IN ('PC', 'CA') THEN 
                (t.BasicSalary / 2)
        END AS TakeHomePay

from Tutor t