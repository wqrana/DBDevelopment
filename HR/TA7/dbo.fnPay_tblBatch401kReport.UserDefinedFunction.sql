USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatch401kReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblBatch401kReport]
(
	@BATCHID as nvarchar(50)
)
RETURNS @tbl401kReport TABLE 
(
strBatchID  nvarchar(50), 
strPayrollCompany nvarchar(50), 
dtPayDate  date,
strCompany nvarchar(50), 
strDepartment nvarchar(50), 
strSubdepartment nvarchar(50),
strEmployeeType nvarchar(50),
intUserID  int, 
strUserName nvarchar(50),
strWithHoldingsName  nvarchar(50), 
decEmployeeWithholdingsAmount  decimal(18,2), 
decCompanyWithholdingsAmount  decimal(18,2),
intWithHoldingsQualifierID int, 
intQualifierValue int,
decPeriodWages  decimal(18,2),
strSSN nvarchar(50)
)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @PayrollCompany nvarchar(50)

	SELECT TOP(1) @PayrollCompany = strCompanyName from dbo.tblBatch where strBatchID = @BATCHID

	--Use the Batch End Date to know YTD
	INSERT INTO @tbl401kReport
	select  strBatchID, strCompanyName, dtPayDate,strCompany, strDepartment, strSubdepartment,strEmployeeType, intUserID, strusername, cww.strWithHoldingsName, 
	[dbo].[fnPay_BatchUserWithholdingNameAmount](strBatchID, intUserID,strWithHoldingsName) as EmployeeRetention,
	[dbo].[fnPay_BatchCompanyWithholdingNameAmount](strBatchID, intUserID,strWithHoldingsName) as EmployerMatch
	,cww.intWithHoldingsQualifierID, cww.intQualifierValue,ubs.decBatchUserCompensations
	,REPLACE(REPLACE(ubs.sSSN,'-',''),' ','')
	from viewPay_UserBatchStatus ubs 
	cross join (SELECT cw.strWithHoldingsName,wqi.intWithHoldingsQualifierID, wqi.intQualifierValue FROM tblCompanyWithholdings cw inner join tblWithholdingsQualifierItems wqi on cw.strWithHoldingsName = wqi.strWithHoldingsName 
	where wqi.intWithHoldingsQualifierID = 1 and [intQualifierValue] > 0 and cw.strCompanyName = @PayrollCompany) cww
	WHERE ubs.strBatchID = @BATCHID
	RETURN
END


GO
