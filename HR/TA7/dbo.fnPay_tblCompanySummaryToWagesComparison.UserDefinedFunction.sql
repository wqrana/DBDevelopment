USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanySummaryToWagesComparison]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/9/2023
-- Description:	Taxes Comparison Report
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCompanySummaryToWagesComparison]
(	
	@PAYROLLCOMPANY nvarchar(50)
	,@STARTDATE date 
	,@ENDDATE date 
)
RETURNS TABLE 
AS
RETURN 
(
SELECT Summary.strCompanyName CompanyName, strPayItem, decPaySummary, decPayYTDSummary, decContributionSummary, decContributionYTDSummary , Wages.strCompensationName, Wages.decPay, Summary.intReportOrder
FROM 
	(SELECT b.strCompanyName, strPayItem, sum(decPay) decPaySummary, max(decPayYTD) decPayYTDSummary, sum(decContribution) decContributionSummary, max(decContributionYTD) decContributionYTDSummary , max(intReportOrder) intReportOrder
	FROM tblBatch b 
	cross apply
	[dbo].[fnPay_tblBatchPayRegisterCompanySummary] (strBatchID) 
	where b.dtPayDate between @STARTDATE and @ENDDATE AND (b.strCompanyName = @PAYROLLCOMPANY OR @PAYROLLCOMPANY is null)
	group by b.strCompanyName, strPayItem) Summary

full JOIN 

(	SELECT ubc.strCompanyName, ubc.strCompensationName, sum(decPay) decPay 
	FROM [viewPay_UserBatchCompensations] ubc inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName  
	WHERE dtPayDate between @STARTDATE and @ENDDATE AND (strCompanyName = @PAYROLLCOMPANY OR @PAYROLLCOMPANY is null)
	and intCompensationType = 1 group by ubc.strCompanyName, ubc.strCompensationName
) Wages
ON Summary.strPayItem = Wages.strCompensationName and Summary.strCompanyName = wages.strCompanyName
--WHERE Summary.decPay <> Wages.decPay
)
GO
