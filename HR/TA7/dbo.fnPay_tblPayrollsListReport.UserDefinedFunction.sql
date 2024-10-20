USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollsListReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 05/15/2019
-- Description:	Quarterly Report for SUTA Taxes
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollsListReport]
(
	@PAYROLLCOMPANY nvarchar(50),
	@STARTDATE datetime,
	@ENDDATE datetime
)
RETURNS @tblPayrollsByType TABLE 
(
	strCompanyName nvarchar(50), 
	strPayrollSchedule nvarchar(50), 
	nPayWeekNum int, 
	DTStartDate datetime, 
	DTEndDate datetime, 
	intPayWeekNumber int, 
	strBatchID nvarchar(50), 
	strBatchDescription nvarchar(50), 
	intBatchStatus int, 
	dtPayDate datetime, 
	intCreatedByID int, 
	strCreateByName nvarchar(50), 
	dtBatchCreated datetime, 
	strStatusDescription nvarchar(50), 
	intPayrollScheduleID int,
	strBatchTypeName nvarchar(50),
	 decNetPay decimal(18,5),
	 decCompensations decimal(18,5), 
	 decWithholdings decimal(18,5), 
	 decContributions decimal(18,5)
)
-- WITH ENCRYPTION
AS
BEGIN
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName,csp.strPayrollSchedule as strPayrollSchedule,csp.intpayweeknumber 
					,csp.DTStartDate as dtStartDatePeriod 
					,csp.DTEndDate as dtEndDatePeriod 
					,	0 as intPayWeekNumber, b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, b.strBatchTypeName, 
						[dbo].[fnPay_BatchTotalNetPay](b.strBatchID) decNetPay,  
						[dbo].[fnPay_BatchTotalCompensations](b.strBatchID)  decCompensations, 
						[dbo].[fnPay_BatchTotalWithholdings](b.strBatchID) decWithholdings, 
						[dbo].[fnPay_BatchTotalContributions](b.strBatchID) decContributions

		FROM		--	dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
					dbo.[viewPay_CompanyPayrollScheduleProcessed] AS csp inner JOIN
                    viewPay_Batch b on b.strBatchID = csp.strBatchID
						where b.intBatchStatus = -1 and b.strCompanyName = @PAYROLLCOMPANY 
						and b.dtPayDate BETWEEN @STARTDATE AND @ENDDATE and b.intBatchType = 0
						order by csp.DTStartDate asc


		----Insert Additional Payrolls
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName, 'Additional' as strPayrollSchedule,csp.intpayweeknumber
						,isnull((select top(1) dtStartDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ), b.dtPayDate) as dtStartDatePeriod 
						,isnull((select top(1) dtEndDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ), b.dtPayDate) as dtEndDatePeriod 
						, 0 as intPayWeekNumber, b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, strBatchTypeName, 
						[dbo].[fnPay_BatchTotalNetPay](b.strBatchID) decNetPay,  
						[dbo].[fnPay_BatchTotalCompensations](b.strBatchID)  decCompensations, 
						[dbo].[fnPay_BatchTotalWithholdings](b.strBatchID) decWithholdings, 
						[dbo].[fnPay_BatchTotalContributions](b.strBatchID) decContributions

		FROM			dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
                        viewPay_Batch b on b.strBatchID = csp.strBatchID
						where intBatchStatus = -1 and b.strCompanyName = @PAYROLLCOMPANY and b.intBatchType <>0
						and b.dtPayDate BETWEEN @STARTDATE AND @ENDDATE
						order by b.dtPayDate asc

RETURN
END

GO
