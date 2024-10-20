USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPayRegister_ER]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/05/2018
-- Description:	For Pay register Report with Employer Data
---				Takes into account Payroll Company
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchPayRegister_ER]
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
	intReportOrder  int,
	decContribution decimal(18,2),
	decContributionYTD  decimal(18,2)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Compensations in order stated
	insert into @tblBatchPayRegister
		SELECT ubs.strBatchID, ubs.intUserID as intUserID, ubs.strUserName as strUserName, ubs.sSSN as strSocialSecurityName, ubs.strBatchDescription as strBatchDescription, ubs.dtPayDate as dtPayDate ,
	ubs.decBatchUserCompensations as decGrossPay, ubs.decBatchNetPay as decNetPay, ubs.decBatchUserWithholdings as decNetWithholdings, 
	cc.strCompensationName as strPayItem, 
	iif(uc.decHours is null, 0,uc.decHours )  as decPayHours,
	iif(uc.decPay is null,0,uc.decPay) ,
	[dbo].[fnPay_YearToDateUserBatchcompensations](ubs.intUserID,cc.strCompensationName,ubs.dtPayDate,ubs.strCompanyName) as decPayYTD
	, cc.intReportOrder  
	,0 as decContribution,0 as decContributionYTD
	 FROM tblCompanyCompensations cc left outer join viewPay_UserBatchStatus ubs ON cc.strCompanyName = ubs.strCompanyName
	 left outer join [dbo].[fnPay_tblUserCompensationsYTD](	@BATCHID) uc on uc.strCompensationName = cc.strCompensationName and ubs.strBatchID = uc.strBatchID and ubs.intUserID = uc.intUserID
	where ubs.strBatchID = @BATCHID
	ORDER BY ubs.intUserID, cc.intReportOrder  
	
	--Withholdings in order stated
	insert into @tblBatchPayRegister
	SELECT ubs.strBatchID, ubs.intUserID as intUserID, ubs.strUserName as strUserName, ubs.sSSN as strSocialSecurityName, ubs.strBatchDescription as strBatchDescription, ubs.dtPayDate as dtPayDate ,
	ubs.decBatchUserCompensations as decGrossPay, ubs.decBatchNetPay as decNetPay, ubs.decBatchUserWithholdings as decNetWithholdings, 
	cw.strWithHoldingsName as strPayItem, 0 as decPayHours,
	iif(uw.decWithholdingsAmount is null,0,uw.decWithholdingsAmount)  as decPay, 
	iif(uw.decWithholdingsYTD is null,0,uw.decWithholdingsYTD)   as decPayYTD , cw.intReportOrder 
	,[dbo].[fnPay_BatchCompanyWithholdingNameAmount](@BATCHID,ubs.intUserID,cw.strWithholdingsName) as decContribution
	,[dbo].[fnPay_YTDUserCompanyBatchWithholdings](cw.strWithholdingsName,ubs.intUserID,ubs.dtPayDate,ubs.strCompanyName) as decContributionYTD
	FROM tblCompanyWithholdings cw  left outer join viewPay_UserBatchStatus ubs ON cw.strCompanyName = ubs.strCompanyName
	left outer join [dbo].[fnPay_tblUserWithholdingsYTD] (	@BATCHID) uw on uw.strWithHoldingsName = cw.strWithHoldingsName and ubs.strBatchID = uw.strBatchID and ubs.intUserID = uw.intUserID
	WHERE ubs.strBatchID = @BATCHID
	ORDER BY ubs.intUserID

	
	RETURN
END

GO
