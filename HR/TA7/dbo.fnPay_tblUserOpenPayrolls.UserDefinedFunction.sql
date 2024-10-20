USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserOpenPayrolls]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Fopr cross tab reports, Batch Company totals
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblUserOpenPayrolls]
(	
	-- Add the parameters for the function here
	@USERID  int,
	@STARTDATE as datetime,
	@ENDDATE as datetime
)
RETURNS 
@tblOpenPayrolls TABLE 
(
	intUserID  int,
	intPayWeekNum int
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @tblOpenPayrolls
	select intUserID, intPayWeekNum from tReportWeek rw inner join tblUserBatch ub on rw.e_id = ub.intUserID  and rw.nPayWeekNum = ub.intPayWeekNum
	where rw.DTStartDate <= @ENDDATE and rw.DTEndDate >= @STARTDATE and rw.e_id = @USERID
	and ub.intUserBatchStatus >=0
	RETURN
END
GO
