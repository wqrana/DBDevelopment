USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCFSEReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/06/2019
-- Description:	For CFSE Report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCFSEReport]
(
	 @strPayrollCompany as nvarchar(50),
	 @strStartYear as varchar(4),
	 @strCFSEWithholdings as varchar(50)
)
RETURNS @tblCFSEReport TABLE 
(
	strPayrollCompany nvarchar(50), 
	strClassIdentifier nvarchar(50), 
	decQuarterPayAmount  decimal(18,2),
	strQuarter  nvarchar(50),
	decCFSEPercent  decimal(18,2),
	decCFSEAmount  decimal(18,2)
)
-- WITH ENCRYPTION
AS
BEGIN
	IF NOT EXISTS (SELECT 1 from tblWithholdingsItems where strWithHoldingsName = @strCFSEWithholdings)
		SET @strCFSEWithholdings = 'WORKERS COMP'

DECLARE @strEndYear as varchar(4)

DECLARE @intTimeAideCompensations as integer
DECLARE @intInitialBalance as integer

-- Include Payrolls created in TimeAide
SET @intTimeAideCompensations = 1
-- Include Initial Balance payrolls
SET @intInitialBalance = 1

SET @strStartYear = cast( cast(@strStartYear as int) - 1 as varchar(4))
-- Calculates End year based on @strStartYear
SET @strEndYear = convert(varchar(4),convert(int,@strstartyear) + 1)

-- Calculates the 
DECLARE @intTimeAideCompensationsStatusID as integer
IF @intTimeAideCompensations = 1 
	SET @intTimeAideCompensationsStatusID = -1
ELSE
	SET @intTimeAideCompensationsStatusID = -10
	
DECLARE @intInitialBalanceStatusID as integer
IF @intInitialBalance = 1 
	SET @intInitialBalanceStatusID = 4
ELSE
	SET @intInitialBalanceStatusID = -10


-- Returns any compensation between 7/1/2017 and 6/30/2018 without CFSE CLass code
--SELECT vPUBC.*, tUWI.strClassIdentifier
--FROM viewPay_UserBatchCompensations as vPUBC
--	LEFT OUTER JOIN tblUserWithholdingsItems as tUWI ON tUWI.intUserID = vPUBC.intUserID AND tUWI.strContributionsName = @strCFSEWithholdings
--	LEFT OUTER JOIN tblUserCompensationItems AS tUCI ON tUCI.intUserID = vPUBC.intUserID AND tUCI.strCompensationName = vPUBC.strCompensationName
--	LEFT OUTER JOIN tblBatch AS tB ON tB.strBatchID = vPUBC.strBatchID 
--WHERE vPUBC.dtPayDate between '7/1/' + @strStartYear and '6/30/' + @strEndYear
--	AND vPUBC.strCompanyName = @strCompany
--	AND tUCI.intCompensationType = 1
--	AND ISNULL(tUWI.strClassIdentifier,'') = ''
--	AND tB.intBatchStatus in (@intTimeAideCompensationsStatusID, @intInitialBalanceStatusID)



-- Total earnings grouped by CFSE Class between 7/1/2017 and 9/30/2017
INSERT INTO @tblCFSEReport
SELECT	@strPayrollCompany as strCompanyname, 
		tuwi.strClassIdentifier,
		SUM(vpubc.decPay) as dblAmount,
		@strStartYear  +' 3rd QTR ' as strQuarter,
		isnull(tuwi.decCompanyPercent ,0) decCFSEPercent,
		 (SUM(vpubc.decPay) * isnull(tuwi.decCompanyPercent ,0) / 100) decCFSEAmount
		
FROM viewPay_UserBatchCompensations as vPUBC
	LEFT OUTER JOIN tblUserWithholdingsItems as tUWI ON tUWI.intUserID = vPUBC.intUserID AND tUWI.strContributionsName = @strCFSEWithholdings
	LEFT OUTER JOIN tblUserCompensationItems AS tUCI ON tUCI.intUserID = vPUBC.intUserID AND tUCI.strCompensationName = vPUBC.strCompensationName
	LEFT OUTER JOIN tblBatch AS tB ON tB.strBatchID = vPUBC.strBatchID 
WHERE vPUBC.dtPayDate between '7/1/' + @strStartYear and '9/30/' + @strStartYear
	AND vPUBC.strCompanyName = @strPayrollCompany
	AND tUCI.intCompensationType = 1
	AND tB.intBatchStatus in (@intTimeAideCompensationsStatusID, @intInitialBalanceStatusID)
group by strClassIdentifier, tuwi.decCompanyPercent

