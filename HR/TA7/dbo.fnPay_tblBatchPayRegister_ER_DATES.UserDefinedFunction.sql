USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPayRegister_ER_DATES]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/05/2018
-- Description:	For Pay register Report with Employer Data
--				User Start Date and End Date for Query
--				Takes into account Payroll Company
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchPayRegister_ER_DATES]
(	
	-- Add the parameters for the function here
	@COMPANY_NAME nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
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
	SELECT '' as strBatchID, UCP.intUserID as intUserID, sEmployeeName as strUserName, sSSN as strSocialSecurityName
	, 'Dates: ' +convert(VARCHAR(24), @STARTDATE, 101) + ' to ' + CONVERT(varchar(24), @ENDDATE,101) as strBatchDescription, @ENDDATE 
	,0 as decGrossPay, 0 as decNetPay, 0 as decNetWithholdings
	,cw.strCompensationName, iif(decPayHours is null, 0, decPayHours) as decPayHours , iif(decPay is null, 0, decPay) as decPay
	,[dbo].[fnPay_YearToDateUserBatchcompensations](ucp.intUserID, cw.strCompensationName,@ENDDATE,cw.strCompanyName )as decPayYTD, cw.intReportOrder
	, 0 as decContribution
	,0 as decContributionYTD
	 FROM 
	 tblCompanyCompensations cw  
	inner join
	(select strCompanyName, intUserID, ue.sEmployeeName,ue.sSSN from tblUserCompanyPayroll ucp1 inner join tUserExtended ue on ucp1.intUserID = ue.nUserID
		WHERE strCompanyName = @COMPANY_NAME ) UCP ON cw.strCompanyName = ucp.strCompanyName
	left outer join 
	(SELECT ubw.intUserID, strCompensationName as strPayItem
	, sum(decHours) as decPayHours
	 ,sum(decPay) as decPay 
	, [dbo].[fnPay_YearToDateUserBatchWithholdings](ubw.intUserID, strCompensationName,max(ubw.dtPayDate),@COMPANY_NAME  )as decPayYTD
	,[dbo].[fnPay_YTDUserCompanyBatchWithholdings](strCompensationName,ubw.intUserID,max(ubw.dtPayDate),@COMPANY_NAME) as decContributionYTD
	,max(ubs.strUserName) as strUserName,max(ubs.sSSN) as strSocialSecurityName
	, max(strCompanyName) as strCompanyName
	,max(ubs.strBatchID) as strBatchID
	FROM tblUserBatchCompensations ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	where ubw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE and ubs.strCompanyName = @COMPANY_NAME
	GROUP BY ubw.intUserID, strCompensationName ) UW 
	on cw.strCompensationName = uw.strPayItem  and uw.intUserID = ucp.intUserID
	ORDER BY uw.intUserID, cw.intReportOrder asc
	
	--Withholdings in order stated
	insert into @tblBatchPayRegister
	SELECT '' as strBatchID, UCP.intUserID as intUserID, sEmployeeName as strUserName, sSSN as strSocialSecurityName
	, 'Dates: ' +convert(VARCHAR(24), @STARTDATE, 101) + ' to ' + CONVERT(varchar(24), @ENDDATE,101) as strBatchDescription, @ENDDATE 
	,0 as decGrossPay, 0 as decNetPay, 0 as decNetWithholdings
	,cw.strWithHoldingsName, iif(decPayHours is null, 0, decPayHours) as decPayHours, iif(decPay is null, 0, decPay) as decPay
	,[dbo].[fnPay_YearToDateUserBatchWithholdings](ucp.intUserID, cw.strWithHoldingsName,@ENDDATE,@COMPANY_NAME  )as decPayYTD, cw.intReportOrder
	, [dbo].[fnPay_CompanyBatchWithholdings_ByDates](ucp.intUserID,cw.strWithHoldingsName,@STARTDATE,@ENDDATE ) as decContribution
	,[dbo].[fnPay_YTDUserCompanyBatchWithholdings](cw.strWithholdingsName,UCP.intUserID,@ENDDATE,@COMPANY_NAME) as decContributionYTD
	 FROM 
	 tblCompanyWithholdings cw  
	inner join
	(select strCompanyName, intUserID, ue.sEmployeeName,ue.sSSN from tblUserCompanyPayroll ucp1 inner join tUserExtended ue on ucp1.intUserID = ue.nUserID ) UCP ON cw.strCompanyName = ucp.strCompanyName
	left outer join 
	(SELECT ubw.intUserID, strWithHoldingsName as strPayItem, 0 as decPayHours
	 ,sum(decWithholdingsAmount) as decPay 
	, [dbo].[fnPay_YearToDateUserBatchWithholdings](ubw.intUserID, strWithHoldingsName,max(ubw.dtPayDate) ,@COMPANY_NAME  )as decPayYTD
	,[dbo].[fnPay_YTDUserCompanyBatchWithholdings](strWithholdingsName,ubw.intUserID,max(ubw.dtPayDate),@COMPANY_NAME) as decContributionYTD
	,max(ubs.strUserName) as strUserName,max(ubs.sSSN) as strSocialSecurityName
	, max(strCompanyName) as strCompanyName
	,max(ubs.strBatchID) as strBatchID
	FROM tblUserBatchWithholdings ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	where ubw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE 
	GROUP BY ubw.intUserID, strWithHoldingsName ) UW 
	on cw.strWithHoldingsName = uw.strPayItem  and uw.intUserID = ucp.intUserID
	ORDER BY uw.intUserID, cw.intReportOrder


	
	RETURN
END


GO
