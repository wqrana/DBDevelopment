USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spUpdsert_AccrualComputationLog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdsert_AccrualComputationLog]
       @ID as int,
       @strAccrualType  as nvarchar(50),
       @strAccrualTypeDesc as nvarchar(50), 
       @dtEffectiveMonth as datetime, 
       @dtPeriodStartDate as datetime, 
       @dtPeriodEndDate as datetime, 
       @intUserID as int, 
       @strUserName as nvarchar(50), 
       @dblHoursWorked as float, 
       @dblPreviousAccrualHours as float, 
       @dblCurrentAccrualHours as float, 
       @dblAccruedHours as float, 
       @intAdminID as int, 
       @strAdminName as nvarchar(50), 
       @dblEffectivePayRate as float, 
       @dtAccrualsComputeDate as datetime, 
       @intAccrualLogMode as int
AS
BEGIN
update tAccrualsComputationLog set 
       ID=    @ID ,
       strAccrualType  = @strAccrualType ,
       strAccrualTypeDesc = @strAccrualTypeDesc , 
       dtEffectiveMonth = @dtEffectiveMonth , 
       dtPeriodStartDate = @dtPeriodStartDate , 
       dtPeriodEndDate = @dtPeriodEndDate , 
       intUserID = @intUserID , 
       strUserName = @strUserName , 
       dblHoursWorked = @dblHoursWorked , 
       dblPreviousAccrualHours = @dblPreviousAccrualHours , 
       dblCurrentAccrualHours = @dblCurrentAccrualHours , 
       dblAccruedHours = @dblAccruedHours , 
       intAdminID = @intAdminID , 
       strAdminName = @strAdminName , 
       dblEffectivePayRate = @dblEffectivePayRate , 
       dtAccrualsComputeDate = @dtAccrualsComputeDate , 
       intAccrualLogMode = @intAccrualLogMode 
       where 
       strAccrualType  = @strAccrualType and
       dtEffectiveMonth = @dtEffectiveMonth and
       intUserID = @intUserID and 
       intAccrualLogMode = @intAccrualLogMode

if @@ROWCOUNT = 0
BEGIN

insert into tAccrualsComputationLog (
       ID,
       strAccrualType  ,
       strAccrualTypeDesc , 
       dtEffectiveMonth , 
       dtPeriodStartDate , 
       dtPeriodEndDate , 
       intUserID , 
       strUserName , 
       dblHoursWorked , 
       dblPreviousAccrualHours , 
       dblCurrentAccrualHours , 
       dblAccruedHours , 
       intAdminID , 
       strAdminName , 
       dblEffectivePayRate , 
       dtAccrualsComputeDate , 
       intAccrualLogMode 
       )
VALUES
       (
       @ID ,
       @strAccrualType ,
       @strAccrualTypeDesc , 
       @dtEffectiveMonth , 
       @dtPeriodStartDate , 
       @dtPeriodEndDate , 
       @intUserID , 
       @strUserName , 
       @dblHoursWorked , 
       @dblPreviousAccrualHours , 
       @dblCurrentAccrualHours , 
       @dblAccruedHours , 
       @intAdminID , 
       @strAdminName , 
       @dblEffectivePayRate , 
       @dtAccrualsComputeDate , 
       @intAccrualLogMode 
       )
END

END
GO
