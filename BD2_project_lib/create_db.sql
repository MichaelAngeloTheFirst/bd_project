USE BD2_database
GO

IF NOT EXISTS (SELECT * 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'patient3')
BEGIN
    CREATE TABLE dbo.patient3
    (
		patient_id INT not NULL,
		patient_data NVARCHAR(MAX) not NULL,
		PRIMARY KEY(patient_id)
    );
END
GO

SELECT * FROM patient3;