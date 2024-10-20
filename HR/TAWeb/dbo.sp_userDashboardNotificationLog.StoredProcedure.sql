USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_userDashboardNotificationLog]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_userDashboardNotificationLog] 
	-- Add the parameters for the stored procedure here
	@userIds nvarchar(max)='',
	@fromDate datetime=null,
	@toDate datetime= null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	Declare @selectedUserTbl As Table(Id Bigint)

	Insert Into @selectedUserTbl
	Select * 
	From dbo.fn_splitIntIds(@userIds,',')
		
    -- Notification data
	Select 
	Distinct NotificationData.NotificationLogId,NotificationData.UserInformationId,ui.EmployeeId, ui.ShortFullName as EmployeeName,
	NotificationData.NotificationDate,NotificationData.RecordName,nt.NotificationTypeName as RecordType,
	NotificationData.RecordStatus, NotificationData.ExpirationDate 
	From 
	(
		Select nl.NotificationLogId,ed.UserInformationId,convert(datetime,convert(date,nl.CreatedDate)) as NotificationDate
		,d.DocumentName as RecordName,ed.ExpirationDate, nl.NotificationTypeId,
		 IIF(IsNull(nl.IsNotificationAsExpired,0)=0,'Notifying','Expired') as RecordStatus
		From NotificationLog nl
		Inner join EmployeeDocument ed on ed.EmployeeDocumentId = nl.EmployeeDocumentId
		Inner join Document d on d.DocumentId = ed.DocumentId
		where nl.DataEntryStatus = 1
		And nl.CreatedDate = (Select Max(CreatedDate) 
								From NotificationLog nlog
								Where nlog.EmployeeDocumentId = nl.EmployeeDocumentId 
								And nlog.DataEntryStatus = 1)
		Union All
		
		Select nl.NotificationLogId,ec.UserInformationId,convert(datetime,convert(date,nl.CreatedDate)) as NotificationDate
		,c.CredentialName as RecordName,ec.ExpirationDate, nl.NotificationTypeId,
		 IIF(IsNull(nl.IsNotificationAsExpired,0)=0,'Notifying','Expired') as RecordStatus
		From NotificationLog nl
		Inner join EmployeeCredential ec on ec.EmployeeCredentialId = nl.EmployeeCredentialId
		Inner join Credential c on c.CredentialId = ec.CredentialId
		Where nl.DataEntryStatus = 1
		And nl.CreatedDate = (Select Max(CreatedDate) 
								From NotificationLog nlog
								Where nlog.EmployeeCredentialId = nl.EmployeeCredentialId 
								And nlog.DataEntryStatus = 1)

		Union All
		
		Select nl.NotificationLogId,ecf.UserInformationId,convert(datetime,convert(date,nl.CreatedDate)) as NotificationDate
		,cf.CustomFieldName as RecordName,ecf.ExpirationDate, nl.NotificationTypeId,
		 IIF(IsNull(nl.IsNotificationAsExpired,0)=0,'Notifying','Expired') as RecordStatus
		From NotificationLog nl
		Inner join EmployeeCustomField ecf on ecf.EmployeeCustomFieldId = nl.EmployeeCustomFieldId
		Inner join CustomField cf on cf.CustomFieldId = ecf.CustomFieldId
		Where nl.DataEntryStatus = 1
		And nl.CreatedDate = (Select Max(CreatedDate) 
								From NotificationLog nlog
								Where nlog.EmployeeCustomFieldId = nl.EmployeeCustomFieldId 
								And nlog.DataEntryStatus = 1)
		
		) NotificationData
		Inner Join UserInformation ui on ui.UserInformationId = NotificationData.UserInformationId
		Inner Join NotificationType nt on nt.NotificationTypeId = NotificationData.NotificationTypeId
		Where ui.UserInformationId in (select * from @selectedUserTbl)
		And NotificationData.NotificationDate Between @fromDate And @toDate 
		And ui.EmployeeStatusId != 3 -- closed Record

END

GO
