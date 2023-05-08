-- procedure : change fname, lname, phone_num
CREATE OR ALTER PROCEDURE dbo.change_json
	@patient_id INT,
	@new_fname NVARCHAR(50),
	@new_lname NVARCHAR(50),
	@new_pnum NVARCHAR(50)
AS
BEGIN 
	SET NOCOUNT ON;
	IF @new_fname = 'no_change' AND @new_lname = 'no_change' AND @new_pnum = 'no_change'
	BEGIN 
		RETURN
	END

	DECLARE @new_json NVARCHAR(MAX)

	-- declare old json and its values
	DECLARE @old_json NVARCHAR(MAX)
	SELECT @old_json =  json_patient FROM dbo.patient WHERE patient_id = @patient_id
	DECLARE @pesel NVARCHAR(50) = dbo.find_value(@old_json, 'pesel')
	DECLARE @old_fname NVARCHAR(50) = dbo.find_value(@old_json, 'fname')
	DECLARE @old_lname NVARCHAR(50) = dbo.find_value(@old_json, 'lname')
	DECLARE @old_pnum NVARCHAR(50) = dbo.find_value(@old_json, 'phone_num')

	--check new values
	IF @new_fname = 'no_change'
	BEGIN
		SET @new_fname = @old_fname
	END
	IF @new_lname = 'no_change'
	BEGIN
		SET @new_lname = @old_lname
	END
	IF @new_pnum = 'no_change'
	BEGIN
		SET @new_pnum = @old_pnum
	END

	-- structure new json
	SET @new_json =  N'{ "pesel" : "'+@pesel + '", "fname" : "'+@new_fname+'", "lname" : "'+@new_lname+'", "phone_num" : "'+@new_pnum+'"}'

	--PRINT(@new_json)
	UPDATE dbo.patient SET json_patient= @new_json 
	WHERE patient_id = @patient_id


END
GO


EXEC dbo.change_json 1, 'Kamil', 'Kocio³ek' , '889887886'
SELECT * FROM dbo.patient
GO
