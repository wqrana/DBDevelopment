USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomerBalances_V2]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerBalances_V2] 
(
	@ClientID bigint,
	@CUSTLIST varchar(2048) = NULL,
	@SCHLIST varchar(2048) = NULL,
	@GRLIST varchar(2048) = NULL,
	@HRLIST varchar(2048) = NULL,
	@LTLIST varchar(2048) = NULL,
	@ACTIVETYPE int = 2,	-- ActiveType: 0-InActive,1-Active,2-All
	@DELETEDTYPE int = 2,	-- DeletedType: 0-NotDeleted,1-Deleted,2-All
	@CREATEDATEBEGIN datetime = NULL,
	@CREATEDATEEND datetime = NULL,
	@CREATETYPE int = 0, -- On=0,Before=1,On & Before=2,After=3,On & After=4,Between=5
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
	, SCHOOLID INT
	, MYGRADE INT
	, MYHOMEROOM INT
	, MYLUNCHTYPE INT
	, ISACTIVE BIT
	, ISDELETED BIT
	, USEBONUS BIT
	, CREATIONDATE DATETIME
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
	--SET @CREATEDATE = '12/30/1900'
	IF (@BALCALCENDDATE IS NULL)
		SET @BALCALCENDDATE = GETDATE()

	DECLARE
		@DOCREATEDATE bit = 0
	IF(@CREATEDATEBEGIN IS NOT NULL)
	BEGIN
		SET @DOCREATEDATE = 1
		SET @CREATEDATEEND = ISNULL(@CREATEDATEEND, @CREATEDATEBEGIN)
	END

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
			c.ClientID = ISNULL(@ClientID, c.ClientID) AND c.Id > 0
	
	OPEN MyCursor 
	FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		
		IF(LEN(LTRIM(RTRIM(ISNULL(@CUSTLIST, '')))) > 0) -- Check if any customer passed
		BEGIN
			
			IF(
				(@MYCUSTID IS NULL) OR
				((PATINDEX('(' + CAST(@MYCUSTID as varchar) + ',%', @CUSTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYCUSTID as varchar) + ',%', @CUSTLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYCUSTID as varchar) + ')', @CUSTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYCUSTID as varchar) + ')', @CUSTLIST) = 0))
				)
			BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END
		ELSE
		
		--PRINT '----------------------------Entring school filter----------------------------'
		IF(LEN(LTRIM(RTRIM(ISNULL(@SCHLIST, '')))) > 0) -- Check if any school passed
		BEGIN
			IF(
				(@MYSCHID IS NULL) OR
				((PATINDEX('(' + CAST(@MYSCHID as varchar) + ',%', @SCHLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYSCHID as varchar) + ',%', @SCHLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYSCHID as varchar) + ')', @SCHLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYSCHID as varchar) + ')', @SCHLIST) = 0))
				)
			BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END

		--PRINT '----------------------------Entring grade filter----------------------------'
		IF(LEN(LTRIM(RTRIM(ISNULL(@GRLIST, '')))) > 0) -- Check if any grade passed
		BEGIN
			IF(
				(@MYGRADE IS NULL) OR
				((PATINDEX('(' + CAST(@MYGRADE as varchar) + ',%', @GRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYGRADE as varchar) + ',%', @GRLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYGRADE as varchar) + ')', @GRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYGRADE as varchar) + ')', @GRLIST) = 0))
				)
			BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END

		--PRINT '----------------------------Entring homeroom filter----------------------------'
		IF(LEN(LTRIM(RTRIM(ISNULL(@HRLIST, '')))) > 0) -- Check if any homeroom passed
		BEGIN
			IF(
				(@MYHOMEROOM IS NULL) OR
				((PATINDEX('(' + CAST(@MYHOMEROOM as varchar) + ',%', @HRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYHOMEROOM as varchar) + ',%', @HRLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYHOMEROOM as varchar) + ')', @HRLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYHOMEROOM as varchar) + ')', @HRLIST) = 0))
				)
			BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END

		--PRINT '----------------------------Entring lunch type filter----------------------------'
		IF(LEN(LTRIM(RTRIM(ISNULL(@LTLIST, '')))) > 0) -- Check if any lunch type passed
		BEGIN
			IF(
				(@MYLUNCHTYPE IS NULL) OR
				((PATINDEX('(' + CAST(@MYLUNCHTYPE as varchar) + ',%', @LTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYLUNCHTYPE as varchar) + ',%', @LTLIST) = 0) AND
				(PATINDEX('(' + CAST(@MYLUNCHTYPE as varchar) + ')', @LTLIST) = 0) AND
				(PATINDEX('%,' + CAST(@MYLUNCHTYPE as varchar) + ')', @LTLIST) = 0))
				)
			BEGIN
				FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				CONTINUE
			END
		END
		
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
		IF (@DOCREATEDATE = 1 AND (@CREATETYPE IS NOT NULL)) 
		BEGIN
			
			IF ((@CREATETYPE = 0))-- AND (CONVERT(varchar,@CREATEDATE,101) = CONVERT(varchar,@CREATEDATEBEGIN,101))) 
			BEGIN
				IF(NOT(DBO.DATEONLY(@CREATEDATE) = DBO.DATEONLY(@CREATEDATEBEGIN)))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END				
			END
			IF ((@CREATETYPE = 1))-- AND (CONVERT(varchar,@CREATEDATE,101) < CONVERT(varchar,@CREATEDATEBEGIN,101))) 
			BEGIN
				IF(NOT(DBO.DATEONLY(@CREATEDATE) < DBO.DATEONLY(@CREATEDATEBEGIN)))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END				
			END
			IF ((@CREATETYPE = 2))-- AND (CONVERT(varchar,@CREATEDATE,101) <= CONVERT(varchar,@CREATEDATEBEGIN,101)))
			BEGIN
				IF(NOT(DBO.DATEONLY(@CREATEDATE) <= DBO.DATEONLY(@CREATEDATEBEGIN)))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END				
			END
			IF ((@CREATETYPE = 3))-- AND (CONVERT(varchar,@CREATEDATE,101) > CONVERT(varchar,@CREATEDATEBEGIN,101))) 
			BEGIN
				IF(NOT(DBO.DATEONLY(@CREATEDATE) >  DBO.DATEONLY(@CREATEDATEBEGIN)))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END				
			END
			IF ((@CREATETYPE = 4))-- AND (CONVERT(varchar,@CREATEDATE,101) >= CONVERT(varchar,@CREATEDATEBEGIN,101))) 
			BEGIN
				IF(NOT(DBO.DATEONLY(@CREATEDATE) > DBO.DATEONLY(@CREATEDATEBEGIN)))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END				
			END
			IF (@CREATETYPE = 5)
			BEGIN
				--PRINT'HERE'
				--PRINT '@CREATEDATE : ' + CONVERT(VARCHAR, @CREATEDATE, 101)
				--PRINT '@CREATEDATEBEGIN : ' + CONVERT(VARCHAR, @CREATEDATEBEGIN, 101)
				--PRINT '@CREATEDATEEND : ' + CONVERT(VARCHAR, @CREATEDATEEND, 101) 
				--DECLARE
				--	@LOWERBOUNDMATCH BIT = 0
				--	, @UPPERBOUNDMATCH BIT = 0
				--IF(DBO.DATEONLY(@CREATEDATE) >= DBO.DATEONLY(@CREATEDATEBEGIN))
				--BEGIN
				--	SET @LOWERBOUNDMATCH = 1
				--END
				--IF(DBO.DATEONLY(@CREATEDATE) <= DBO.DATEONLY(@CREATEDATEEND))
				--BEGIN
				--	SET @UPPERBOUNDMATCH = 1
				--END
				--IF((ISNULL(@LOWERBOUNDMATCH, 0)= 0) OR (ISNULL(@UPPERBOUNDMATCH, 0) = 0))
				--BEGIN
				--	FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
				--	CONTINUE
				--END
				IF(NOT((DBO.DATEONLY(@CREATEDATE) >= DBO.DATEONLY(@CREATEDATEBEGIN)) AND (DBO.DATEONLY(@CREATEDATE) <= DBO.DATEONLY(@CREATEDATEEND))))
				BEGIN
					FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
					CONTINUE
				END
			END
		END

		INSERT @CustBals SELECT 
			* 
			, @MYSCHID
			, @MYGRADE
			, @MYHOMEROOM
			, @MYLUNCHTYPE
			, @ISACTIVE
			, @ISDELETED
			, @USEBONUS
			, @CREATEDATE

			FROM dbo.GetRecalcBalances(@ClientID, @MYCUSTID, @USEBONUS, @BALCALCENDDATE)
		FETCH NEXT FROM MyCursor INTO @MYCUSTID, @MYSCHID, @MYGRADE, @MYHOMEROOM, @MYLUNCHTYPE, @ISACTIVE, @ISDELETED, @CREATEDATE, @USEBONUS 
	END

	CLOSE MyCursor 
	DEALLOCATE MyCursor 

	RETURN
END
GO
