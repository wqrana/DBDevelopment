USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeGeneralRptMain]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_rpt_EmployeeGeneralRptMain]
AS
SELECT 
ui.Id as UserInformationId,
ui.ClientId,
ui.CompanyID,
ui.DataEntryStatus,
-- General Info
ui.EmployeeStatusName,
ui.EmployeeStatusId,
ui.EmployeeId,
ui.SystemId,
ui.FirstName,
ui.MiddleInitial,
ui.FirstLastName,
ui.SecondLastName,
ui.ShortFullName,
ui.SSNEnd as SSN,
ui.BirthDate,
ui.BirthPlace,
ui.GenderName,
ui.MaritalStatusName,
ui.EthnicityName,
ui.DisabilityName,

CAST (STUFF(( 
			Select ','+ vs.VeteranStatusName 
			From EmployeeVeteranStatus evs
			Inner Join VeteranStatus vs ON evs.VeteranStatusId = vs.VeteranStatusId
			Where evs.DataEntryStatus = 1
			And evs.UserInformationId = ui.Id
			FOR XML PATH('')), 1, 1, ''
			) AS NVARCHAR(250)) AS VeteranStatusNames

--Contact Info
,contactInfo.CelNumber
,contactInfo.FaxNumber
,contactInfo.HomeNumber
,contactInfo.OtherNumber
,contactInfo.PersonalEmail
,contactInfo.WorkEmail
,contactInfo.OtherEmail

,contactInfo.HomeAddress1
,contactInfo.HomeAddress2
,contactInfo.HomeCityName
,contactInfo.HomeStateName
,contactInfo.HomeZipCode

,contactInfo.MailingAddress1
,contactInfo.MailingAddress2
,contactInfo.MailingCityName
,contactInfo.MailingStateName
,contactInfo.MailingZipCode
--Hiring Info
,hiringInfo.EmploymentId
,hiringInfo.OriginalHireDate
,hiringInfo.EffectiveHireDate
,hiringInfo.ProbationStartDate
,hiringInfo.ProbationEndDate
,hiringInfo.EmploymentStatusName
,hiringInfo.EmploymentStatusId
,hiringInfo.ServiceInYear
,hiringInfo.UseHireDateforYearsInService
,hiringInfo.TerminationDate
,hiringInfo.TerminationReasonName
--Employment Info
,employmentInfo.EmploymentHistoryId
,employmentInfo.StartDate as EmploymentStartDate
,employmentInfo.CompanyName
,employmentInfo.DepartmentName
,employmentInfo.DepartmentId
,employmentInfo.SubDepartmentName
,employmentInfo.SubDepartmentId
,employmentInfo.EmployeeTypeName
,employmentInfo.EmployeeTypeId
,employmentInfo.EmploymentTypeId
,employmentInfo.EmploymentTypeName
,employmentInfo.PositionName
,employmentInfo.PositionId
,employmentInfo.EmploymentEndDate
,employmentInfo.LocationName
,employmentInfo.LocationId
-- Employee Supervisor(s) comma seperated list
,CAST (STUFF(( 
			Select ','+ usri.ShortFullName 
			From EmployeeSupervisor es
			Inner Join UserInformation usri ON es.EmployeeSupervisorId = usri.UserInformationId
			Where es.DataEntryStatus = 1
			And es.EmployeeUserId = ui.Id
			FOR XML PATH('')), 1, 1, ''
			) AS NVARCHAR(250)) AS SupervisorNames

--Pay Info
,payInfo.PayInformationHistoryId
,payInfo.RateAmount
,payInfo.YearlyGrossPay
,payInfo.PeriodGrossPay
,payInfo.RateFrequencyName
,payInfo.PayTypeName
,payInfo.PayFrequencyName
,payInfo.EEOCategoryName
,payInfo.PayInfoEndDate
,payInfo.StartDate as PayInfoStartDate
,payInfo.PayScaleName
FROM   vw_UserInformation ui
LEFT JOIN vw_rpt_EmployeeContactInfo contactInfo ON ui.Id = contactInfo.UserInformationId
LEFT JOIN vw_rpt_EmployeeHiringHistory hiringInfo ON hiringInfo.EmploymentId = ui.EmploymentId
LEFT JOIN vw_rpt_EmployeeEmploymentHistory employmentInfo ON employmentInfo.EmploymentHistoryId = ui.EmploymentHistoryId
LEFT JOIN vw_rpt_EmployeePayInfoHistory payInfo ON payInfo.PayInformationHistoryId = ui.PayInformationHistoryId
GO
