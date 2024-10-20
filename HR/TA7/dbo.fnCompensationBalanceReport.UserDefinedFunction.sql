USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationBalanceReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCompensationBalanceReport] 
(      
@UserID as int,
@AccrualType as nvarchar(50),
@StartDate as datetime,
@EndDate as datetime
)
RETURNS TABLE 
AS
RETURN 
(
select id as 'User ID', name as 'User Name', @AccrualType as 'Accrual Type', @StartDate as 'Start Date', @EndDate as 'End Date', 
[dbo].[fnCompensationStartOfDayBalance](   @StartDate  ,id  ,@AccrualType) as 'Start Balance', 
  [dbo].[fnCompensationAccruedHours] (@StartDate, @EndDate,@UserID,@AccrualType) as 'Accrued Hours',
[dbo].[fnCompensationUsedHours] (@StartDate, @EndDate,@UserID,@AccrualType) as 'Used Hours',
[dbo].[fnCompensationStartOfDayBalance](   @EndDate  ,id  ,@AccrualType) as 'End Balance', 
  [dbo].[fnCompensationRate] (@UserID,@AccrualType) as 'Compensation Rate' ,
  [dbo].[fnCompensationStartOfDayBalance](   @EndDate  ,id  ,@AccrualType) *  [dbo].[fnCompensationRate] (@UserID,@AccrualType)  as 'Money Balance'
from tuser
where (id=@UserID or @UserID = 0)
)
GO
