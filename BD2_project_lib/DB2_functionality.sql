
-- function : return value of given key
CREATE FUNCTION dbo.find_value(@json_data NVARCHAR(MAX), @key NVARCHAR(50)) RETURNS NVARCHAR(50)
AS
BEGIN 
		DECLARE @value_start INT = 
		CHARINDEX(@key , @json_data) + len(@key) + 3

		DECLARE @value NVARCHAR(50) = 
		SUBSTRING(@json_data ,@value_start, CHARINDEX('"', @json_data, @value_start) -@value_start )

		RETURN @value
END
GO

SELECT  dbo.find_value(N'{"pesel":"123456789","fname":"Stanis³aw","lname":"Kowalski","phone_num":"661663668"}', 'phone_num')

GO


-- function : return patients id
CREATE FUNCTION getID(@pesel NVARCHAR(11)) RETURNS INT
AS 
BEGIN
	DECLARE @id INT , @json_data NVARCHAR(MAX), @saved_pesel NVARCHAR(11)
	DECLARE curr CURSOR FOR SELECT * FROM patient

	OPEN curr
	FETCH NEXT FROM curr INTO @id, @json_data

	WHILE @@FETCH_STATUS =0
	BEGIN 
		SELECT @saved_pesel = dbo.find_value(@json_data,'pesel')
		IF  @saved_pesel = @pesel
		BEGIN 
			CLOSE curr
			DEALLOCATE curr
			RETURN @id
		END

		FETCH NEXT FROM curr INTO @id, @json_data
	END

	CLOSE curr
	DEALLOCATE curr

	
	RETURN NULL
END
GO


SELECT dbo.getID('86012679715') AS ID 
GO


-- function : present 'in use' key names
CREATE FUNCTION get_key_names() RETURNS NVARCHAR(200)
AS 
BEGIN
	DECLARE @str NVARCHAR(200)



	RETURN @str
END
GO


-- procedure: vacc date
CREATE OR ALTER PROCEDURE  dbo.set_date
	@pesel CHAR(11), 
	@date1 DATE
AS 
BEGIN
	DECLARE @patient_id INT  = dbo.getID(@pesel) 
	--last vaccination
	DECLARE @vlast DATE 
	SELECT @vlast =  MAX(vdate) FROM vacc_date WHERE patient_id = @patient_id

	IF DATEDIFF(MONTH,@vlast,@date1) <9
	BEGIN
		PRINT 'Wrong date... first date available for you is: ' + CONVERT(NVARCHAR(50),DATEADD(MONTH,9,@vlast))
		RETURN
	END

	INSERT INTO vacc_date (patient_id,vdate) VALUES (@patient_id, @date1)
	PRINT 'New Record: ' +   CONVERT(NVARCHAR(50),@patient_id )+ ' ' +  CONVERT(NVARCHAR(50),@date1)


	RETURN

END
GO

EXEC dbo.set_date '81073139886', '20210202'

SELECT * FROM dbo.vacc_date
GO

--change value 
CREATE OR ALTER PROCEDURE dbo.change_value
	@pesel CHAR(11),	
	@key NVARCHAR(200),
	@new_val NVARCHAR(200)
AS
BEGIN
	IF TRIM(@key) = 'pesel'
	BEGIN
		PRINT 'Pesel is not changable.'
		RETURN
	END
	DECLARE @id INT = dbo.getID(@pesel)
	DECLARE @json NVARCHAR(MAX)
	SELECT @json = json_patient FROM dbo.patient WHERE patient_id = @id
	DECLARE @old_val NVARCHAR(200)
	SELECT @old_val = dbo.find_value(@json,@key)


	IF @old_val = TRIM(@new_val)
	BEGIN
		PRINT 'New value is the same as old one.'
		RETURN
	END

	SET @json = REPLACE(@json,@old_val,@new_val)

	UPDATE dbo.patient SET json_patient= @json 
	WHERE patient_id = @id

	PRINT 'New data: ' + @json


END
GO

EXEC dbo.change_value'81073139886', 'phonenum' , '551553559'
GO

-- function: get key names
CREATE FUNCTION GetJsonStringValues(@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @len INT = LEN(@input);
    DECLARE @key NVARCHAR(MAX);


	--while loop to iterate over "JSON"
    WHILE @i < @len
    BEGIN
        SET @i = CHARINDEX('"', @input, @i);
        IF @i = 0 BREAK;

        SET @i = @i + 1;
		--clear key value
        SET @key = '';

        WHILE @i < @len AND SUBSTRING(@input, @i, 1) <> '"'
        BEGIN
            SET @key = @key + SUBSTRING(@input, @i, 1);
            SET @i = @i + 1;
        END

        IF LEN(@result) > 0 SET @result = @result + ' ';
        SET @result = @result + @key;
    END

    RETURN @result;
END
GO

SELECT dbo.GetJsonStringValues( N'{"pesel":"1234567891011","fname":"Stanis³aw","lname":"Kowalski","phone_num":"661663668"}'  )

DROP FUNCTION  GetJsonStringValues
GO

--get json keynames
CREATE FUNCTION json_keynames(@jdata NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
	DECLARE @start_pos INT =0, @end_pos INT =0, @move_pos INT =0
	DECLARE @iter INT = 0


	--while loop to iterate over "JSON"
    WHILE @i <	LEN(@jdata)- CHARINDEX(':',REVERSE(@jdata)) -1
    BEGIN
		
		SET @iter = @iter+1 
		SET @i = CHARINDEX('"',@jdata, @move_pos+1)
		IF @i > LEN(@jdata)- CHARINDEX(':',REVERSE(@jdata)) -1
		BEGIN
			BREAK
		END
		SET @start_pos = @i
		SET @end_pos = CHARINDEX('":"', @jdata, @i+1) -1
		SET @move_pos = CHARINDEX('","', @jdata, @i) 

		SET @result = @result  +  CONVERT(NVARCHAR(50),@iter) + ' '+ SUBSTRING(@jdata,@start_pos+1,@end_pos -@start_pos) +  ' ' 

		IF @move_pos = 0 OR @i =0 OR  @end_pos =0
		BEGIN
			RETURN  @result
		END

			
    END


    RETURN @result;
END
GO


SELECT dbo.json_keynames( N'{"pesel":"1234567891011","fname":"Stanis³aw","lname":"Kowalski","phone_num":"661663668"}'  )

SELECT dbo.json_keynames( N'{"pesel":"1234567891011","fname":"Stanis³aw"}'  )


DROP FUNCTION  json_keynames
GO

SELECT LEN(N'{"pesel":"1234567891011","fname":"Stanis³aw"}')- CHARINDEX(':',REVERSE(N'{"pesel":"1234567891011","fname":"Stanis³aw"}'))