UNION

-- Total earnings grouped by CFSE Class between 10/1/2017 and 12/31/2017
	SELECT	@strPayrollCompany as strCompanyname, 
		tuwi.strClassIdentifier,
		SUM(vpubc.decPay) as dblAmount,
		@strStartYear  + ' 4th QTR '  as strQuarter,
		isnull(tuwi.decCompanyPercent ,0) decCFSEPercent,
		 (SUM(vpubc.decPay) * isnull(tuwi.decCompanyPercent ,0) / 100) decCFSEAmount

		
FROM viewPay_UserBatchCompensations as vPUBC
	LEFT OUTER JOIN tblUserWithholdingsItems as tUWI ON tUWI.intUserID = vPUBC.intUserID AND tuwi.strContributionsName = @strCFSEWithholdings
	LEFT OUTER JOIN tblUserCompensationItems AS tUCI ON tUCI.intUserID = vPUBC.intUserID AND tUCI.strCompensationName = vPUBC.strCompensationName
	LEFT OUTER JOIN tblBatch AS tB ON tB.strBatchID = vPUBC.strBatchID 
WHERE vPUBC.dtPayDate between '10/1/' + @strStartYear and '12/31/' + @strStartYear
	AND vPUBC.strCompanyName = @strPayrollCompany
	AND tUCI.intCompensationType = 1
	AND tB.intBatchStatus in (@intTimeAideCompensationsStatusID, @intInitialBalanceStatusID)
group by strClassIdentifier, tuwi.decCompanyPercent
union
-- Total earnings grouped by CFSE Class between 1/1/2018 and 3/31/2018
SELECT	@strPayrollCompany as strCompanyname,
		tuwi.strClassIdentifier,
		SUM(vpubc.decPay) as dblAmount,
		@strEndYear  + ' 1st QTR '  as strQuarter,
		isnull(tuwi.decCompanyPercent ,0) decCFSEPercent,
		 (SUM(vpubc.decPay) * isnull(tuwi.decCompanyPercent ,0) / 100) decCFSEAmount

		
FROM viewPay_UserBatchCompensations as vPUBC
	LEFT OUTER JOIN tblUserWithholdingsItems as tUWI ON tUWI.intUserID = vPUBC.intUserID AND tuwi.strContributionsName = @strCFSEWithholdings
	LEFT OUTER JOIN tblUserCompensationItems AS tUCI ON tUCI.intUserID = vPUBC.intUserID AND tUCI.strCompensationName = vPUBC.strCompensationName
	LEFT OUTER JOIN tblBatch AS tB ON tB.strBatchID = vPUBC.strBatchID 
WHERE vPUBC.dtPayDate between '1/1/' + @strEndYear and '3/31/' + @strEndYear
	AND vPUBC.strCompanyName = @strPayrollCompany
	AND tUCI.intCompensationType = 1
	AND tB.intBatchStatus in (@intTimeAideCompensationsStatusID, @intInitialBalanceStatusID)
group by strClassIdentifier, tuwi.decCompanyPercent
union
-- Total earnings grouped by CFSE Class between 4/1/2018 and 6/30/2018
	SELECT 	@strPayrollCompany as strCompanyname,
		tuwi.strClassIdentifier,
		SUM(vpubc.decPay) as dblAmount,
		 @strEndYear  + ' 2nd QTR ' as strQuarter,
		isnull(tuwi.decCompanyPercent ,0) decCFSEPercent,
		 (SUM(vpubc.decPay) * isnull(tuwi.decCompanyPercent ,0) / 100) decCFSEAmount

FROM viewPay_UserBatchCompensations as vPUBC
	LEFT OUTER JOIN tblUserWithholdingsItems as tUWI ON tUWI.intUserID = vPUBC.intUserID AND tuwi.strContributionsName = @strCFSEWithholdings
	LEFT OUTER JOIN tblUserCompensationItems AS tUCI ON tUCI.intUserID = vPUBC.intUserID AND tUCI.strCompensationName = vPUBC.strCompensationName
	LEFT OUTER JOIN tblBatch AS tB ON tB.strBatchID = vPUBC.strBatchID 
WHERE vPUBC.dtPayDate between '4/1/' + @strEndYear and '6/30/' + @strEndYear
	AND vPUBC.strCompanyName = @strPayrollCompany
	AND tUCI.intCompensationType = 1
	AND tB.intBatchStatus in (@intTimeAideCompensationsStatusID, @intInitialBalanceStatusID)
group by strClassIdentifier, tuwi.decCompanyPercent

RETURN
END
GO
