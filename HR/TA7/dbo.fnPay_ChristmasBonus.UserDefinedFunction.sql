USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Hours
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonus]
(
	@PayrollCompany as nvarchar(50) ,
	@BonusYear int
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
	DECLARE @StartDate as date = '10/1/'+ cast( @BonusYear-1 as varchar(4))
	DECLARE @EndDate as date = '9/30/'+ cast( @BonusYear-1 as varchar(4))
	DECLARE @NewLawStartDate as date = '1/26/2017'
	DECLARE @CompanySize as integer

	--Check the employees that are in payroll 
	SELECT DISTINCT @CompanySize =  count( intUserID) from viewPay_UserBatchStatus where dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany

	--Select employees that old law applies
	INSERT INTO @tblUserChristmasBonusSummary
	select distinct B.intUserID,ue.sEmployeeName, u.idno,  B.decHoursWorked,B.decGrossPay,B.decBonusPercent,B.decBonusAmount, ue.dOriginalHiredDate  
	from viewPay_UserBatchStatus ubs inner join tUserExtended ue on ubs.intUserID = ue.nUserID 
	inner join tuser u on u.id = ubs.intUserID
	CROSS APPLY (SELECT * FROM [dbo].[fnPay_ChristmasBonusPre2017] (
   ubs.intUserID 
  ,@CompanySize
  ,@BonusYear)) B
  where dOriginalHiredDate < @NewLawStartDate and strCompanyName = @PayrollCompany


--Select employees that New law applies
	INSERT INTO @tblUserChristmasBonusSummary
	select distinct B.intUserID,ue.sEmployeeName, u.idno,  B.decHoursWorked,B.decGrossPay,B.decBonusPercent,B.decBonusAmount, ue.dOriginalHiredDate 
	from viewPay_UserBatchStatus ubs inner join tUserExtended ue on ubs.intUserID = ue.nUserID 
	inner join tuser u on u.id = ubs.intUserID
	CROSS APPLY (SELECT * FROM [dbo].[fnPay_ChristmasBonus2017] (
   ubs.intUserID 
  ,@CompanySize
  ,@BonusYear)) B
  where dOriginalHiredDate >= @NewLawStartDate and strCompanyName = @PayrollCompany

RETURN
END


GO
