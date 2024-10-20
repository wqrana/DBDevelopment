USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnTA_tblPayCycleAdjust]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-08-24
-- Description:		Gets the Pay Cycle Adjust Transactions for a payweeknum
-- =============================================

CREATE FUNCTION [dbo].[fnTA_tblPayCycleAdjust]
(
	@PAYWEEKNUM as int,
	@PAYROLLSCHEDULEID as int
)
RETURNS @tblPayCycleAdjust TABLE 
(
intUserID  int, 
strUserName  nvarchar(50), 
strAdjustName  nvarchar(50), 
strOriginalTransName  nvarchar(50), 
decAdjustHours  decimal(18,5), 
decAdjustPay  decimal(18,5) ,
intWeekID bigint	
)
-- WITH ENCRYPTION
AS
BEGIN
	
	--Use the Batch End Date to know YTD
	INSERT INTO @tblPayCycleAdjust
	select pca.e_id, rw.e_name, strAdjustType, sType, dblHours, decAdjustAmount,(select top(1) nWeekID from tReportWeek where nPayWeekNum =  @PAYWEEKNUM and e_id = pca.e_id) as nWeekID
	from tblPayCycleAdjust  pca inner join tblReportWeek rw on pca.nWeekID = rw.nWeekID
	where pca.nPayWeekNum = @PAYWEEKNUM and rw.nPayRuleID IN 
	(select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID  where cpr.intPaymentSchedule = @PAYROLLSCHEDULEID) 
	RETURN
END

GO
