SELECT * FROM Student
SELECT * FROM StudentMajor
SELECT * FROM Major
SELECT * FROM Certificate

SELECT CONCAT(s.FirstName, ' ' ,IIF(s.MiddleName IS NULL, ' ', S.MiddleName), ' ', s.LastName ) Fullname, CONCAT(c.Name, ',', ' ', FORMAT(s.BirthDate, 'dd MMMM yyyy')) Kelahiran, m.Name FROM Student s
JOIN StudentMajor sm ON s.StudentNumber = sm.StudentNumber
JOIN Major m ON sm.MajorID = m.ID
JOIN City c ON s.BirthCityID = c.ID
LEFT JOIN Certificate ce ON s.StudentNumber = ce.StudentNumber
WHERE ce.StudentNumber IS NULL