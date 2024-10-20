USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserDashboardNotificationForecastDetail]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserDashboardNotificationForecastDetail] 
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
	Distinct NotificationForecastData.UserInformationId,ui.EmployeeId, ui.ShortFullName as EmployeeName,
	NotificationForecastData.RecordName,nt.NotificationTypeName as RecordType,
	NotificationForecastData.ExpirationDate 
	From 
	(
		Select ed.UserInformationId, d.DocumentName as RecordName,1 as NotificationTypeId,convert(datetime,convert(date,ed.ExpirationDate)) as ExpirationDate 
		From EmployeeDocument ed 
		Inner join Document d on d.DocumentId = ed.DocumentId
		where ed.DataEntryStatus = 1
		
		Union All
		
		Select ec.UserInformationId, c.CredentialName as RecordName,2 as NotificationTypeId,convert(datetime,convert(date,ec.ExpirationDate)) as ExpirationDate 
		From EmployeeCredential ec 
		Inner join Credential c on c.CredentialId = ec.CredentialId
		Where ec.DataEntryStatus = 1		
		
		Union All
				
		Select ecf.UserInformationId, cf.CustomFieldName as RecordName,3 as NotificationTypeId,convert(datetime,convert(date,ecf.ExpirationDate)) as ExpirationDate 
		From EmployeeCustomField ecf 
		Inner join CustomField cf on cf.CustomFieldId = ecf.CustomFieldId
		Where ecf.DataEntryStatus = 1
				
		) NotificationForecastData
		Inner Join UserInformation ui on ui.UserInformationId = NotificationForecastData.UserInformationId
		Inner Join NotificationType nt on nt.NotificationTypeId = NotificationForecastData.NotificationTypeId
		Where ui.UserInformationId in (select * from @selectedUserTbl)
		And NotificationForecastData.ExpirationDate Between @fromDate And @toDate 
		And ui.EmployeeStatusId != 3 -- closed Record

END
GO
