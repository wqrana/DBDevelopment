USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayRateChangeReport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/10/2022
-- Description:	Pay Rates Change report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblPayRateChangeReport]
(
	@PayrollCompany as nvarchar(50) ,
	@StartDate date,
	@EndDate  date,
	@PayrollStatus int
)
RETURNS TABLE
AS
RETURN
	SELECT * FROM 
	(Select 
	upr.intUserID as ID,
	name as Name,
	strCompanyName as Company,
	sDeptName as Department,
	strPositionName as Position,
	sjobtitlename as Subdept,
	dtStartDate as 'Salary change date',
	LAG(decPayRate, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc) 'Salary before change',
	decPayRate 'Salary after Change',

	--Subtract current yearly wages - previous yearly wages to get "annual amount change" column
	(decYearlyWages - LAG(decYearlyWages, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc)) 'Annual amount change',

	-- "Annual amount change" column divided by "Annual salary before change" column multiply by 100 to get Percentage change column
	IIF(ISNULL(LAG(decYearlyWages, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc),0) = 0, 0,
	(isnull((decYearlyWages - LAG(decYearlyWages, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc)) 
	/ LAG(decYearlyWages, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc) * 100,0))) '% change',

	decHoursPerPeriod as 'Biweekly hours',
	sEmployeeTypeName as 'Salary or Hourly',
	LAG(decYearlyWages, 1,0) OVER (PARTITION BY upr.intuserid ORDER BY dtStartDate asc) 'Annual salary before change',
	decYearlyWages 'Annual salary after change',
	intPayrollUserStatus PayrollStatusID

	from tblUserPayRates upr
	join viewPay_UserRecord ur
	on upr.intUserID = ur.intUserID
	where dtStartDate between '1/1/1900' and @EndDate
	) PR where [Salary change date] between @StartDate and @EndDate 
	and Company = @PayrollCompany and (PayrollStatusID = @PayrollStatus OR @PayrollStatus  = 2)

GO
