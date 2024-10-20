USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_RemainingBalance]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro, Waqar
-- Create date: 7/7/2021
-- Description:	Balance one year from the date requested
-- =============================================

CREATE FUNCTION [dbo].[fnComp_RemainingBalance](@UserID int, @AccrualType varchar(50), @SearchDate datetime)
RETURNS  decimal(18,5)
AS
BEGIN
	DECLARE @BeginningBal  decimal(18,5);
	DECLARE @AccruedBal  decimal(18,5);
	DECLARE @TakenBal  decimal(18,5);
	DECLARE @BalanceDate date;
	DECLARE @ForwardYears int = 1
	
	--Get beginning balance for period and beginning date
	select  @BeginningBal = [dbo].fnComp_EndOfDayBalance(@UserID,@AccrualType,@SearchDate)
	select @TakenBal = [dbo].fnComp_UsedHours(@UserID,@AccrualType,dateadd(DAY,1, @SearchDate),dateadd(YEAR,1, @SearchDate))

   
	RETURN isnull(@BeginningBal,0) - isnull(@TakenBal,0)
END;
GO
