USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCFSETaxReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/24/2019
-- Description:	Data for CFSE Tax Quarter Reports.  Returns the data per quarter
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCFSETaxReport]
(
	 @strPayrollCompany as nvarchar(50),
	 @strEndYear as varchar(4),
	 @intGrouping int
)
RETURNS @tblCFSEReport TABLE 
(
	strCompanyName	nvarchar(50),
	strYear varchar(4),
	strQuarter nvarchar(50),
	dtStartDate		date,
	dtEndDate		date,
	strGrouping		nvarchar(50),
	intUserCovered int,
	strCFSECode		nvarchar(50),
	decCFSEWages	decimal(18,5),
	decCFSETaxPercent decimal(18,5),
	decCFSETaxOwed		decimal(18,5),
	decCFSETaxContributed		decimal(18,5)
	)
-- WITH ENCRYPTION
AS
BEGIN

DECLARE	 @strCFSEWithholdings as nvarchar(50)

----------------------------------
SET @strCFSEWithholdings = 'CFSE'
if not exists(Select * from tblWithholdingsItems where strWithHoldingsName = @strCFSEWithholdings) 
	SET @strCFSEWithholdings = 'WORKERS COMP'
----------------------------------

DECLARE @strStartYear as varchar(4)
--Set Previous Year Variable
SET @strStartYear = cast( cast(@strEndYear as int) - 1 as varchar(4))


-- Total earnings grouped by CFSE Class between 7/1/StartYear and 9/30/StartYear
INSERT INTO @tblCFSEReport
SELECT 	strCompanyName	, @strStartYear	,@strStartYear  +' 3rd QTR ' as strQuarter,
	dtStartDate,
	dtEndDate		,
	strGrouping		,
	intUserCovered ,
	strCFSECode		,
	decCFSEWages	,
	decCFSETaxPercent ,
	decCFSETaxOwed		,
	decCFSETaxContributed		 FROM [dbo].[fnPay_tblCFSECodeGroupDetail] (   @strPayrollCompany  ,'7/1/' + @strStartYear, '9/30/' + @strStartYear ,@intGrouping)


-- Total earnings grouped by CFSE Class between 10/1/StartYear and 12/31/StartYear
INSERT INTO @tblCFSEReport
SELECT 	strCompanyName	, @strStartYear	,@strStartYear  + ' 4th QTR '  as strQuarter,
	dtStartDate,
	dtEndDate		,
	strGrouping		,
	intUserCovered ,
	strCFSECode		,
	decCFSEWages	,
	decCFSETaxPercent ,
	decCFSETaxOwed		,
	decCFSETaxContributed		 FROM [dbo].[fnPay_tblCFSECodeGroupDetail] (   @strPayrollCompany  ,'10/1/' + @strStartYear, '12/31/' + @strStartYear ,@intGrouping)

-- Total earnings grouped by CFSE Class between 1/1/EndYear and 3/31/EndYear
INSERT INTO @tblCFSEReport
SELECT 	strCompanyName	, @strEndYear	,@strEndYear  + ' 1st QTR '  as strQuarter,
	dtStartDate,
	dtEndDate		,
	strGrouping		,
	intUserCovered ,
	strCFSECode		,
	decCFSEWages	,
	decCFSETaxPercent ,
	decCFSETaxOwed		,
	decCFSETaxContributed		 FROM [dbo].[fnPay_tblCFSECodeGroupDetail] (   @strPayrollCompany  ,'1/1/' + @strEndYear, '3/31/' + @strEndYear ,@intGrouping)

-- Total earnings grouped by CFSE Class between 4/1/EndYear and 6/30/EndYear
INSERT INTO @tblCFSEReport
SELECT 	strCompanyName	, @strEndYear	,@strEndYear  + ' 2nd QTR '  as strQuarter,
	dtStartDate,
	dtEndDate		,
	strGrouping		,
	intUserCovered ,
	strCFSECode		,
	decCFSEWages	,
	decCFSETaxPercent ,
	decCFSETaxOwed		,
	decCFSETaxContributed		 FROM [dbo].[fnPay_tblCFSECodeGroupDetail] (   @strPayrollCompany  ,'4/1/' + @strEndYear, '6/30/' + @strEndYear ,@intGrouping)


RETURN
END

GO
