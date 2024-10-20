USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPayRegister]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Pay register Report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchPayRegister]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblBatchPayRegister TABLE 
(
	strBatchID nvarchar(50),
	intUserID int,
	strUserName nvarchar(50), 
	strSocialSecurityName nvarchar(50),
	strBatchDescription nvarchar(50),
	dtPayDate  date,
	decGrossPay decimal(18,2),
	decNetPay decimal(18,2),
	decNetWithholdings decimal(18,2),
	strPayItem nvarchar(50),
	decPayHours decimal(18,2),
	decPay decimal(18,2),
	decPayYTD  decimal(18,2),
	intReportOrder  int
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Compensations in order stated
	insert into @tblBatchPayRegister
	SELECT ubs.strBatchID, ubs.intUserID as intUserID, ubs.strUserName as strUserName, ubs.sSSN as strSocialSecurityName, ubs.strBatchDescription as strBatchDescription, ubs.dtPayDate as dtPayDate ,
	ubs.decBatchUserCompensations as decGrossPay, ubs.decBatchNetPay as decNetPay, ubs.decBatchUserWithholdings as decNetWithholdings, 
	uc.strCompensationName as strPayItem, uc.decHours as decPayHours,uc.decPay as decPay, uc.decPayYTD as decPayYTD, cc.intReportOrder  
	 FROM [dbo].[fnPay_tblUserCompensationsYTD](
	@BATCHID) uc inner join viewPay_UserBatchStatus ubs ON uc.intUserID = ubs.intUserID and uc.strBatchID = ubs.strBatchID
	inner join tblCompanyCompensations cc on uc.strCompensationName = cc.strCompensationName and ubs.strCompanyName = cc.strCompanyName
	where ubs.strBatchID = @BATCHID
	ORDER BY ubs.intUserID , cc.intReportOrder  asc
	
	--Withholdings in order stated
	insert into @tblBatchPayRegister
	SELECT ubs.strBatchID, ubs.intUserID as intUserID, ubs.strUserName as strUserName, ubs.sSSN as strSocialSecurityName, ubs.strBatchDescription as strBatchDescription, ubs.dtPayDate as dtPayDate ,
	ubs.decBatchUserCompensations as decGrossPay, ubs.decBatchNetPay as decNetPay, ubs.decBatchUserWithholdings as decNetWithholdings, 
	uw.strWithHoldingsName as strPayItem, 0 as decPayHours,uw.decWithholdingsAmount as decPay, uw.decWithholdingsYTD as decPayYTD , cw.intReportOrder 
	FROM [dbo].[fnPay_tblUserWithholdingsYTD] (
	@BATCHID) uw inner join viewPay_UserBatchStatus ubs ON uw.intUserID = ubs.intUserID and uw.strBatchID = ubs.strBatchID
	inner join tblCompanyWithholdings cw on uw.strWithHoldingsName = cw.strWithHoldingsName and ubs.strCompanyName = cw.strCompanyName
	where ubs.strBatchID = @BATCHID
	ORDER BY ubs.intUserID, cw.intReportOrder asc
	
	RETURN
END

GO
