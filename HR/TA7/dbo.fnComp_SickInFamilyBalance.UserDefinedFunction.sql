USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_SickInFamilyBalance]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnComp_SickInFamilyBalance](@UserID int, @TransType varchar(50), @SearchDate datetime)
RETURNS  decimal(18,5)
AS
BEGIN
	DECLARE @AccrualType varchar(50);
	DECLARE @AccrualTypeBal  decimal(18,5);	
	DECLARE @SIFTakenBal  decimal(18,5);
	DECLARE @BalanceStartDate datetime;
	DECLARE @BalanceEndDate datetime;
	DECLARE @MinAccrualTypeBal decimal(18,5)
	DECLARE @MaxYearlyTaken decimal(18,5)
	DECLARE @SIFBalance decimal(18,5)

	SELECT Top 1 @AccrualType= IsNull(sAccrualImportName,'SA'),
				 @MinAccrualTypeBal= IsNull(decMinimumAccrualTypeBalance,0.0),
				 @MaxYearlyTaken = IsNull(decMaximumYearlyTaken,0.0)
	FROM tTransdef
	WHERE Name = @TransType
		
	----Get beginning balance for period and beginning date

	select @AccrualTypeBal =  dbo.fnComp_RemainingBalance(@UserID,@AccrualType,@SearchDate) 
	Set @BalanceStartDate = FORMAT(@SearchDate,'yyyy')+'-01-01'
	set @BalanceEndDate= DATEADD(day,-1,DATEADD(year,1,@BalanceStartDate))
	----Taken within the current year. 
	SELECT @SIFTakenBal = dbo.fnComp_SickInFamilyUsedHours(@UserID , @TransType,@BalanceStartDate, @BalanceEndDate)

	if(@AccrualTypeBal<@MinAccrualTypeBal)
	 set @SIFBalance=0
	else if(@SIFTakenBal=@MaxYearlyTaken)
	 set @SIFBalance=0
	else if((@AccrualTypeBal-@MinAccrualTypeBal)<(@MaxYearlyTaken-@SIFTakenBal))
	  set @SIFBalance=(@AccrualTypeBal-@MinAccrualTypeBal)
	else if((@MaxYearlyTaken-@SIFTakenBal)<=(@AccrualTypeBal-@MinAccrualTypeBal))
	  set @SIFBalance=(@MaxYearlyTaken-@SIFTakenBal)
  
	RETURN @SIFBalance
END;

GO
