USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[spED_EmployeeMasterfile]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<WaqarQ>
-- Create date: <5/23/2024>
-- Description:	<To extract data for Masterfile excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_EmployeeMasterfile]
@ClientId int = 2
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @tblSupervisorUser  as table(SupervisorId int)
	--Get supervisor lis under the client
	Insert Into @tblSupervisorUser
	Select ui.UserInformationId 
	from(
	select distinct UserInformationId
	from SupervisorCompany
	union 
	select distinct UserInformationId
	from SupervisorDepartment
	union
	select distinct UserInformationId
	from SupervisorSubDepartment
	union
	select distinct UserInformationId
	from SupervisorEmployeeType
	union
	select distinct SupervisorUserId
	from EmployeeSupervisor
	union
	select UserInformationId 
	from UserInformationRole uir 
	inner join Role r ON uir.RoleID = r.RoleId 
	where r.RoleTypeId = 1
	) sup
	Inner Join UserInformation ui on ui.UserInformationId = sup.UserInformationId
	Where ui.ClientId=@ClientId


  SELECT 
  cmp.CompanyName as [Company Name],
  cmp.EIN as [Company Federal ID],
  userInfo.EmployeeId as [File #/Employee ID],
  userInfo.ShortFullName as [Employee Full Name],
  case ISNUMERIC(dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D'))
  When 1 then 
  format(CAST(dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D')as int),'###-##-####') 
  else
  dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D')
  end as [Social Security Number],

  'Y' as [Use SSN as Federal EIN],
  'W2' as [1099 or W2 indicator],
  --IIF( userInfo.EmployeeStatusId=1,'Y','N') as [Is Paid by WFN (Paid or Non Paid)],
  	'Y' as [Is Paid by WFN (Paid or Non Paid)],
	'Y' as [Is Primary Position],
  userInfo.FirstName as [First Name],
  userInfo.MiddleInitial as [Middle Name],
  CONCAT(userInfo.FirstLastName,' ',userInfo.SecondLastName) as [Last Name],
  '' as [Generation Suffix],
  '' as [Salutation],
  '' as [Professional Suffix or Qualification Suffix],
  '' as [Pronouns],
  '' as [Maiden Name],
  contactInfo.HomeAddress1 as [Address 1 Line 1],
  contactInfo.HomeAddress2 as [Address 1 Line 2],
  '' as [Address 1 Line 3],
  contactInfo.HomeCityName as [Address 1 City],
  IIF(contactInfo.HomeAddress1 is not null,'PR','') as [Address 1 State Postal Code],
  CONCAT('''',contactInfo.HomeZipCode) as [Address 1 Zip Code],
  HomeCountry.CountryName as [Address 1 Country],
  case
	  when userInfo.EmployeeStatusId=1 then
	  'A'
	  when userInfo.EmployeeStatusId=2 and hiring.TerminationDate is null then
	  'L'
	  when userInfo.EmployeeStatusId=2 and hiring.TerminationDate is not null then
	  'T'
      when userInfo.EmployeeStatusId=3 and hiring.TerminationDate is not null then
	  'T'
	  else
	  ''
	end as [Employee Status],
	convert(varchar, hiring.OriginalHireDate, 101)  as [Original Hire Date],
	convert(varchar, hiring.EffectiveHireDate, 101)  as [Hire Date],
	'' as [Hire Reason],
	'' as [Hiring Source],
	IIF(userInfo.BirthDate is null,'01/01/1900',convert(varchar, userInfo.BirthDate, 101)) as [Birth Date],
	IIF((userInfo.EmployeeStatusId=2 or userInfo.EmployeeStatusId=3) and hiring.TerminationDate is not null,convert(varchar, hiring.TerminationDate, 101),'' ) as [Termination Date],
	'' as [Last Day Worked],
	IIF((userInfo.EmployeeStatusId=2 or userInfo.EmployeeStatusId=3) and hiring.TerminationDate is not null,hiring.TerminationReasonName,'') as [Termination Reason],
    IIF((userInfo.EmployeeStatusId=2 or userInfo.EmployeeStatusId=3) and hiring.TerminationDate is not null,TerminatedBy.ShortFullName,'') as [Termination Done By],
	IIF((userInfo.EmployeeStatusId=2 or userInfo.EmployeeStatusId=3) and hiring.TerminationDate is not null, (case when Left(hiring.TerminationTypeName,1)='V' then 'V' when Left(hiring.TerminationTypeName,1)='I' then 'I' else '' end),'') as [Voluntary/Involuntary Termination],
    IIF((userInfo.EmployeeStatusId=2 or userInfo.EmployeeStatusId=3) and hiring.TerminationDate is not null,trim(hiring.TerminationNotes),'') as [Termination Comments],
	IIF((userInfo.EmployeeStatusId=2 and hiring.TerminationDate is null),convert(varchar, userInfo.EmployeeStatusDate,101),'') [Leave of Absence Start Date],
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
	IIF(isNumeric(contactInfo.HomeNumber)=1,Format(Cast(contactInfo.HomeNumber as bigint),'(###) ###-####'),contactInfo.HomeNumber)
	 as [Home Phone Number],
	IIF(isNumeric(contactInfo.WorkNumber)=1,Format(Cast(contactInfo.WorkNumber as bigint),'(###) ###-####'),contactInfo.WorkNumber)
	 as [Business Phone Number],
	IIF(isNumeric(contactInfo.CelNumber)=1,Format(Cast(contactInfo.CelNumber as bigint),'(###) ###-####'),contactInfo.CelNumber)
	 as [Personal Cell Number],
	'' as [Work Cell Number],
	contactInfo.PersonalEmail as [Personal E-Mail Address],
	contactInfo.WorkEmail as [Business E-mail Address],
	case 
		when contactInfo.NotificationEmail = contactInfo.PersonalEmail 
		then 'P'
		when contactInfo.NotificationEmail = contactInfo.WorkEmail
		then 'W'
	end as [E-mail to Use for Notification],
	case
		when userInfo.GenderName='Male' 
		then 'M'
		when userInfo.GenderName ='Female'
		then 'F'
		when userInfo.GenderName ='Not Specified'
		then 'N'
		else 'M'
	end as [Gender],
	userInfo.MaritalStatusName as [Actual Marital Status],
	(
	 select count(*) 
	 from EmployeeDependent 
	 where UserInformationId = userInfo.UserInformationId
	 and DataEntryStatus=1
	) as [Actual number of dependents],
	'' as [Tobacco User],
	case userInfo.EthnicityName
		when 'White' then '1'
		when ' Black or African American' then '2'
		when 'Hispanic or Latino' then '3'
		when 'Asian' then '4'
		when 'American Indian or Alaskan Native' then '5'
		when 'Native Hawaiian or Other Pacific Islander' then '6'
		when 'Two or More Races' then '4'
	end as [EEO Ethnic Code],
	case IsNull(userInfo.EthnicityName,'')		
		when 'Hispanic or Latino' then 'H'
		when '' then ''
		else 'N'
	end as [Ethnicity],
	'' as [Race ID Method],
	case userInfo.EthnicityName
		when 'White' then '1'
		when ' Black or African American' then '2'
		when 'Hispanic or Latino' then '3'
		when 'Asian' then '4'
		when 'American Indian or Alaskan Native' then '5'
		when 'Native Hawaiian or Other Pacific Islander' then '6'
		when 'Two or More Races' then '4'
	end as [Race],
	'' as [Correspondence Language],
	'' as [Work Location Address Line 1],
	'' as [Work Location Address Line 2],
	'' as [Work Location Address Line 3],
	'' as [Work Location City],
	'' as [Work Location State],
	'' as [Work Location Zip Code],
	'' as [Work Location County],
	Upper(Left(IsNull(payInfo.PayFrequencyName,''),1)) as [Pay Frequency Code],
	Convert(varchar, payInfo.StartDate,101) as [Primary Rate Effective Date],
	case Upper(Left(IsNull(payInfo.RateFrequencyName,'N'),1))
		When 'H' then 'H'
		When 'D' then 'H'
		When 'N' then 'N'
		else 'S'
	end as [Rate Type],
	'' as [Rate Currency],
	--case Upper(Left(IsNull(payInfo.RateFrequencyName,'N'),1))
	--	When 'H' then Concat('''',Format(payInfo.RateAmount,'N4'))
	--	else
	--		 Concat('''',Format(payInfo.PeriodGrossPay,'N'))
	--end as [Rate 1 Amount],
	case Upper(Left(IsNull(payInfo.RateFrequencyName,'N'),1))
		When 'H' then payInfo.RateAmount
		else
			 payInfo.PeriodGrossPay
	end as [Rate 1 Amount],
	''	as [Rate 2 Currency],
	''	as [Rate 2 Amount],
	''	as [Rate 3 Amount],
	''	as [Rate 4 Amount],
	''	as [Rate 5 Amount],
	''	as [Rate 6 Amount],
	''	as [Rate 7 Amount],
	''	as [Rate 8 Amount],
	''	as [Rate 9 Amount],
	payInfo.PeriodHours as [Standard Hours],
	''	as [Compensation Change Reason],
	''	as [FLSA Overtime],
	'N' as [FLSA Code],
	''	as [Pay Group],
	''	as [Tipped Employee],
	''	as [Direct/Indirect Tipped Employees],
	--( select 
	--	case count(*) 
	--		when 0 then 'N' 
	--		else 'Y' end IsSupervisor  
	--		from fn_SupervisedEmployees(@ClientId,userInfo.UserInformationId)) as [Employee Is Supervisor],
	IIF(exists(Select * from @tblSupervisorUser where SupervisorId =userInfo.UserInformationId),'Y','N') as [Employee Is Supervisor],
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

  FROM vw_UserInformation userInfo
  INNER JOIN Company cmp ON cmp.CompanyId = userInfo.CompanyID
  LEFT JOIN vw_rpt_EmployeeContactInfo contactInfo ON userInfo.UserInformationId = contactInfo.UserInformationId
  LEFT JOIN Country HomeCountry on HomeCountry.CountryId = contactInfo.HomeCountryId
  LEFT JOIN vw_rpt_EmployeeHiringHistory hiring on  hiring.EmploymentId = userInfo.EmploymentId
  LEFT JOIN EmploymentHistory empHistory on empHistory.EmploymentId = hiring.EmploymentId and empHistory.ClosedBy is not null
  LEFT JOIN vw_rpt_EmployeePayInfoHistory payInfo on userInfo.PayInformationHistoryId = payInfo.PayInformationHistoryId

  LEFT JOIN UserInformation TerminatedBy on TerminatedBy.UserInformationId = empHistory.ClosedBy
  WHERE userInfo.ClientId=@ClientId
  Order by cmp.CompanyName, userInfo.EmployeeId
END
GO
