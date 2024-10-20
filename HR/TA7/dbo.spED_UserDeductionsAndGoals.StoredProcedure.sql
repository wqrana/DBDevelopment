USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserDeductionsAndGoals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/4/2024>
-- Description:	<To extract data for User Deductions And Goals, excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserDeductionsAndGoals]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
	userInfo.strCompanyName as [Company Name],
	strEIN as [Company Federal ID],
	userInfo.intUserId as [File #/Employee ID],
	userInfo.[name] as [Employee Full Name],
	Case Len(sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],
	'' as [Deduction Start Date],
	'' as [Deduction End Date],

	--STUFF (
	--(SELECT ','+ CONCAT('<',LEFT(strWithHoldingsName,3),'>') FROM viewPay_UserWithholdingsRecord where (decEmployeePercent>0 or decEmployeeAmount>0) and intUserID=userInfo.intUserID  FOR XML PATH (''),type
 --   ).value('(./text())[1]','varchar(max)'),1,1,'') as [Deduction Code],
	--STUFF (
	--(SELECT ','+ CONCAT('<',strWithHoldingsName,'>') FROM viewPay_UserWithholdingsRecord where   (decEmployeePercent>0 or decEmployeeAmount>0) and intUserID=userInfo.intUserID  FOR XML PATH (''),type
 --   ).value('(./text())[1]','varchar(max)'),1,1,'') as [Deduction Description],
	strWithHoldingsName as [Deduction Code],
	strWithHoldingsName as [Deduction Description],
	CAST(decEmployeeAmount as decimal(18,2)) as [Deduction Amount],
	CAST(decEmployeePercent as decimal(18,2)) as [Deduction Factor],
	CAST(decCompanyAmount as decimal(18,2)) as [Employer Contribution Amount],
	CAST(decCompanyPercent as decimal(18,2)) as [Employer Contribution Percentage],

	'' as [Deduction in Arrears Code],
	'' as [Arrears Balance Adjustment],
	'' as [Goal Position Number],
	'' as [Goal Limit],
	'' as [Goal Accrual Adjustment]

FROM viewPay_UserRecord userInfo
INNER JOIN viewPay_UserWithholdingsRecord userWithholdingInfo ON userWithholdingInfo.intUserID = userInfo.intUserID
WHERE userWithholdingInfo.decEmployeeAmount>0 OR userWithholdingInfo.decEmployeePercent>0
AND strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS')
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
