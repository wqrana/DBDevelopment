USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus_Dates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Version 2023: go back to the beginning
-- =============================================
CREATE FUNCTION [dbo].[fnPay_ChristmasBonus_Dates]
(
	@PayrollCompany as nvarchar(50) ,
	@StartDate date,
	@EndDate  date,
	@PayrollStatus int,
	@Pymes int = 0
)
RETURNS 
@tblUserChristmasBonusSummary TABLE 
(
	intUserID  int,
	strUserName nvarchar(50),
	strIDNumber nvarchar(50),
	decHoursWorked decimal(18,2),
	decGrossPay decimal(18,2),
	decBonusPercent decimal(18,5),
	decBonusAmount decimal(18,2),
	dtHiredDate date

) 
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @NewLawStartDate as date = '1/26/2017'
	DECLARE @CompanySize as integer

	--Check the employees that are in payroll 
	SELECT DISTINCT @CompanySize =  count( intUserID) from viewPay_UserBatchStatus where dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany

	--Select employees that old law applies
	INSERT INTO @tblUserChristmasBonusSummary
	select distinct B.intUserID,ue.sEmployeeName, u.idno,  B.decHoursWorked,B.decGrossPay,B.decBonusPercent,B.decBonusAmount, ue.dOriginalHiredDate  
	from viewPay_UserBatchStatus ubs inner join tUserExtended ue on ubs.intUserID = ue.nUserID 
	inner join tuser u on u.id = ubs.intUserID
	CROSS APPLY (SELECT * FROM [dbo].[fnPay_ChristmasBonusPre2017_Dates] (
   ubs.intUserID 
  ,@CompanySize
  ,@StartDate, @EndDate,@PayrollCompany)) B
  where dOriginalHiredDate < @NewLawStartDate and strCompanyName = @PayrollCompany
  and u.id in (select distinct ubs.intUserID from viewPay_UserBatchStatus ubs inner join tblUserCompanyPayroll ucp on ubs.intUserID = ucp.intUserID WHERE (ucp.intPayrollUserStatus = @PayrollStatus OR @PayrollStatus = -2) and ubs.strCompanyName = @PayrollCompany)

--Select employees that New law applies
	INSERT INTO @tblUserChristmasBonusSummary
	select distinct B.intUserID,ue.sEmployeeName, u.idno,  B.decHoursWorked,B.decGrossPay,B.decBonusPercent,B.decBonusAmount, ue.dOriginalHiredDate 
	from viewPay_UserBatchStatus ubs inner join tUserExtended ue on ubs.intUserID = ue.nUserID 
	inner join tuser u on u.id = ubs.intUserID
	CROSS APPLY (SELECT * FROM [dbo].[fnPay_ChristmasBonus2017_Dates] (
   ubs.intUserID 
  ,@CompanySize
  ,@StartDate, @EndDate,@PayrollCompany)) B
  where dOriginalHiredDate >= @NewLawStartDate and strCompanyName = @PayrollCompany
  and u.id in (select distinct ubs.intUserID from viewPay_UserBatchStatus ubs inner join tblUserCompanyPayroll ucp on ubs.intUserID = ucp.intUserID WHERE (ucp.intPayrollUserStatus = @PayrollStatus OR @PayrollStatus = -2) and ubs.strCompanyName = @PayrollCompany)

RETURN
END


GO
