USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sprocUpserttUserCompensationAccruals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sprocUpserttUserCompensationAccruals]
(
           @sAccrualType as  nvarchar(50)
           ,@sAccrualTypeDesc as  nvarchar(50)
           ,@dEffectiveDate as date
           ,@dPeriodStartDate as date
           ,@dPeriodEndDate as  date
           ,@nUserID as  int
           ,@sUserName as  nvarchar(50)
           ,@dblPeriodHours as  decimal(18,5)
           ,@dblAccruedHours as decimal(18,5)
           ,@intAdminID as int
           ,@strAdminName as nvarchar(50)
           ,@dblEffectivePayRate as nchar(10)
           ,@dtAccrualsComputeDate as date
           ,@nAccrualLogMode as int
)
AS
BEGIN 
	DECLARE @Ret as int
	IF NOT EXISTS(SELECT * from tUserCompensationBalances where nUserID= @nUserID and sAccrualType =@sAccrualType and dBalanceStartDate = @dEffectiveDate)
	BEGIN
		UPDATE [dbo].[tUserCompensationAccruals]
	   SET [sAccrualType] = @sAccrualType
		  ,[sAccrualTypeDesc] = @sAccrualTypeDesc
		  ,[dEffectiveDate] = @dEffectiveDate
		  ,[dPeriodStartDate] = @dPeriodStartDate
		  ,[dPeriodEndDate] = @dPeriodEndDate
		  ,[nUserID] = @nUserID
		  ,[sUserName] = @sUserName
		  ,[dblPeriodHours] = @dblPeriodHours
		  ,[dblAccruedHours] = @dblAccruedHours
		  ,[intAdminID] = @intAdminID
		  ,[strAdminName] = @strAdminName
		  ,[dblEffectivePayRate] = @dblEffectivePayRate
		  ,[dtAccrualsComputeDate] = @dtAccrualsComputeDate
		  ,[nAccrualLogMode] = @nAccrualLogMode
		 WHERE [sAccrualType] = @sAccrualType AND [nUserID] = @nUserID AND [dEffectiveDate] = @dEffectiveDate
		
		set @Ret = @@ROWCOUNT
		if @Ret= 0

		BEGIN
			INSERT INTO [dbo].[tUserCompensationAccruals]
			   ([sAccrualType]
			   ,[sAccrualTypeDesc]
			   ,[dEffectiveDate]
			   ,[dPeriodStartDate]
			   ,[dPeriodEndDate]
			   ,[nUserID]
			   ,[sUserName]
			   ,[dblPeriodHours]
			   ,[dblAccruedHours]
			   ,[intAdminID]
			   ,[strAdminName]
			   ,[dblEffectivePayRate]
			   ,[dtAccrualsComputeDate]
			   ,[nAccrualLogMode])
		 VALUES
			   (@sAccrualType
			   ,@sAccrualTypeDesc
			   ,@dEffectiveDate
			   ,@dPeriodStartDate
			   ,@dPeriodEndDate
			   ,@nUserID
			   ,@sUserName
			   ,@dblPeriodHours
			   ,@dblAccruedHours
			   ,@intAdminID
			   ,@strAdminName
			   ,@dblEffectivePayRate
			   ,@dtAccrualsComputeDate
			   ,@nAccrualLogMode)
		
		set @Ret = @@ROWCOUNT
		END
	END
	return @ret
	END

GO
