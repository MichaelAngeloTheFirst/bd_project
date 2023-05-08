IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'BD2_database')
BEGIN
    CREATE DATABASE BD2_database;
END
GO

USE BD2_database
GO

--key name table // PESEL NOT CHANGEABLE
CREATE TABLE key_names(
	key_names_id INT IDENTITY(1,1) PRIMARY KEY,
	key_string NVARCHAR(MAX) NOT NULL
)
GO

--default key names 
INSERT INTO key_names(key_string) VALUES('fname;lname;phone_num')
GO




--patient table
CREATE TABLE patient(
	patient_id INT IDENTITY(1,1) PRIMARY KEY,
	json_patient NVARCHAR(MAX)
)

INSERT INTO patient(json_patient) VALUES(N'{"pesel":"81073139886","fname":"Stanis³aw","lname":"Kowalski","phone_num":"661663668"}')
INSERT INTO patient(json_patient) VALUES(N'{"pesel":"86012679715","fname":"Dawid","lname":"Szewczyk","phone_num":"661663668"}')
INSERT INTO patient(json_patient) VALUES(N'{"pesel":"54070838324","fname":"Andrzej","lname":"Zawadzki","phone_num":"661663668"}')

SELECT * FROM patient;
GO 


-- table: vaccination dates
CREATE TABLE vacc_date(
	vacc_date_id INT IDENTITY(1,1) PRIMARY KEY,
	patient_id INT NOT NULL FOREIGN KEY REFERENCES dbo.patient(patient_id),
	vdate DATE NOT NULL
)

INSERT INTO vacc_date(patient_id, vdate) VALUES (2, '20210101')

SELECT * FROM vacc_date