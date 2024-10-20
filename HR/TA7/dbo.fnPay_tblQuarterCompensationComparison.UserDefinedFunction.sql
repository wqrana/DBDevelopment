USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblQuarterCompensationComparison]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblQuarterCompensationComparison]
(
	@PayrollCompany nvarchar(50),
	@PrimaryQuarterDate date,
	@SecondaryQuarterDate date
)
RETURNS @tblCompensationQuarterComparison TABLE 
(
	strCompanyName nvarchar(50),  
	strCompensationName nvarchar(50), 
	intReportOrder int,
	strPrimaryDepartment nvarchar(50), 
	strPrimaryQuarterDescription nvarchar(50), 
	decPrimaryHours decimal(18,5),
	decPrimaryPay decimal(18,5),
	intPrimaryEmployeeCount int, 
	strSecondaryDepartment nvarchar(50), 
	strSecondaryQuarterDescription nvarchar(50), 
	decSecondaryHours decimal(18,5),
	decSecondaryPay decimal(18,5),
	intSecondaryEmployeeCount int,
	strPrimarySubDepartment nvarchar(50) 
)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @FIRSTQ varchar(10)
	DECLARE @FIRSTSTART date
	DECLARE @FIRSTEND date
	SELECT @FIRSTQ ='Q' + convert(varchar(1), ((MONTH(@PrimaryQuarterDate)-1) / 3) + 1) + convert(varchar(4),YEAR(@PrimaryQuarterDate))  ,  @FIRSTSTART =  DATEADD(qq, DATEDIFF(qq, 0, @PrimaryQuarterDate), 0) , @FIRSTEND = DATEADD (s, -1, DATEADD(qq, DATEDIFF(qq, 0, @PrimaryQuarterDate) +1, 0))

	DECLARE @SECONDQ varchar(10)
	DECLARE @SECONDSTART date
	DECLARE @SECONDEND date
	SELECT @SECONDQ ='Q' + convert(varchar(1), ((MONTH(@SecondaryQuarterDate)-1) / 3) + 1) + convert(varchar(4),YEAR(@SecondaryQuarterDate))  ,@SECONDSTART =  DATEADD(qq, DATEDIFF(qq, 0, @SecondaryQuarterDate), 0) , @SECONDEND = DATEADD (s, -1, DATEADD(qq, DATEDIFF(qq, 0, @SecondaryQuarterDate) +1, 0))

insert into @tblCompensationQuarterComparison
	SELECT cc.strCompanyName,
	cc.strCompensationName,
	cc.intReportOrder,
	strDepartmentName strPrimaryDepartment
	,@FIRSTQ strPrimaryQuarterDescription
	,isnull((select sum (decHours) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @FIRSTSTART AND @FIRSTEND),0) as decPrimaryHours
	,isnull((select sum (decPay) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @FIRSTSTART AND @FIRSTEND),0) as decPrimaryPay
	,isnull((select count (distinct intUserID) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @FIRSTSTART AND @FIRSTEND  ),0) as intPrimaryEmployeeCount

	,strDepartmentName strSecondaryDepartment
	,@SECONDQ strSecondaryQuarterDescription
	,isnull((select sum (decHours) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @SECONDSTART AND @SECONDEND),0) as decSecondaryHours
	,isnull((select sum (decPay) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @SECONDSTART AND @SECONDEND),0) as decSecondaryPay
	,isnull((select count (distinct intUserID) from viewPay_UserBatchCompensations where strCompanyName = cc.strCompanyName and intDepartmentID = d.intDepartmentID and intSubdepartmentID = sd.intSubdepartmentID AND strCompensationName = cc.strCompensationName AND dtPayDate BETWEEN @SECONDSTART AND @SECONDEND),0) as intSecondaryEmployeeCount
	,sd.strSubdepartmentName strPrimarySubDepartment

	from tblCompanyCompensations cc inner join 
	(select @PayrollCompany as strCompanyName, intDepartmentID, strDepartmentName FROM [dbo].[fnPay_tblPayrollCompanyDepartments] (@payrollcompany)) D ON cc.strCompanyName = D.strCompanyName
	inner join 
	(select @PayrollCompany as strCompanyName, intSubdepartmentID, strSubdepartmentName FROM [dbo].[fnPay_tblPayrollCompanySubdepartments] (@payrollcompany)) SD ON cc.strCompanyName = D.strCompanyName
	ORDER BY cc.strCompanyName, strDepartmentName, strSubdepartmentName


	RETURN
END

GO
