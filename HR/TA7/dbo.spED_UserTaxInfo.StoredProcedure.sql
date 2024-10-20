USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserTaxInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/4/2024>
-- Description:	<To extract data for UserTaxInfo excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserTaxInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
	strCompanyName as [Company Name],
	strEIN as [Company Federal ID],
	userInfo.intUserId as [File #/Employee ID],
	[name] as [Employee Full Name],
	Case Len(sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],

	'' as [Federal Tax Form Year],
	case userInfo.sMaritalStatus
		when 'Single' then 'S'
		when 'Married' then 'M'
		else 'S'
	end	as [Federal Marital Status],
	0 as [Federal Exemptions],
	'' as [Fixed/Additional],
	'' as [Federal Extra Tax $],
	'' as [Federal Extra Tax %],
	'' as [Federal Tax Filing Status],
	'' as [Federal Tax Exemptions],
	'' as [Federal Tax Multiple Jobs],
	'' as [Federal Tax Dependents Amount],
	'' as [Federal Tax Other Income Amount],
	'' as [Federal Tax Deductions Amount],
	'' as [Federal Tax Additional Amount],
	'' as [Federal Tax Non-Resident Alien],

	'' as [Do Not Calculate Federal Tax],
	'' as [Do Not Calculate Federal Taxable],
	'' as [Do Not Calculate FUTA Taxable],
	'' as [Do Not Calculate Medicare],
	'' as [Do Not Calculate Social Security],

	'' as [Worked State - State Tax Code],
	'' as [Worked State - State Marital Status],
	'' as [Worked State - State Exemptions],
	'' as [Worked State - Dependent Exemptions],
	'' as [Worked State - AZ State Tax Withholding %],
	'' as [Worked State-  State Withholding Table],

	'' as [Bypass Puerto Rico Allowance],
	'' as [Block Workers Comp],
	'' as [SOC Code],

	'' as [Worked State - State Fixed/Additional],
	'' as [Worked State - State Extra Tax $],
	'' as [Worked State - State Extra Tax %],
	'' as [Worked State - Do Not Calculate State Tax],
	'' as [Worked State - Do Not Calculate State Taxable],

	'' as [SUI/SDI Tax Jurisdiction Code],
	'' as [Do Not Calc SUI/SDI Tax],
	'' as [Do Not Calc SUI/SDI Taxable],

	'' as [Lived State - State Tax Code],
	'' as [Lived State - State Marital Status],
	'' as [Lived State - State Exemptions],
	'' as [Lived State - Dependent Exemptions],
	'' as [Lived State - AZ State Tax Withholding %],
	'' as [Lived State - Fixed/Additional],
	'' as [Lived State - State Extra Tax $],
	'' as [Lived State - Do Not Calculate State Tax],
	'' as [Lived State - Do Not Calculate State Taxable],

	'' as [Worked Local Tax Code/Description ],
	'' as [PA Worked Local PSD Code],

	'' as [Worked Local - Local Exemptions],
	'' as [Worked Local- Local Extra Tax $],
	'' as [Worked Local- Local Extra Tax %],
	'' as [Worked Local- Do Not Calculate Local Tax],
	'' as [Worked Local- Do Not Calculate Local Taxable],

	'' as [Do Not Calc Oregon Transit Tax],
	'' as [Ohio Local School District Tax Code],
	'' as [Do Not Calc School District Tax],

	'' as [Lived Local Tax Code/Description],
	'' as [Lived Local - Local Exemptions],
	'' as [Lived Local- Local Extra Tax $],
	'' as [Lived Local- Local Extra Tax %],
	'' as [Lived Local- Do Not Calculate Local Tax],
	'' as [Lived Local- Do Not Calculate Local Taxable],


	'' as [NY Metro Commuter Transit Tax],
	'' as [PA LST Tax Code],
	'' as [PA LST - Do Not Calculate Local Tax]




FROM viewPay_UserRecord userInfo
LEFT JOIN tblUserHaciendaParameters userHacInfo ON userHacInfo.intUserID = userInfo.intUserID
LEFT JOIN tblUser499R4 userR4Info  ON userInfo.intUserID = userR4Info.intUserID
Order by strCompanyName, userInfo.intUserID
 
END
GO
