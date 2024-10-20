USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserMasterfile]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <529/2024>
-- Description:	<To extract data for Masterfile excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserMasterfile]
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
	'Y' as [Use SSN as Federal EIN],
	'W2' as [1099 or W2 indicator],
	--IIF( strStatusName='Active','Y','N') as [Is Paid by WFN (Paid or Non Paid)],
	--'N' as [Is Primary Position],
	'Y' as [Is Paid by WFN (Paid or Non Paid)],
	'Y' as [Is Primary Position],
	FirstName as [First Name],
	MiddleInitial as [Middle Name],
	CONCAT(FirstLastName,' ',SecondLastName) as [Last Name],
	'' as [Generation Suffix],
    '' as [Salutation],
    '' as [Professional Suffix or Qualification Suffix],
    '' as [Pronouns],
    '' as [Maiden Name],
	sHomeAddressLine1 as [Address 1 Line 1],
	sHomeAddressLine2 as [Address 1 Line 2],
	'' as [Address 1 Line 3],
	sHomeCity as [Address 1 City],
  'PR' as [Address 1 State Postal Code],
  CONCAT('''',sHomeZipCode) as [Address 1 Zip Code],
  sHomeState as [Address 1 Country],
    case
	  when strStatusName='Active' then
	  'A'
	  when strStatusName='Inactive' and dTerminationDate is null then
	  'L'
	  when strStatusName='Inactive' and dTerminationDate is not null then
	  'T'
      when strStatusName='Closed Record' and dTerminationDate is not null then
	  'T'
	  else
	  ''
	end as [Employee Status],
	convert(varchar, dOriginalHiredDate, 101)  as [Original Hire Date],
	''  as [Hire Date],
	'' as [Hire Reason],
	'' as [Hiring Source],
	IIF(dBirthDate is null,'01/01/1900',convert(varchar, dBirthDate, 101)) as [Birth Date],
	convert(varchar, dTerminationDate, 101) as [Termination Date],
	'' as [Last Day Worked],
	'' as [Termination Reason],
    '' as [Termination Done By],
	'' as [Voluntary/Involuntary Termination],
    '' as [Termination Comments],
	'' [Leave of Absence Start Date],
	'' as [Leave of Absence Reason],
	'' as [Leave of Absence Expected Return Date],
	'' as [Leave of Absence Return Date],
	'' as [Leave of Absence Return Reason],
	'' as [Leave of Absence Is Paid],
	'' as [Rehire Date],
	'' as [Rehire Reason],
	'' as [Eligible For Rehire],
	'' as [Normal Retirement Date],
	'' as [Early Retirement Date],
	'' as [Credited Service Date],
	'' as [Seniority Date],
	'' as [Adjusted Service Date],
	sHomePhoneHum as [Home Phone Number],
	'' as [Business Phone Number],
	'' as [Personal Cell Number],
	'' as [Work Cell Number],
	email as [Personal E-Mail Address],
	'' as [Business E-mail Address],
	'' as [E-mail to Use for Notification],
	case
		when sSex='Male' 
		then 'M'
		when sSex ='Female'
		then 'F'
		when sSex ='Not Specified'
		then 'N'
		else 'M'
	end as [Gender],
	sMaritalStatus as [Actual Marital Status],
	'' as [Actual number of dependents],
	'' as [Tobacco User],
	'' as [EEO Ethnic Code],
	'' as [Ethnicity],
	'' as [Race ID Method],
	'' as [Race],
	'' as [Correspondence Language],
	'' as [Work Location Address Line 1],
	'' as [Work Location Address Line 2],
	'' as [Work Location Address Line 3],
	'' as [Work Location City],
	'' as [Work Location State],
	'' as [Work Location Zip Code],
	'' as [Work Location County],
	Case  userPayRate.intPayPeriod 
	When 0 then 'W'							--0	Weekly,1	BIweekly,2	Semimonthly,3	Monthly,4	Quarterly,5	Semianual,6	Annual,7	Daily (Per Day)
	When 1 then 'B'
	When 2 then 'S'
	When 3 then 'M'
	When 4 then 'Q'
	When 5 then 'SA'
	When 6 then 'A'
	When 7 then 'D'
	ELSE ''
	End	as [Pay Frequency Code],
	convert(varchar, userPayRate.dtStartDate, 101) as  [Primary Rate Effective Date],
	case userPayRate.intHourlyOrSalary
		When 0 then 'H'		
		When 1 then 'S'
		else 'N'
	end as [Rate Type],
	'' as [Rate Currency],
	userPayRate.decPayRate as [Rate 1 Amount],
	''	as [Rate 2 Currency],
	''	as [Rate 2 Amount],
	''	as [Rate 3 Amount],
	''	as [Rate 4 Amount],
	''	as [Rate 5 Amount],
	''	as [Rate 6 Amount],
	''	as [Rate 7 Amount],
	''	as [Rate 8 Amount],
	''	as [Rate 9 Amount],
	''  as [Standard Hours],
	''  as [Compensation Change Reason],
	''	as [FLSA Overtime],
	'N' as [FLSA Code],
	''	as [Pay Group],
	''	as [Tipped Employee],
	''	as [Direct/Indirect Tipped Employees],
	''  as [Employee Is Supervisor],
	''	as [Reports To Position ID],
	''	as [Statutory Employee],
	'N' as [Seasonal Employee Flag],
	''	as [Corporate Officer],
	''	as [Family Leave Insurance],
	''	as [Medical Leave Insurance],
	''	as [Voluntary Plan Disability Insurance],
	''	as [Date 11],
	''	as [Date 12],
	''	as [Date 13],
	''	as [Date 14],
	''	as [Date 15],
	''	as [Badge ID],
	''	as [Clock],
	''	as [Custom Area 1],
	''	as [Custom Area 2],
	''	as [Custom Area 3],
	''	as [Custom Area 4]
FROM viewPay_UserRecord userInfo
LEFT JOIN (
		Select ROW_NUMBER() OVER(PARTITION BY intUserID ORDER BY dtStartDate DESC) RecordId,intUserID,dtStartDate,intPayPeriod
		,intHourlyOrSalary,decPayRate  
		From tblUserPayRates
		) userPayRate ON userInfo.intUserID = userPayRate.intUserID AND userPayRate.RecordId=1
Order by strCompanyName, userInfo.intUserId
 -- SELECT  	

	--( select 
	--	case count(*) 
	--		when 0 then 'N' 
	--		else 'Y' end IsSupervisor  
	--		from fn_SupervisedEmployees(@ClientId,userInfo.UserInformationId)) as [Employee Is Supervisor],
	
	--''	as [Reports To Position ID],
	--''	as [Statutory Employee],
	--'N' as [Seasonal Employee Flag],
	--''	as [Corporate Officer],
	--''	as [Family Leave Insurance],
	--''	as [Medical Leave Insurance],
	--''	as [Voluntary Plan Disability Insurance],
	--''	as [Date 11],
	--''	as [Date 12],
	--''	as [Date 13],
	--''	as [Date 14],
	--''	as [Date 15],
	--''	as [Badge ID],
	--''	as [Clock],
	--''	as [Custom Area 1],
	--''	as [Custom Area 2],
	--''	as [Custom Area 3],
	--''	as [Custom Area 4]

 -- FROM vw_UserInformation userInfo
 -- INNER JOIN Company cmp ON cmp.CompanyId = userInfo.CompanyID
 -- LEFT JOIN vw_rpt_EmployeeContactInfo contactInfo ON userInfo.UserInformationId = contactInfo.UserInformationId
 -- LEFT JOIN Country HomeCountry on HomeCountry.CountryId = contactInfo.HomeCountryId
 -- LEFT JOIN vw_rpt_EmployeeHiringHistory hiring on  hiring.EmploymentId = userInfo.EmploymentId
 -- LEFT JOIN EmploymentHistory empHistory on empHistory.EmploymentId = hiring.EmploymentId and empHistory.ClosedBy is not null
 -- LEFT JOIN vw_rpt_EmployeePayInfoHistory payInfo on userInfo.PayInformationHistoryId = payInfo.PayInformationHistoryId

 -- LEFT JOIN UserInformation TerminatedBy on TerminatedBy.UserInformationId = empHistory.ClosedBy
 -- WHERE userInfo.ClientId=@ClientId
END
GO
