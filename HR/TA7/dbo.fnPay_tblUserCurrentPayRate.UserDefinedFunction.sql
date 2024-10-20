USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserCurrentPayRate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblUserCurrentPayRate]
(
	@PayrollCompany as nvarchar(50) ,
	@PayrollStatus int
)
RETURNS 
@tblUserCurrentPayRate TABLE 
(
	strCompanyName nvarchar(50),
	intUserID int,
	strUserNane nvarchar(50),
	dtRateStartDate date,
	intHourlyOrSalary int,
	decHourlyRate decimal(18,5),
	decHoursPerPeriod  decimal(18,5),
	dtHireDate date,
	intUserStatus int,
	strUserStatus nvarchar(50)

	) 
	-- WITH ENCRYPTION
AS
BEGIN

insert into @tblUserCurrentPayRate
SELECT
	strCompanyName,
	tU.ID,
	tU.name,
	tUPR.dtStartDate,
	tUPR.intHourlyOrSalary,
	CONVERT(decimal(18,5),
			CASE tUPR.intHourlyOrSalary
				WHEN 0 THEN	tUPR.decPayRate
				WHEN 1 THEN	tUPR.decPayRate / tUPR.decHoursPerPeriod
				ELSE decPayRate
			END) AS decHourlyRate,
	tUPR.decHoursPerPeriod,
	tu.dOriginalHiredDate HiredDate,
	tu.intPayrollUserStatus intUserStatus,
	tu.strStatusName strUserStatus
FROM 
	viewPay_UserRecord AS tU 
	LEFT OUTER JOIN 
	(select intUserID, dtStartDate,intHourlyOrSalary,decPayRate, decHoursPerPeriod  from tbluserpayrates upr inner join
	 (SELECT intuserid u, max(dtStartDate) dt from tblUserPayRates
		group  by intuserid ) tCurrent	
	ON		upr.intUserID = tCurrent.u AND upr.dtStartDate = tCurrent.dt) AS tUPR 
	ON tUPR.intUserID = tu.id 
	WHERE tu.strCompanyName = @PayrollCompany
	and (tu.intPayrollUserStatus = @PayrollStatus  OR @PayrollStatus = 2)
RETURN

END


GO
