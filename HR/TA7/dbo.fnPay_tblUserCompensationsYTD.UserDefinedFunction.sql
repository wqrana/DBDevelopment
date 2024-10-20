USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserCompensationsYTD]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-08-24
-- Description:		Gets the viewPay_UserBAtchCompensations with the YTD
-- 7/6/2023:		Modified to show rates separately and only show total in minimun rate entry
-- =============================================


CREATE FUNCTION [dbo].[fnPay_tblUserCompensationsYTD]
(
	@BATCHID as nvarchar(50)
)
RETURNS @tblUserCompensationsYTD TABLE 
(
strBatchID  nvarchar(50), 
intUserID  int, 
strCompensationName  nvarchar(50), 
decHours  decimal(18,5), 
decPay  decimal(18,5), 
strGLAccount  nvarchar(50),
decPayYTD  decimal(18,5),
intReportOrder int,
decPayRate  decimal(18,5)
)
-- WITH ENCRYPTION
AS
BEGIN
	
	--Use the Batch End Date to know YTD
	--Shows different pay rates in separate lines.
	INSERT INTO @tblUserCompensationsYTD
	SELECT @BATCHID as strBatchID, ub.intUserID, cc.strCompensationName, iif(sum(ubc.decHours) IS NULL,0,sum(ubc.decHours)) as decHours
	, iif(sum(ubc.decPay) IS NULL, 0,sum(ubc.decPay))  as decPay, '' as strGLAccount, 
	IIF(isnull(ubc.decPayRate,0) = isnull((select max(decPayRate) from viewPay_UserBatchCompensations ubc2  where ubc2.strCompensationName = cc.strCompensationName and ubc2.intUserID = ub.intUserID and ubc2.strBatchID = ub.strBatchId ),0)
	,	[dbo].[fnPay_YearToDateUserBatchcompensations](ub.intUserID,cc.strCompensationName,ub.dtPayDate,ub.strCompanyName),0) as decPayYTD  
	, cc.intReportOrder
	,isnull(ubc.decPayRate,0) ubcRate

	FROM 
	 tblCompanyCompensations cc  
	 inner join viewPay_UserBatchStatus ub on cc.strCompanyName = ub.strCompanyName
	left outer join 
	viewPay_UserBatchCompensations ubc  on cc.strCompensationName = ubc.strCompensationName and ubc.intUserID = ub.intUserID and ubc.strBatchID = ub.strBatchId
	WHERE 
	ub.strBatchID = @BATCHID 
	GROUP BY ub.strBatchID,ub.strCompanyName, ub.intUserID,ub.dtPayDate, cc.strCompensationName,decPayRate,cc.intReportOrder
	RETURN
END

GO
