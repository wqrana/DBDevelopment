USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_CRAutoCancellation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CRAutoCancellation] 
	-- Add the parameters for the stored procedure here
	@clientId INT,
	@executionDate Datetime	
AS
BEGIN
	DECLARE @autoCancelDays INT = 3
	Declare @cancellationDate datetime
	Select top 1  @autoCancelDays= IsNull(Convert(int,[ApplicationConfigurationValue]),2)
	From ApplicationConfiguration
	Where [ApplicationConfigurationName] = 'CRAutoCancelAfterDays'
	And ClientId = @clientId

	--Select @cancellationDate= DATEADD(DAY, @autoCancelDays, @executionDate)
	select * 
	From(
		--CRAddress
		Select *
		 From(
				Select 
				CRAddress.ChangeRequestAddressId as ReferenceId,
				ClientId,
				'CRAddress' as RequestType,
				'Auto-Cancel' as ProcessType	
				From [dbo].[ChangeRequestAddress] CRAddress
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)<= @executionDate
				Union 
				Select 
				CRAddress.ChangeRequestAddressId as ReferenceId,
				ClientId,
				'CRAddress' as RequestType,
				'Reminder' as ProcessType	
				From [dbo].[ChangeRequestAddress] CRAddress
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)> @executionDate
			) As CRAddress
		 Union 
		 --CREmailNumbers
		 Select *
		 From(
				Select 
				CREmailNumbers.ChangeRequestEmailNumbersId as ReferenceId,
				ClientId,
				'CREmailNumbers' as RequestType,
				'Auto-Cancel' as ProcessType	
				From [dbo].[ChangeRequestEmailNumbers] CREmailNumbers
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)<= @executionDate
				Union 
				Select 
				CREmailNumbers.ChangeRequestEmailNumbersId as ReferenceId,
				ClientId,
				'CREmailNumbers' as RequestType,
				'Reminder' as ProcessType	
				From [dbo].[ChangeRequestEmailNumbers] CREmailNumbers
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)> @executionDate
			) As CREmailNumbers
		 Union 
		 --CREmergencyContact
		 Select *
		 From(
				Select 
				CREmergencyContact.ChangeRequestEmergencyContactId as ReferenceId,
				ClientId,
				'CREmergencyContact' as RequestType,
				'Auto-Cancel' as ProcessType	
				From [dbo].[ChangeRequestEmergencyContact] CREmergencyContact
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)<= @executionDate
				Union 
				Select 
				CREmergencyContact.ChangeRequestEmergencyContactId as ReferenceId,
				ClientId,
				'CREmergencyContact' as RequestType,
				'Auto-Cancel' as ProcessType	
				From [dbo].[ChangeRequestEmergencyContact] CREmergencyContact
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)> @executionDate
			) As CREmergencyContact
			Union
			--CREmployeeDependent
			Select *
			From(
				Select 
				CREmployeeDependent.ChangeRequestEmployeeDependentId as ReferenceId,
				ClientId,
				'CREmployeeDependent' as RequestType,
				'Auto-Cancel' as ProcessType	
				From [dbo].[ChangeRequestEmployeeDependent] CREmployeeDependent
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)<= @executionDate
				Union 
				Select 
				CREmployeeDependent.ChangeRequestEmployeeDependentId as ReferenceId,
				ClientId,
				'CREmployeeDependent' as RequestType,
				'Reminder' as ProcessType	
				From [dbo].[ChangeRequestEmployeeDependent] CREmployeeDependent
				Where DataEntryStatus = 1
				And ChangeRequestStatusId = 1 -- in progress
				And ClientId = @clientId
				And DATEADD(DAY, @autoCancelDays, CreatedDate)> @executionDate
			) As CREmployeeDependent
		) CRData
		Order by ClientId,RequestType
END
GO
