USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPRICHTotalBenefits]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================
-- Author:		Alexander Rivera Toro
-- Create date: 04/17/2020
-- Description:	For PRIC Total Benefits Export
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPRICHTotalBenefits]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblPRICHTotalBenefits TABLE 
(
	strCompanyName nvarchar(50),
	strDepartment nvarchar(50), 
	intUserI  int,
	strUserName nvarchar(50),
	sSex nvarchar(50), 
	HiredDate nvarchar(50),
	YearServices nvarchar(50),
	sFullPartTimeCode nvarchar(50),
	strEmployeeType nvarchar(50),
	HourlyRate decimal(18,5),
	Salary decimal(18,5),
	SpecialAdjustments decimal(18,5),
	RegularHours decimal(18,5),
	SickHours decimal(18,5),
	VacationHours decimal(18,5),
	OvertimeHours decimal(18,5),
	Total decimal(18,5),
	CHOFERIL decimal(18,5),
	SINOT decimal(18,5),
	FUTA decimal(18,5),
	SUTA decimal(18,5),
	FICA decimal(18,5),
	TotalBenefits decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
INSERT INTO @tblPRICHTotalBenefits 
select 
isnull(ubs.strCompanyName,'') as strCompanyName,
isnull(ubs.strDepartment,'') as strDepartment,
ubs.intUserID,
isnull(ubs.strUserName,'NO_NAME') as strUserName,
isnull(ue.sSex,'') as sSex,
isnull(ue.dOriginalHiredDate,'') as HiredDate ,
iif(isnull(ue.dOriginalHiredDate,0)=0,0, DATEDIFF(YEAR,ubs.dtPayDate, ue.dOriginalHiredDate)) YearServices,
isnull(ue.sFullPartTimeCode,'') as sFullPartTimeCode,
isnull(ubs.strEmployeeType,'') as strEmployeeType,
isnull(dbo.fnPay_GetHourlyRate(ubs.intUserID, ubs.dtPayDate),0) HourlyRate,
isnull((select top(1) upr.decPeriodGrossPay from tblUserPayRates upr where upr.intUserID = ubs.intUserID and upr.dtStartDate <= ubs.dtPayDate order by upr.dtStartDate desc),0) Salary,
0 as SpecialAdjustments,
isnull((select sum(decPay) from tblUserBatchCompensations where strCompensationName IN ('Regular Wages') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as RegularHours,
isnull((select sum(decPay) from tblUserBatchCompensations where strCompensationName IN ('Sick') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as SickHours,
isnull((select sum(decPay) from tblUserBatchCompensations where strCompensationName IN ('Vacation') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as VacationHours,
isnull((select sum(decPay) from tblUserBatchCompensations where strCompensationName IN ('Overtime','Overtime 2X') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as OVertimeHours,
isnull(ubs.decBatchUserCompensations,0) Total,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where strWithHoldingsName IN ('Choferil') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as CHOFERIL,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where strWithHoldingsName IN ('SINOT') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as SINOT,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where strWithHoldingsName IN ('FUTA') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as FUTA,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where strWithHoldingsName IN ('SUTA') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as SUTA,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS') and intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as FICA,
isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings WHERE intUserID = ubs.intUserID and strBatchID = ubs.strBatchID),0) as TotalBenefits
from viewPay_UserBatchStatus ubs inner join tUserExtended ue on ubs.intUserID = ue.nUserID 
where strBatchID = @BATCHID
RETURN
END
GO
