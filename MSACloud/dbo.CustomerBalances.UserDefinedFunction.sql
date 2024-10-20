USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomerBalances]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerBalances] 
(
	@ClientID bigint,
	-- Add the parameters for the function here
	--@CUSTID int = 0,
	@CUSTLIST varchar(2048) = '',
	--@SCHID int = 0,
	@SCHLIST varchar(2048) = '',
	--@GRADE varchar(15) = 'None',
	@GRLIST varchar(2048) = '',
	--@HR varchar(10) = 'None',
	@HRLIST varchar(2048) = '',
	@LTLIST varchar(2048) = '',
	@ACTIVETYPE int = 2,	-- ActiveType: 0-InActive,1-Active,2-All
	@DELETEDTYPE int = 2,	-- DeletedType: 0-NotDeleted,1-Deleted,2-All
	@DOCREATEDATE bit = 0,
	@CREATEDATEBEGIN datetime = '1/1/1900',
	@CREATEDATEEND datetime = '1/1/1900',
	@CREATETYPE int = 0,
	@BALCALCENDDATE datetime = NULL,
	@INCLUDEBALS bit = 1
)
RETURNS @CustBals TABLE 
(
	-- Add the column definitions for the TABLE variable here
	Customer_Id int, 
	ABalance float,
	MBalance float,
	BonusBalance float,
	Balance float
)
AS
BEGIN
	--DECLARE @CustBals TABLE (Customer_Id int, ABalance float, MBalance float, BonusBalance float, Balance float)
	IF (@INCLUDEBALS = 0) RETURN

	DECLARE 
		@MYCUSTID int, 
		@MYSCHID int, 
		@MYGRADE int, 
		@MYHOMEROOM int,
		@MYLUNCHTYPE int, 
		@ISACTIVE bit, 
		@ISDELETED bit, 
		@USEBONUS bit,
		@CREATEDATE datetime

	SET @MYCUSTID = 0
	SET @MYSCHID = 0
	SET @MYGRADE = 0
	SET @MYHOMEROOM = 0
	SET @MYLUNCHTYPE = 0
	SET @ISACTIVE = 0
	SET @ISDELETED = 0
	SET @USEBONUS = 0
	SET @CREATEDATE = '12/30/1900'
	IF (@BALCALCENDDATE IS NULL)
		SET @BALCALCENDDATE = GETDATE()

	-- Fill the table variable with the rows for your result set
	DECLARE MyCursor CURSOR LOCAL FOR 
		SELECT 
			c.Id as CstID,
			s.Id as SchID,
			g.Id as Grade,
			h.Id as Homeroom,
			ISNULL(c.LunchType,4) as LunchType,
			c.isActive as Active,
			c.isDeleted as Deleted,
			c.CreationDate,
			ISNULL(do.UsingBonus,0) as UsingBonus
		FROM Customers c
			INNER JOIN Customer_School cs ON (cs.Customer_Id = c.Id AND cs.isPrimary = 1 AND cs.ClientID = c.ClientID)      
			LEFT OUTER JOIN Schools s ON s.Id = cs.School_Id AND s.ClientID = c.ClientID
			LEFT OUTER JOIN Grades g ON g.Id = c.Grade_Id AND g.ClientID = c.ClientID
			LEFT OUTER JOIN Homeroom h ON h.Id = c.Homeroom_Id AND h.ClientID = c.ClientID
			LEFT OUTER JOIN DistrictOptions do ON c.District_Id = do.District_Id AND do.ClientID = c.ClientID
		WHERE 
			c.ClientID = @ClientID AND c.Id > 0
	
	OPEN MyCursor 
	FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 

	WHILE (@@FETCH_STATUS = 0) BEGIN 
		
		-- CUSTOMER LIST
		IF (	(LEN(@CUSTLIST) > 0) AND 
				(
				(PATINDEX('(' + CAST(@MYCUSTID as varchar) + ',%', @CUSTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYCUSTID as varchar) + ',%', @CUSTLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYCUSTID as varchar) + ')', @CUSTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYCUSTID as varchar) + ')', @CUSTLIST) = 0)
				)
			)
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- SCHOOL LIST
		IF (	(LEN(@SCHLIST) > 0) AND 
				(
				(PATINDEX('(' + CAST(@MYSCHID as varchar) + ',%', @SCHLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYSCHID as varchar) + ',%', @SCHLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYSCHID as varchar) + ')', @SCHLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYSCHID as varchar) + ')', @SCHLIST) = 0)
				)
			)
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- GRADE LIST
		IF (	(LEN(@GRLIST) > 0) AND 
				(
				(PATINDEX('(' + CAST(@MYGRADE as varchar) + ',%', @GRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYGRADE as varchar) + ',%', @GRLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYGRADE as varchar) + ')', @GRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYGRADE as varchar) + ')', @GRLIST) = 0)
				)
			)
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END
		
		-- HOMEROOM LIST
		IF (	(LEN(@HRLIST) > 0) AND 
				(
				(PATINDEX('(' + CAST(@MYHOMEROOM as varchar) + ',%', @HRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYHOMEROOM as varchar) + ',%', @HRLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYHOMEROOM as varchar) + ')', @HRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYHOMEROOM as varchar) + ')', @HRLIST) = 0)
				)
			)
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- LUNCH STATUS LIST
		IF (	(LEN(@LTLIST) > 0) AND 
				(
				(PATINDEX('(' + CAST(@MYLUNCHTYPE as varchar) + ',%', @LTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYLUNCHTYPE as varchar) + ',%', @LTLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYLUNCHTYPE as varchar) + ')', @LTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYLUNCHTYPE as varchar) + ')', @LTLIST) = 0)
				)
			)
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- ACTIVE STATUS
		IF ((@ACTIVETYPE <> 2) AND (@ISACTIVE <> @ACTIVETYPE))
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- DELETED
		IF ((@DELETEDTYPE <> 2) AND (@ISDELETED <> @DELETEDTYPE))
		BEGIN
			FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
			CONTINUE
		END

		-- CREATION DATE
		IF (@DOCREATEDATE = 1) BEGIN
			IF ((@CREATETYPE = 0) AND (CONVERT(varchar,@CREATEDATE,101) = CONVERT(varchar,@CREATEDATEBEGIN,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
			IF ((@CREATETYPE = 1) AND (CONVERT(varchar,@CREATEDATE,101) < CONVERT(varchar,@CREATEDATEBEGIN,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
			IF ((@CREATETYPE = 2) AND (CONVERT(varchar,@CREATEDATE,101) <= CONVERT(varchar,@CREATEDATEBEGIN,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
			IF ((@CREATETYPE = 3) AND (CONVERT(varchar,@CREATEDATE,101) > CONVERT(varchar,@CREATEDATEBEGIN,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
			IF ((@CREATETYPE = 4) AND (CONVERT(varchar,@CREATEDATE,101) >= CONVERT(varchar,@CREATEDATEBEGIN,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
			IF ((@CREATETYPE = 5) AND 
					(CONVERT(varchar,@CREATEDATE,101) >= CONVERT(varchar,@CREATEDATEBEGIN,101)) AND 
					(CONVERT(varchar,@CREATEDATE,101) <= CONVERT(varchar,@CREATEDATEEND,101))) BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END
		
		--INSERT INTO @CustBals EXEC dbo.GetRecalcBalanceTable @CUSTID, @USEBONUS, @BALCALCENDDATE  
		INSERT @CustBals SELECT * FROM dbo.GetRecalcBalances(@ClientID, @MYCUSTID, @USEBONUS, @BALCALCENDDATE)
		FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
	END 

	CLOSE MyCursor 
	DEALLOCATE MyCursor 

	RETURN
END
GO
