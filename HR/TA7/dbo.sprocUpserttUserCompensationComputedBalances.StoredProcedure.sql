USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sprocUpserttUserCompensationComputedBalances]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprocUpserttUserCompensationComputedBalances]
           (
		   @nUserID as  int
           ,@sAccrualType as  nvarchar(30)
           ,@dblAccruedHours as  decimal(18,5)
           ,@dBalanceStartDate as  datetime
           ,@dblAccrualDailyHours as  decimal(18,5)
           ,@sAccrualDays as nvarchar(50)
           ,@nSuperID  as int
           ,@dtModifiedDate as smalldatetime
		   )
AS 
BEGIN
	DECLARE @Ret as int
	
	UPDATE [dbo].[tUserCompensationComputedBalances]
	SET [nUserID] = @nUserID
      ,[sAccrualType] = @sAccrualType
      ,[dblAccruedHours] = @dblAccruedHours
      ,[dBalanceStartDate] = @dBalanceStartDate
      ,[dblAccrualDailyHours] = @dblAccrualDailyHours
      ,[sAccrualDays] = @sAccrualDays
      ,[nSuperID] = @nSuperID
      ,[dtModifiedDate] = @dtModifiedDate
 WHERE [nUserID] = @nUserID AND [sAccrualType] = @sAccrualType AND [dBalanceStartDate] = @dBalanceStartDate
 
 set @Ret = @@ROWCOUNT
 if @Ret= 0
	BEGIN
	INSERT INTO [dbo].[tUserCompensationComputedBalances]
           ([nUserID]
           ,[sAccrualType]
           ,[dblAccruedHours]
           ,[dBalanceStartDate]
           ,[dblAccrualDailyHours]
           ,[sAccrualDays]
           ,[nSuperID]
           ,[dtModifiedDate])
     VALUES
	 (
		   @nUserID 
           ,@sAccrualType 
           ,@dblAccruedHours 
           ,@dBalanceStartDate 
           ,@dblAccrualDailyHours 
           ,@sAccrualDays 
           ,@nSuperID  
           ,@dtModifiedDate 
		   )
	set @Ret = @@ROWCOUNT
	END
return @ret
END

GO
