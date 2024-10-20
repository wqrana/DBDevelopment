USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_CompensationDailyBalancesWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 11/14/2021
-- Description:	to get daily balances for time-off web
--	Modification
-- remove the join tUserCompensationBalances to avoid duplicate rows
-- =============================================
CREATE PROCEDURE [dbo].[spSS_CompensationDailyBalancesWeb]
	@UserID as int,	
	@AccrualType as nvarchar(500),
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
		@AccrualType as AccrualType, 
		thedate as BalanceDate, 
		dbo.fnComp_EndOfDayBalance(u.id, @AccrualType, TheDate) as Balance,	
		dbo.fnSS_GetScheduledDayCount(u.id,TheDate,TheDate) as IsWorkingDay
	From DateCalendar dc 
	Cross Join tuser u 
	-- Join tUserCompensationBalances ucb on u.id = ucb.nUserID
	where thedate between @StartDate and @EndDate 
	And u.id = @UserID
	--And ucb.sAccrualType=@AccrualType
	And nStatus = 1
	) UserDailyBalances
Where IsWorkingDay=1
Order by BalanceDate
	
END
GO
