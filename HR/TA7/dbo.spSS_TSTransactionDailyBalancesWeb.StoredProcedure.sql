USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_TSTransactionDailyBalancesWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 2/12/2024
-- Description:	to get daily balances for time-sheet editor tranaction web

-- =============================================
CREATE PROCEDURE [dbo].[spSS_TSTransactionDailyBalancesWeb]
	@UserID as int,	
	@AccrualType as nvarchar(50),
	@TransType as nvarchar(50),
	@StartDate as date,
	@EndDate as date
AS
BEGIN
	SET NOCOUNT ON;
if @AccrualType!='SIF'
begin
	Select Id,AccrualType,BalanceDate,Balance
	From(
		Select   
			u.id as Id,
			@AccrualType as AccrualType, 
			thedate as BalanceDate, 
			--dbo.fnComp_EndOfDayBalance(u.id, @AccrualType, TheDate) as Balance
			dbo.fnComp_RemainingBalance(u.id, @AccrualType, TheDate) as Balance
		From DateCalendar dc 
		Cross Join tuser u 	
		where thedate between @StartDate and @EndDate 
		And u.id = @UserID
	   ) as userBalances	
	Order by BalanceDate
end
else
begin
	Select Id,AccrualType,BalanceDate,Balance
	From(
		Select   
			u.id as Id,
			@AccrualType as AccrualType, 
			thedate as BalanceDate, 
			dbo.fnComp_SickInFamilyBalance(u.id, @TransType, @StartDate) as Balance			
		From DateCalendar dc 
		Cross Join tuser u 	
		where thedate between @StartDate and @EndDate 
		And u.id = @UserID
	   ) as userBalances	
	Order by BalanceDate
	end
END
GO
