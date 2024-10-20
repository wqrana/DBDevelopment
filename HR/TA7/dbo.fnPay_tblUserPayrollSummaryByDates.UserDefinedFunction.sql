USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserPayrollSummaryByDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Returnd the YearToDate Withholdings of an User
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblUserPayrollSummaryByDates]
(	
	-- Add the parameters for the function here
	@STARTDATE date,
	@ENDDATE date
)
RETURNS 
@tblUserBatchSummary TABLE 
(
	intUserID  int,
	strUserName nvarchar(50),
	strItemsName nvarchar(50),
	decItemsAmount decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @tblUserBatchSummary
	SELECT intUserID,ue.sEmployeeName, strCompensationName, decPay FROM [dbo].[tblUserBatchCompensations] ubc inner join tUserExtended ue on ubc.intUserID = ue.nUserID
	WHERE dtPayDate BETWEEN @STARTDATE AND @ENDDATE and ubc.boolDeleted = 0

	insert into @tblUserBatchSummary
	SELECT intUserID,ue.sEmployeeName, strWithHoldingsName, decWithholdingsAmount FROM [dbo].[tblUserBatchWithholdings] ubw inner join tUserExtended ue on ubw.intUserID = ue.nUserID
	WHERE dtPayDate BETWEEN @STARTDATE AND @ENDDATE

	RETURN
END

GO
