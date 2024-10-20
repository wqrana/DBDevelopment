USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spUpdsert_UserCompensationMonthly]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdsert_UserCompensationMonthly]
@nUserID as int, 
@sAccrualType as nvarchar(50),  
@dblAccruedHours as decimal(18,5), 
@dEffectiveDate as smalldatetime, 
@dblAccrualDailyHours as decimal(18,5), 
@sAccrualDays as nvarchar(50), 
@dPeriodStartDate as smalldatetime, 
@dPeriodEndDate as smalldatetime, 
@dblAccrualComputedHours as decimal(18,5)
AS
BEGIN
	update tUserCompensationMonthly set 
	nUserID = @nUserID , 
	sAccrualType = @sAccrualType ,  
	dblAccruedHours=@dblAccruedHours , 
	dEffectiveDate =@dEffectiveDate , 
	dblAccrualDailyHours =@dblAccrualDailyHours , 
	sAccrualDays =@sAccrualDays , 
	dPeriodStartDate =@dPeriodStartDate , 
	dPeriodEndDate = @dPeriodEndDate , 
	dblAccrualComputedHours = @dblAccrualComputedHours 
	WHERE nUserID = @nUserID AND sAccrualType = @sAccrualType AND dEffectiveDate =@dEffectiveDate

	if @@ROWCOUNT = 0
	BEGIN

	insert into tUserCompensationMonthly (
	nUserID, 
	sAccrualType, 
	dblAccruedHours, 
	dEffectiveDate, 
	dblAccrualDailyHours, 
	sAccrualDays, 
	dPeriodStartDate, 
	dPeriodEndDate, 
	dblAccrualComputedHours
		)
	VALUES
		(
	@nUserID , 
	@sAccrualType ,  
	@dblAccruedHours , 
	@dEffectiveDate , 
	@dblAccrualDailyHours , 
	@sAccrualDays , 
	@dPeriodStartDate , 
	@dPeriodEndDate , 
	@dblAccrualComputedHours 
		)
END

END
return @@ROWCOUNT

/****** Object:  Table [dbo].[tUserCompensationComputedBalances]    Script Date: 11/9/2015 9:19:19 AM ******/
SET ANSI_NULLS ON
GO
