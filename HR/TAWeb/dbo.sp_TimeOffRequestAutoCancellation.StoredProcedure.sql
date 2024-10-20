USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_TimeOffRequestAutoCancellation]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TimeOffRequestAutoCancellation] 
	-- Add the parameters for the stored procedure here
	@clientId INT,
	@executionDate Datetime	
AS
BEGIN
	DECLARE @autoCancelDays INT = 3
	Declare @cancellationDate datetime
	Select top 1  @autoCancelDays= IsNull(Convert(int,[ApplicationConfigurationValue]),2)
	From ApplicationConfiguration
	Where [ApplicationConfigurationName] = 'TimeOffAutoCancelDays'
	And ClientId = @clientId

	Select @cancellationDate= DATEADD(DAY, @autoCancelDays, @executionDate)

	Select 
	EmployeeTimeOffRequestId,
	ClientId,
	'Auto-Cancel' as ProcessType
	From EmployeeTimeOffRequest
	Where DataEntryStatus = 1
	And ChangeRequestStatusId = 1 -- in progress
	And ClientId = @clientId
	And StartDate<= @cancellationDate
	Union All
	Select 
	EmployeeTimeOffRequestId,
	ClientId,
	'Reminder' as ProcessType
	From EmployeeTimeOffRequest
	Where DataEntryStatus = 1
	And ChangeRequestStatusId = 1 -- in progress
	And ClientId = @clientId
	And StartDate> @cancellationDate
END
GO
