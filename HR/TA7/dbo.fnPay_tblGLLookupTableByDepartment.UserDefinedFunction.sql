USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblGLLookupTableByDepartment]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Department GL Lookup table report
-- 9/8/2017: Includes separate entries for GL Accounts
-- 3/26/2019: Includes Contribution Payable
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblGLLookupTableByDepartment]
(	
	-- Add the parameters for the function here
	@PayrollCompany nvarchar(50) 
	)
RETURNS 
@tblGLLookupTable TABLE 
(
	strCompanyName nvarchar(50), 
	strPositionName nvarchar(50),
	intAccountLookup int, 
	intPositionID int,
	strCompensationName nvarchar(50),
	strGLAccount nvarchar(50),
	strGLAccountType nvarchar(50)
) 
AS
BEGIN
	-- ALL COMPENSATIONS
	insert into @tblGLLookupTable
	SELECT        strCompanyName, '.ALL', 0, 0, 
                         strCompensationName, strGLAccount,'1 COMP EXPENSE' AS strGLAccountType
	FROM            tblCompanyCompensations 
	where intGLLookupField = 0 and strCompanyName = @PayrollCompany

	-- ALL WITHHOLDINGS
	insert into @tblGLLookupTable
	SELECT        cw.strCompanyName, '.ALL', 0, 0, 
                          cw.strWithHoldingsName, cw.strGLAccount,'2 WH EXPENSE' AS strGLAccountType
	FROM            tblCompanyWithholdings cw inner join tblWithholdingsItems wi ON cw.strWithHoldingsName = wi.strWithHoldingsName
	where intGLLookupField = 0 and strCompanyName = @PayrollCompany and wi.boolUserWithholding = 1

	-- ALL CONTRIBUTIONS
	insert into @tblGLLookupTable
	SELECT        cw.strCompanyName,'.ALL', 0, 0, 
                         cw.strWithHoldingsName, cw.strGLAccount_Contributions,'3 CC EXPENSE' AS strGLAccountType
	FROM            tblCompanyWithholdings cw inner join tblWithholdingsItems wi ON cw.strWithHoldingsName = wi.strWithHoldingsName
	where intGLLookupField = 0 and strCompanyName = @PayrollCompany and wi.boolCompanyContribution= 1
	
	-- ALL CONTRIBUTIONS
	insert into @tblGLLookupTable
	SELECT        cw.strCompanyName,'.ALL', 0, 0, 
                         cw.strWithHoldingsName, cw.strGLContributionPayable,'4 CC PAYBLE' AS strGLAccountType
	FROM            tblCompanyWithholdings cw inner join tblWithholdingsItems wi ON cw.strWithHoldingsName = wi.strWithHoldingsName
	where intGLLookupField = 0 and strCompanyName = @PayrollCompany and wi.boolCompanyContribution= 1

	-- User Compensations per GL Account Expense
	insert into @tblGLLookupTable
	SELECT        cal.strCompanyName, tDept.Name, cal.intAccountLookup, cal.intDepartmentID, 
                         lu.strCompensationName, lu.strGLAccount,'1 COMP EXPENSE' AS strGLAccountType
	FROM            dbo.tblCompanyGLAccountLookup cal INNER JOIN
                         dbo.tblCompanyGLLookupCompensation lu ON cal.intAccountLookup = lu.intAccountLookup INNER JOIN
                         dbo.tDept ON cal.intDepartmentID= dbo.tDept.ID
						 where cal.strCompanyName = @PayrollCompany

	-- User Withholdings per GL Account Expense
	insert into @tblGLLookupTable
	SELECT        cal.strCompanyName, tDept.Name, cal.intAccountLookup, cal.intDepartmentID, 
                         lu.strWithholdingsName, lu.strGLAccount,'2 WH EXPENSE' AS strGLAccountType
	FROM            dbo.tblCompanyGLAccountLookup cal INNER JOIN
                         dbo.tblCompanyGLLookupUserWithholdings lu ON cal.intAccountLookup = lu.intAccountLookup INNER JOIN
                         dbo.tDept ON cal.intDepartmentID= dbo.tDept.ID
						 where cal.strCompanyName = @PayrollCompany

	insert into @tblGLLookupTable
	SELECT        cal.strCompanyName, tDept.Name, cal.intAccountLookup, cal.intDepartmentID, 
                         lu.strWithholdingsName, lu.strGLAccount,'3 CC EXPENSE' AS strGLAccountType
	FROM            dbo.tblCompanyGLAccountLookup cal INNER JOIN
                         dbo.tblCompanyGLLookupCompanyWithholdings lu ON cal.intAccountLookup = lu.intAccountLookup INNER JOIN
                         dbo.tDept ON cal.intDepartmentID= dbo.tDept.ID
						 where cal.strCompanyName = @PayrollCompany

						 	insert into @tblGLLookupTable
	SELECT        cal.strCompanyName, tDept.Name, cal.intAccountLookup, cal.intDepartmentID, 
                         lu.strWithholdingsName, lu.strGLContributionPayable,'4 CC PAYBLE' AS strGLAccountType
	FROM            dbo.tblCompanyGLAccountLookup cal INNER JOIN
                         dbo.tblCompanyGLLookupCompanyWithholdings lu ON cal.intAccountLookup = lu.intAccountLookup INNER JOIN
                         dbo.tDept ON cal.intDepartmentID= dbo.tDept.ID
						 where cal.strCompanyName = @PayrollCompany

	RETURN
END


GO
