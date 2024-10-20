USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblYearToDateCompanyWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/05/2018
-- Description:	Returns the YearToDate Withholdings of an User
--				Takes into account Payroll Company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblYearToDateCompanyWithholdings]
(	
	-- Add the parameters for the function here
	@USERID int,
	@SEARCHDATE datetime,
	@CompanyName nvarchar(50)
)
RETURNS 
@tblYearToDateCompanyWithholdingss TABLE 
(
	intUserID  int,
	strWithHoldingsName nvarchar(50),
	strDescription nvarchar(50),
	decWithholdingsYTD decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @tblYearToDateCompanyWithholdingss
	SELECT DISTINCT cbw.intUserID, cbw.strWithHoldingsName, cw.strDescription,  [dbo].[fnPay_YearToDateCompanyBatchWithholdings](intUserID,cbw.strWithHoldingsName,@SEARCHDATE,cbw.strCompanyName)  as decWithholdingsYTD
	FROM [dbo].viewPay_CompanyBatchWithholdings cbw inner join tblCompanyWithholdings cw 
	on cbw.strWithHoldingsName = cw.strWithHoldingsName and cbw.strCompanyName = cw.strCompanyName
	WHERE cbw.intUserID = @USERID and cbw.strCompanyName = @CompanyName
	RETURN
END

GO
