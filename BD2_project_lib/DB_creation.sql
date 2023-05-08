IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'BD2_database')
BEGIN
    CREATE DATABASE BD2_database;
END
GO


USE BD2_database
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dbo.patient')
BEGIN
    CREATE TABLE dbo.patient
    (
		patient_id INT not NULL,
		patient_data NVARCHAR(MAX) not NULL,
		PRIMARY KEY(patient_id)
    );
END
GO

CREATE OR ALTER PROCEDURE dbo.insertPatient(@patient_data AS NVARCHAR(MAX))
AS
BEGIN 
	DECLARE @last_id AS INT;

	SELECT @last_id =MAX(patient_id) FROM dbo.patient;
	IF ISNULL( NULLIF(@last_id,''), 0) = 0
	BEGIN
		SET @last_id = 0;
	END;

	SET @last_id = @last_id +1;
	INSERT INTO dbo.patient(patient_id,patient_data) VALUES(@last_id, @patient_data);
END; 
GO


--EXEC dbo.insertPatient "'FirstName': 'Sam','LastName': 'Doe', 'Pesel' : '12345678901', 'PhoneNumber' : '123456789','VaccinationDate' : '2021-05-05'}"


select * from dbo.patient
GO

CREATE OR ALTER FUNCTION dbo.getPatients() RETURNS 
TABLE
AS
RETURN
	SELECT patient_data FROM dbo.patient;
GO

SELECT * FROM dbo.getPatients();		