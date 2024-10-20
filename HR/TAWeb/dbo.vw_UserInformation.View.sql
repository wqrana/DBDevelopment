USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_UserInformation]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_UserInformation]
AS
SELECT ui.[UserInformationId] As Id
,ui.[UserInformationId]
,ui.Old_Id
,[EmployeeId]
,[IdNumber]
,[SystemId]
,[FirstName]
,[MiddleInitial]
,[FirstLastName]
,[SecondLastName]
,[ShortFullName]
,ui.[ClientId]
,[DefaultJobCodeId]
,ui.[EthnicityId]
,EthnicityName
,ui.[DisabilityId]
,DisabilityName
,ui.[EmployeeNote]
,ui.[GenderId]
,GenderName
,[BirthDate]
,[BirthPlace]
,ui.[MaritalStatusId]
,MaritalStatusName
,[SSNEncrypted]
,[SSNEnd]
,[PasswordHash]
,ui.[EmployeeStatusId]
,es.EmployeeStatusName
,[AspNetUserId]
,ui.[CreatedBy]
,ui.[CreatedDate]
,ui.[DataEntryStatus]
,ui.[ModifiedBy]
,ui.[ModifiedDate]
,[PictureFilePath]
,[ResumeFilePath]
,[EmployeeStatusDate]
,ui.[CompanyID]
,ui.refUserInformationId
,ui.IsRotatingSchedule
,ui.BaseScheduleId
,EmpHistory.EmploymentHistoryId
,EmpHistory.[DepartmentId]
,EmpHistory.[SubDepartmentId]
,EmpHistory.[EmployeeTypeID]
,EmpHistory.[PositionId]
,EmpHistory.[LocationId]
,EmpHistory.[EmploymentTypeId]
,EmpHistory.[SupervisorId]
,EmpHiring.EmploymentId
,EmpHiring.[EmploymentStatusId]
,PayInfo.PayInformationHistoryId
,ui.HasAllCompany

FROM UserInformation AS ui
LEFT JOIN Ethnicity et ON et.EthnicityId = ui.EthnicityId
LEFT JOIN Disability dis ON dis.DisabilityId = ui.DisabilityId
LEFT JOIN Gender gn ON gn.GenderId = ui.GenderId
LEFT JOIN MaritalStatus ms ON ms.MaritalStatusId = ui.MaritalStatusId
LEFT JOIN EmployeeStatus es ON es.EmployeeStatusId = ui.EmployeeStatusId
LEFT JOIN( 
		Select *
		From(
			Select ROW_NUMBER() over(partition by UserInformationId,EffectiveHireDate order by EmploymentId desc ) as EmpSeq, UserInformationId,EmploymentId,EmploymentStatusId,EffectiveHireDate
			From Employment) as h
		INNER JOIN (SELECT UserInformationId as CurrUserInformationId, MAX(EffectiveHireDate) AS CurrEffectiveHireDate
		FROM Employment
		WHERE DataEntryStatus = 1
	GROUP BY UserInformationId) AS currHiring ON currHiring.CurrUserInformationId = h.UserInformationId AND currHiring.CurrEffectiveHireDate = h.EffectiveHireDate
											  AND h.EmpSeq =1
)EmpHiring ON EmpHiring.UserInformationId = ui.UserInformationId

LEFT JOIN (
	Select * 
	From(
		Select ROW_NUMBER() over(partition by EmploymentId,StartDate order by EmploymentHistoryId desc ) as EmpHistorySeq ,UserInformationId,EmploymentId ,EmploymentHistoryId,[DepartmentId],[SubDepartmentId],[EmployeeTypeID],[EmploymentTypeId],[SupervisorId],LocationId ,PositionId,StartDate
		From EmploymentHistory ) as eh
		INNER JOIN (Select EmploymentId as CurrEmploymentId, MAX(StartDate) AS CurrStartDate
		FROM EmploymentHistory
		WHERE DataEntryStatus = 1 		
		GROUP BY EmploymentId) AS currEH ON EH.EmploymentId = currEH.CurrEmploymentId AND EH.StartDate = currEH.CurrStartDate AND eh.EmpHistorySeq=1
) EmpHistory ON EmpHistory.UserInformationId = ui.UserInformationId AND EmpHistory.EmploymentId = EmpHiring.EmploymentId


LEFT JOIN( select *
			From(
				Select ROW_NUMBER() over(partition by EmploymentId,StartDate order by PayInformationHistoryId desc ) as PayInfoSeq, UserInformationId,EmploymentId ,PayInformationHistoryId,StartDate
				From PayInformationHistory) AS pih
INNER JOIN (SELECT EmploymentId as CurrEmploymentId, MAX(StartDate) AS CurrStartDate
FROM PayInformationHistory
WHERE DataEntryStatus = 1
GROUP BY EmploymentId) AS currPayInfo ON currPayInfo.CurrEmploymentId = pih.EmploymentId AND currPayInfo.CurrStartDate = pih.StartDate And pih.PayInfoSeq =1
) PayInfo ON PayInfo.UserInformationId = ui.UserInformationId AND PayInfo.EmploymentId = EmpHiring.EmploymentId



GO
