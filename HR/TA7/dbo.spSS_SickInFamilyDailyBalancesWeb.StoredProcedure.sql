USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_SickInFamilyDailyBalancesWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 11/14/2021
-- Description:	to get the daily balances (Sick in Family) for time-off web
--			
-- =============================================
CREATE PROCEDURE [dbo].[spSS_SickInFamilyDailyBalancesWeb]
	@UserID as int,	
	@TransType as nvarchar(500),
	@StartDate as date,
	@EndDate as date
AS
BEGIN
	SET NOCOUNT ON;
		--	VALIDATE REQUEST

Select Id,AccrualType,BalanceDate,Balance
From(
	Select   
		u.id as Id,
		'SIF' as AccrualType, 
		thedate as BalanceDate, 
		dbo.fnComp_SickInFamilyBalance(u.id, @TransType, @StartDate) as Balance,	
		dbo.fnSS_GetScheduledDayCount(u.id,TheDate,TheDate) as IsWorkingDay
	From DateCalendar dc 
	Cross Join tuser u 	
	where thedate between @StartDate and @EndDate 
	And u.id = @UserID
	And nStatus = 1
	) UserDailyBalances
Where IsWorkingDay=1
Order by BalanceDate
	
END

GO
