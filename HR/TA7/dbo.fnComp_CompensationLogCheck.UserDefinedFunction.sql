USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_CompensationLogCheck]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/7/2022
-- Description:	Compensation V2: Checks that the accrual log matches the daily balances.
-- =============================================
CREATE FUNCTION [dbo].[fnComp_CompensationLogCheck]
(	
	@UserID int
)
RETURNS @fnPay_CompensationLogCheck TABLE 
(
	-- Add the column definitions for the TABLE variable here
	UserID int
)
AS
BEGIN
	--	-- Add the SELECT statement with parameter references here
	-------Accumulations
	--INSERT @fnPay_CompensationLogCheck
	--select top(10) intUserID Userid
	--from tAccrualsComputationLog  acl 
	--where 
	--cast(dblCurrentAccrualHours as decimal(18,3)) <> cast (dbo.fnComp_StartOfDayBalance(intUserID,strAccrualType,dtEffectiveMonth) as decimal(18,3))
	--and dtEffectiveMonth between DATEADD(M,-2,dtEffectiveMonth) AND  DATEADD(M,3,dtEffectiveMonth) 
	--and intAccrualLogMode = 1
	--and intUserID in (select id from tuser where nStatus = 1 and (intUserID = @UserID OR @UserID = 0))
	--and strAccrualType <> 'NO'
	--order by acl.dtEffectiveMonth desc

	------Transactions
	--INSERT @fnPay_CompensationLogCheck
	--select top(10) intUserID Userid
	--from tAccrualsComputationLog  acl 
	--where 
	--cast(dblCurrentAccrualHours as decimal(18,3)) <> cast (dbo.fnComp_EndOfDayBalance(intUserID,strAccrualType,dtEffectiveMonth) as decimal(18,3))
	--and dtEffectiveMonth between DATEADD(M,-2,dtEffectiveMonth) AND  DATEADD(M,3,dtEffectiveMonth) 
	--and intAccrualLogMode = 2
	--and intUserID in (select id from tuser where nStatus = 1 and (intUserID = @UserID OR @UserID = 0))
	--and strAccrualType <> 'NO'
	--order by acl.dtEffectiveMonth desc
	
	RETURN
END
GO
