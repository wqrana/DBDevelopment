USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserBatchSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Returnd the YearToDate Withholdings of an User
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblUserBatchSummary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblUserBatchSummary TABLE 
(
	intUserID  int,
	strUserName nvarchar(50),
	strItemsName nvarchar(50),
	decItemsAmount decimal(18,5),
	decItemsHours decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	--Return with order number in front for cross tabs
	insert into @tblUserBatchSummary
	SELECT ubc.intUserID , ubs.strUserName, IIF (uci.intReportOrder is null, '10', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubc.strCompensationName as strItemsName , decPay as decItemsAmount, decHours as decItemsHours 
	FROM [dbo].[tblUserBatchCompensations] ubc inner join viewPay_UserBatchStatus ubs on ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
	inner join [dbo].[tblCompanyCompensations] uci on ubc.strCompensationName = uci.strCompensationName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubc.strBatchID = @BATCHID  and ubc.boolDeleted = 0
	ORDER BY ubc.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubc.strCompensationName  ASC

	--Return with order number in front for cross tabs
	insert into @tblUserBatchSummary
	SELECT ubw.intUserID,ubs.strUserName, IIF (uci.intReportOrder is null, '20', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubw.strWithHoldingsName as strItemsName  , ubw.decWithholdingsAmount as decItemsAmount , 0 as decItemsHours 
	FROM [dbo].[tblUserBatchWithholdings] ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	left outer join [dbo].[tblCompanyWithholdings] uci on ubw.strWithHoldingsName = uci.strWithHoldingsName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubw.strBatchID = @BATCHID 
	ORDER BY ubw.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubw.strWithHoldingsName  ASC
	RETURN
END


GO
