USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_getAuditLogReferenceUserId]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Waqar>
-- Create date: <2024-05-09>
-- Description:	<Use in inside the audit log script to update the missing employee user id in auditLog table>
-- =============================================
CREATE FUNCTION [dbo].[fn_getAuditLogReferenceUserId]
(
	-- Add the parameters for the function here
	@referenceId int,
	@recordType nvarchar(50)
	
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
declare @refUserId int =null

if @recordType='UserInformationActivation'
begin
 select @refUserId=userInformationId from UserInformationActivation where UserInformationActivationId=@referenceId
end
else if @recordType='UserInformation'
begin
 set @refUserId =@referenceId
end
else if @recordType='Account Registration'
begin
select @refUserId=@referenceId 
end
else if @recordType='EmployeeTimeOffRequest'
begin
select @refUserId=UserInformationId from EmployeeTimeOffRequest where EmployeeTimeOffRequestId=@referenceId 
end
else if @recordType='EmployeeTimeOffRequestDocument'
begin
select @refUserId=UserInformationId 
from EmployeeTimeOffRequest etr
inner join EmployeeTimeOffRequestDocument etrd on etr.EmployeeTimeOffRequestId = etrd.EmployeeTimeOffRequestId
where EmployeeTimeOffRequestDocumentId=@referenceId 
end
else if @recordType='EmployeeTimeAndAttendanceSetting'
begin
select @refUserId=UserInformationId from EmployeeTimeAndAttendanceSetting where EmployeeTimeAndAttendanceSettingId=@referenceId 
end
else if @recordType='PayInformationHistory'
begin
select @refUserId=UserInformationId from PayInformationHistory where PayInformationHistoryId=@referenceId 
end
else if @recordType='SupervisorCompany'
begin
select @refUserId=UserInformationId from SupervisorCompany where SupervisorCompanyId=@referenceId 
end
else if @recordType='EmployeeSupervisor'
begin
select @refUserId=EmployeeUserId from EmployeeSupervisor where EmployeeSupervisorId=@referenceId 
end
else if @recordType='EmployeeDentalInsurance'
begin
select @refUserId=UserInformationId from EmployeeDentalInsurance where EmployeeDentalInsuranceId=@referenceId 
end
else if @recordType='EmployeeHealthInsurance'
begin
select @refUserId=UserInformationId from EmployeeHealthInsurance where EmployeeHealthInsuranceId=@referenceId 
end
else if @recordType='PayInformationHistoryAuthorizer'
begin
select top 1 @refUserId=UserInformationId 
from PayInformationHistoryAuthorizer pha
inner join PayInformationHistory ph on pha.PayInformationHistoryId=ph.PayInformationHistoryId
where pha.PayInformationHistoryAuthorizerId=@referenceId 
end
else if @recordType='EmploymentHistoryAuthorizer'
begin
select top 1 @refUserId=UserInformationId 
from EmploymentHistoryAuthorizer eha
inner join EmploymentHistory eh on eha.EmploymentHistoryId=eh.EmploymentHistoryId
where eha.EmploymentHistoryAuthorizerId=@referenceId 
end
else if @recordType='ChangePasswordByAdminReason'
begin
select @refUserId=@referenceId 
end
else if @recordType='Employment'
begin
select @refUserId=UserInformationId from Employment where EmploymentId=@referenceId 
end
else if @recordType='UserInformationRole'
begin
select @refUserId=UserInformationId from UserInformationRole where UserRoleID=@referenceId 
end
else if @recordType='EmployeeCredential'
begin
select @refUserId=UserInformationId from EmployeeCredential where EmployeeCredentialId=@referenceId 
end
else if @recordType='EmployeeDocument'
begin
select @refUserId=UserInformationId from EmployeeDocument where EmployeeDocumentId=@referenceId 
end
else if @recordType='UserEmployeeGroup'
begin
select @refUserId=UserInformationId from UserEmployeeGroup where UserEmployeeGroupId=@referenceId 
end
else if @recordType='EmploymentHistory'
begin
select @refUserId=UserInformationId from EmploymentHistory where EmploymentHistoryId=@referenceId 
end
else if @recordType='UserContactInformation'
begin
select @refUserId=UserInformationId from UserContactInformation where UserContactInformationId=@referenceId 
end
else if @recordType='UserContactInformation'
begin
select @refUserId=UserInformationId from UserContactInformation where UserContactInformationId=@referenceId 
end
else if @recordType='EmergencyContact'
begin
select @refUserId=UserInformationId from EmergencyContact where EmergencyContactId=@referenceId 
end
else if @recordType='SupervisorDepartment'
begin
select @refUserId=UserInformationId from SupervisorDepartment where SupervisorDepartmentId=@referenceId 
end
else if @recordType='EmployeeVeteranStatus'
begin
select @refUserId=UserInformationId from EmployeeVeteranStatus where EmployeeVeteranStatusId=@referenceId 
end
else if @recordType='EmployeeEducation'
begin
select @refUserId=UserInformationId from EmployeeEducation where EmployeeEducationId=@referenceId 
end
else if @recordType='EmployeeTraining'
begin
select @refUserId=UserInformationId from EmployeeTraining where EmployeeTrainingId=@referenceId 
end

Return @refUserId;

END


GO
