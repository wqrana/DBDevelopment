USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_AuditLogInfo]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AuditLogInfo] 
	-- Add the parameters for the stored procedure here
	@fromDate datetime=null,
	@toDate datetime=null,
	@actionType nvarchar(10)='',
	@recordType nvarchar(100) = '',
	@employeeId int=0,
	@employeeName nvarchar(250) = '',	
	@supervisorId int,
	@clientId int,
	@companyId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	;With cte_supervisorEmployees
	as
	(
	
	Select distinct UserInformationId from dbo.fn_SupervisedEmployees(@clientId,@supervisorId)
	Union 
	select @supervisorId
	)

	SELECT
	
	Distinct
	alog.AuditLogId,
	alog.ReferenceId,
	aLogDetail.AuditLogDetailId,
	alog.CreatedDate,
	refUserInfo.UserInformationId as RefUserId,
	refUserInfo.EmployeeId,
	refUserInfo.ShortFullName as EmployeeName,
	alog.TableName as RecordType,
	alog.ActionType,
	aLogDetail.ColumnName as FieldName,
	aLogDetail.OldValue,
	aLogDetail.NewValue,
	alog.Remarks,
	auditByInfo.UserInformationId as SupervisorId,
	auditByInfo.EmployeeId as SupervisorEmployeeId,
	auditByInfo.ShortFullName as SupervisorName

	FROM AuditLog alog
	LEFT JOIN AuditLogDetail aLogDetail ON alog.AuditLogId = aLogDetail.AuditLogId
	INNER JOIN UserInformation auditByInfo ON auditByInfo.UserInformationId = alog.UserInformationId
	LEFT JOIN UserInformation refUserInfo ON refUserInfo.UserInformationId = alog.RefUserInformationId
	WHERE alog.DataEntryStatus=1
	AND IsNull(refUserInfo.EmployeeId,0) = IIF(@employeeId=0,IsNull(refUserInfo.EmployeeId,0),@employeeId)
	AND IsNull(refUserInfo.ShortFullName,'') like '%'+@employeeName+'%'
	AND CONVERT(datetime,CONVERT(date,alog.CreatedDate)) BETWEEN @fromDate AND @toDate
	AND alog.ActionType=IIF(@actionType='',alog.ActionType,@actionType)
	AND alog.TableName = IIF(@recordType='',alog.TableName,@recordType)
	AND auditByInfo.UserInformationId in (select UserInformationId from cte_supervisorEmployees)
	AND alog.ClientId = @clientId
	AND alog.CompanyId = @companyId
	Order by alog.CreatedDate desc
END
GO
