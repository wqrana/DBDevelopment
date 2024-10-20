USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_CheckPayrollRecompute]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 8/2/2019
-- Description:	Checks if there is a payroll that needs computing.
--				In case of PayCycle, it checks for diferences in punchdates
--				To determine if a PayCheck recompute is needed.
-- =============================================
CREATE FUNCTION [dbo].[fnPay_CheckPayrollRecompute]
(
	@UserID int,
	@Payweeknum int
)
RETURNS bit 
-- WITH ENCRYPTION
AS
BEGIN

	DECLARE @PayCycle bit   = 0
	DECLARE @Recompute bit   = 0

	select   @PayCycle = count(*) from	tblPayCycleLog pcl inner join tblUserCompanyPayroll ucp on pcl.strPayrollCompany = ucp.strCompanyName 
	 where nPayWeekNum = @Payweeknum and ucp.intUserID = @UserID
	
	IF @PayCycle =1		--PayCycle applies.  Check for changes in the punchdates since unneceesary payroll recompute is a problem
		BEGIN
			--Check if there are any changes in the punchdates
			select @Recompute = count(*) from tpunchdate pdd inner join tblpunchdate pc on pdd.e_id = pc.e_id and pdd.DTPunchDate = pc.DtPunchDate
			where pdd.sHoursSummary <> pc.sHoursSummary
			and pc.e_id = @UserID and pc.intPayWeekNum = @Payweeknum
		END 
	ELSE --No Paycycle
		BEGIN
			select @Recompute = count(*) from tblUserBatch where intUserID = @UserID and intPayWeekNum = @Payweeknum and intUserBatchStatus >=0
		END

RETURN @Recompute
END

GO
