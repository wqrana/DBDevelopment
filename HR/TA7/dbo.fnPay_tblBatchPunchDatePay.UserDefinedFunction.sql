USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPunchDatePay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblBatchPunchDatePay]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
	)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here

select ubt.strBatchID, e_id intUserID, e_name strUserName, pdt.DtPunchDate, sPunchSummary,sHoursSummary,ubt.strTransactionType, ubt.decHours,ubt.decPayRate, ubt.decMoneyValue
,ubs.dtPayDate, ubs.strBatchDescription, ubs.intPayWeekNum
from tblPunchDate pdt inner join tblUserBatchTransactions ubt on pdt.e_id =ubt.intUserID and pdt.DtPunchDate = ubt.dtPunchDate
inner join viewPay_UserBatchStatus ubs on ubt.strBatchID = ubs.strBatchID and ubt.intUserID = ubs.intUserID
where decMoneyValue>0 and ubt.strBatchID = @batchid
)

GO
