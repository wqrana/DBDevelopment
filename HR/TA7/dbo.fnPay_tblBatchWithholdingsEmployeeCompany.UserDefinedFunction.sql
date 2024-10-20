USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchWithholdingsEmployeeCompany]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-04-21
-- Description:		Gets the data for all withholdings with Employee and Company Contributions
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblBatchWithholdingsEmployeeCompany]
(
	@BATCHID as nvarchar(50)
)
RETURNS @tblBatchWithholdingsEmployeeCompany TABLE 
(
strBatchID  nvarchar(50), 
strPayrollCompany nvarchar(50), 
strCompany nvarchar(50), 
strDepartment nvarchar(50), 
strSubdepartment nvarchar(50),
strEmployeeType nvarchar(50),
intUserID  int, 
strUserName nvarchar(50),
strWithHoldingsName  nvarchar(50), 
decEmployeeWithholdingsAmount  decimal(18,2), 
decCompanyWithholdingsAmount  decimal(18,2),
intReportOrder int
)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @PayrollCompany nvarchar(50)

	SELECT TOP(1) @PayrollCompany = strCompanyName from dbo.tblBatch where strBatchID = @BATCHID

	--Use the Batch End Date to know YTD
	INSERT INTO @tblBatchWithholdingsEmployeeCompany
	select strBatchID, strCompanyName, strCompany, strDepartment, strSubdepartment,strEmployeeType, intUserID, strusername, cww.strWithHoldingsName, 
	[dbo].[fnPay_BatchUserWithholdingNameAmount](strBatchID, intUserID,strWithHoldingsName) as EmployeeRetention,
	[dbo].[fnPay_BatchCompanyWithholdingNameAmount](strBatchID, intUserID,strWithHoldingsName) as EmployerMatch,
	cww.intReportOrder
	from viewPay_UserBatchStatus ubs 
	cross join (SELECT cw.strWithHoldingsName, cw.intReportOrder FROM tblCompanyWithholdings cw 
	where cw.strCompanyName = @PayrollCompany) cww
	WHERE ubs.strBatchID = @BATCHID	RETURN
END




GO
