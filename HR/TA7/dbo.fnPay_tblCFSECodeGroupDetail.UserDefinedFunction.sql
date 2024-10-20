USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCFSECodeGroupDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/24/2019
-- Description:	Data for CFSE Tax Quarter Reports.  Shows the detail based on grouping selection 
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCFSECodeGroupDetail]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date,
	@intGrouping as int
)
RETURNS 
@tblCFSEGroupingReport TABLE 
(
	strCompanyName	nvarchar(50),
	dtStartDate		date,
	dtEndDate		date,
	strGrouping		nvarchar(50),
	intUserCovered int,
	strCFSECode		nvarchar(50),
	decCFSETaxPercent decimal(18,5),
	decCFSEWages	decimal(18,5),
	decCFSETaxOwed		decimal(18,5),
	decCFSETaxContributed		decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
declare @intUserCovered int
----------------------------------
DECLARE	 @strCFSEWithholdings as nvarchar(50)
SET @strCFSEWithholdings = 'CFSE'
IF not exists(select strWithHoldingsName from tblWithholdingsItems where strWithHoldingsName = @strCFSEWithholdings)
BEGIN
	set @strCFSEWithholdings = 'WORKERS COMP'
END
----------------------------------


----------------------------------
-- COMPUTOS CFSE Group INCOME TAX
----------------------------------

--- TIMEAIDE CONTRIBUTION 
--By Company
IF @intGrouping = 0
BEGIN
	INSERT INTO @tblCFSEGroupingReport
	select  (ubs.strCompanyName) PayrollCompany,@STARTDATE,@ENDDATE,
	 ''  'None', count(distinct ubs.intuserid),  	 isnull(uwi.strClassIdentifier,''),	 uwi.decCompanyPercent CFSEPercent,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid)) Salary  ,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid)) * uwi.decCompanyPercent/100 CFSETax,
	-sum([dbo].[fnPay_BatchCompanyWithholdingNameAmount](ubs.strbatchid,ubs.intuserid,@strCFSEWithholdings )) CFSEContributed
	From viewPay_UserBatchStatus ubs 
		left outer join tblUserWithholdingsItems uwi ON ubs.intUserID = uwi.intUserID and uwi.strWithHoldingsName = @strCFSEWithholdings 
	where ubs.strCompanyName = @PayrollCompany and ubs.dtPayDate between @StartDate and @EndDate and ubs.decBatchUserCompensations <> 0
	GROUP BY ubs.strCompanyName,uwi.strClassIdentifier, uwi.decCompanyPercent 
END

IF @intGrouping = 1
BEGIN
--By department
	INSERT INTO @tblCFSEGroupingReport
	select  (ubs.strCompanyName) PayrollCompany,@STARTDATE,@ENDDATE,
	ubs.strDepartment 'Dept', count(distinct ubs.intuserid),isnull(uwi.strClassIdentifier,''), uwi.decCompanyPercent CFSEPercent,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid))  Salary  ,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid)) * uwi.decCompanyPercent/100 CFSETax,
	-sum([dbo].[fnPay_BatchCompanyWithholdingNameAmount](ubs.strbatchid,ubs.intuserid,@strCFSEWithholdings )) CFSEContributed 
	From viewPay_UserBatchStatus ubs 
		left outer join tblUserWithholdingsItems uwi ON ubs.intUserID = uwi.intUserID and uwi.strWithHoldingsName = @strCFSEWithholdings 
		where ubs.strCompanyName = @PayrollCompany and ubs.dtPayDate between @StartDate and @EndDate 
	
	GROUP BY ubs.strCompanyName,ubs.strDepartment, uwi.strClassIdentifier, uwi.decCompanyPercent 
END 

IF @intGrouping = 2
BEGIN
--By Sub-Department
	INSERT INTO @tblCFSEGroupingReport
	select  (ubs.strCompanyName) PayrollCompany,@STARTDATE,@ENDDATE,
	ubs.strSubdepartment 'SubDept', count(distinct ubs.intuserid),isnull(uwi.strClassIdentifier,''), uwi.decCompanyPercent CFSEPercent,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid))  Salary  ,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid)) * uwi.decCompanyPercent/100 CFSETax,
	-sum([dbo].[fnPay_BatchCompanyWithholdingNameAmount](ubs.strbatchid,ubs.intuserid,@strCFSEWithholdings )) CFSEContributed 
	From viewPay_UserBatchStatus ubs 
	left outer join tblUserWithholdingsItems uwi ON ubs.intUserID = uwi.intUserID and uwi.strWithHoldingsName = @strCFSEWithholdings 
	where ubs.strCompanyName = @PayrollCompany and ubs.dtPayDate between @StartDate and @EndDate 
	GROUP BY ubs.strCompanyName,ubs.strSubdepartment, uwi.strClassIdentifier, uwi.decCompanyPercent 
END

--By Position
IF @intGrouping = 3
BEGIN
	INSERT INTO @tblCFSEGroupingReport
	select  (ubs.strCompanyName) PayrollCompany,@STARTDATE,@ENDDATE,
	p.strPositionName 'Position', count(distinct ubs.intuserid),isnull(uwi.strClassIdentifier,''), uwi.decCompanyPercent CFSEPercent,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid))  Salary  ,
	sum([dbo].[fnPay_BatchTaxablePay](ubs.strbatchid, ubs.intuserid)) * uwi.decCompanyPercent/100 CFSETax,
	-sum([dbo].[fnPay_BatchCompanyWithholdingNameAmount](ubs.strbatchid,ubs.intuserid,@strCFSEWithholdings )) CFSEContributed 
	From viewPay_UserBatchStatus ubs inner join tuser u on ubs.intUserID = u.id
	left outer join tblPosition p on u.intPositionID = p.intPositionID
	left outer join tblUserWithholdingsItems uwi ON ubs.intUserID = uwi.intUserID and uwi.strWithHoldingsName = @strCFSEWithholdings 
	where ubs.strCompanyName = @PayrollCompany and ubs.dtPayDate between @StartDate and @EndDate 
	GROUP BY ubs.strCompanyName,p.strPositionName, uwi.strClassIdentifier, uwi.decCompanyPercent 
END
RETURN
END

GO
