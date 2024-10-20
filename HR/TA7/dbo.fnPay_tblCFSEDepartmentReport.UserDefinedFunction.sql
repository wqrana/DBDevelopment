USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCFSEDepartmentReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 7/16/2020
-- Description:	Returns the CFSE 
--				 Takes into account the maximum pay for each withholding for SINOT, Choferil
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCFSEDepartmentReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date,
	@WithholdingName nvarchar(50)
)
RETURNS @tblCFSEDepartmentReport TABLE 
(
	strPayrollCompany  nvarchar(50), 
	strUSSN nvarchar(50),
	strUserName nvarchar(50),
	strWithholdingName	nvarchar(50), 
	strDepartment  nvarchar(50), 
	decTaxablePay decimal(18,2),
	strCFSECode  nvarchar(50)
)
-- WITH ENCRYPTION
AS
BEGIN
	IF NOT EXISTS (SELECT 1 from tblWithholdingsItems where strWithHoldingsName = @WithholdingName)
		SET @WithholdingName = 'WORKERS COMP'

	INSERT @tblCFSEDepartmentReport
	select @PayrollCompany
	,sSSN
	,max(ubc.strUserName) strUserName
	,@WithholdingName strWithholdingName
	,max(isnull(strDepartment,'')) as strDepartment
	, sum(isnull(decPay,0)) decPay
	,isnull(max(uwi.strClassIdentifier),0) as CFSECode
	
	FROM 	viewPay_UserBatchCompensations  ubc inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
	left outer join tblUserWithholdingsItems uwi on ubc.intUserID = uwi.intUserID and strWithHoldingsName = @WithholdingName
	where 
	ubc.strCompanyName = @PayrollCompany 
	AND ci.intCompensationType = 1
	AND ubc.decPay <> 0
	AND ubc.intUserID IN (select intUserID from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName and decCompanyPercent <> 0  )
	AND dtPayDate between @STARTDATE and @ENDDATE
	group by sSSN

RETURN
END

GO
