USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClosedWorkFlowNotifications]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetClosedWorkFlowNotifications] 
	-- Add the parameters for the stored procedure here
			
	@ClientId as int,
	@LoginUserId as int,
	@unread as bit=1,
	@ChangeRequestStatusId int=2,
	@FromDate as date=null,
	@ToDate as date=null,
	@EmployeeId as int =null,
	@ShortFullName as nvarchar(250)=null,
	@WorkFlowTriggerTypeId as int =null,
	@WorkFlowActionTypeIds as nvarchar(250)=null,
	@LoginEmail as nvarchar(100)=null

As
Begin
 
   IF OBJECT_ID('tempdb..#temp_1') IS NOT NULL
    DROP TABLE #temp_1

	IF OBJECT_ID('tempdb..#temp_2') IS NOT NULL
    DROP TABLE #temp_2

--Get result in cte expression
;With CTETemp1
as
(
	SELECT WorkflowTriggerRequestId,WorkflowTriggerRequestDetailId,WorkflowLevelId,WorkflowActionTypeId,ActionById,
			ActionDate 

	FROM WorkflowTriggerRequestDetail 
	WHERE WorkflowTriggerRequestDetailId in(
		 SELECT  max(WorkflowTriggerRequestDetailId)  
		 FROM WorkflowTriggerRequestDetail 
		 WHERE ClientId=@ClientId		
		 AND DataEntryStatus=1
		 AND WorkflowActionTypeId=6
		 AND (Convert(date,CreatedDate) >= CONVERT(date,@FromDate) or @FromDate is null) and (Convert(date,CreatedDate) <= CONVERT(date,@ToDate) or @ToDate is null)
		 AND (WorkflowActionTypeId in (SELECT * FROM fn_splitIntIds(@WorkFlowActionTypeIds, ',')) or @WorkFlowActionTypeIds is null)

		 Group by WorkflowTriggerRequestId
		 )
 )

 SELECT ui.ShortFullName,ui.EmployeeId,innerData.*
	into #temp_1 
	FROM(
		SELECT 
			t.ActionById,
			t.ActionDate, 
			t.WorkflowTriggerRequestDetailId,
			t.WorkflowLevelId,
			t.WorkflowActionTypeId,
			t.WorkflowTriggerRequestId,
			wl.WorkflowLevelName as WorkFlowlevelExist,
			w.ClosingNotificationId,
			w.IsZeroLevel,
			wfl.WorkflowLevelTypeId,
			wfg.WorkflowLevelId as workflowgrouplevelexistid,
			(select COUNT(*) from WorkflowLevel where WorkflowId=w.WorkflowId and DataEntryStatus=1) as TotalLevel,
			(select COUNT(*) from WorkflowTriggerRequestDetail where WorkflowTriggerRequestId=wft.WorkflowTriggerRequestId and DataEntryStatus=1) as CurrentLevel,
			(select Max(WorkflowTriggerRequestDetailId) from WorkflowTriggerRequestDetail where WorkflowTriggerRequestId=wft.WorkflowTriggerRequestId and DataEntryStatus=1 and WorkflowActionTypeId!=6) as PrevWorkflowTriggerRequestDetailId,

			wt.WorkflowTriggerTypeId,

			etor.EmployeeTimeOffRequestId as etorid,
			cra.ChangeRequestAddressId as craid,
			cren.ChangeRequestEmailNumbersId as crenid,
			crec.ChangeRequestEmergencyContactId as crecid,
			cred.ChangeRequestEmployeeDependentId as credid,
			ssec.SelfServiceEmployeeCredentialId as ssecid,	
			ssed.SelfServiceEmployeeDocumentId as ssedid,
			etor.UserInformationId as etoruserinfromationid,
			cra.UserInformationId as crauserinformationid,
			cren.UserInformationId as crenuserinfromationid,
			crec.UserInformationId as crecuerinformationid,
			cred.UserInformationId as creduserinfromationid,
			ssec.UserInformationId as ssecuserinformationid,
			ssed.UserInformationId as sseduserinfromationid,
			Case 
				When etor.UserInformationId is not null
				then etor.UserInformationId
				When cra.UserInformationId is not null
				then cra.UserInformationId
				When cren.UserInformationId is not null
				then cren.UserInformationId
				When crec.UserInformationId is not null
				then crec.UserInformationId
				When cred.UserInformationId is not null
				then cred.UserInformationId
				When ssec.UserInformationId is not null
				then ssec.UserInformationId
				When ssed.UserInformationId is not null
				then ssed.UserInformationId
			End as refUserInformationId,
			Case 
				When etor.ChangeRequestStatusId is not null
				then etor.ChangeRequestStatusId
				When cra.ChangeRequestStatusId is not null
				then cra.ChangeRequestStatusId
				When cren.ChangeRequestStatusId is not null
				then cren.ChangeRequestStatusId
				When crec.ChangeRequestStatusId is not null
				then crec.ChangeRequestStatusId
				When cred.ChangeRequestStatusId is not null
				then cred.ChangeRequestStatusId
				When ssec.ChangeRequestStatusId is not null
				then ssec.ChangeRequestStatusId
				When ssed.ChangeRequestStatusId is not null
				then ssed.ChangeRequestStatusId
			End as refChangeRequestStatusId,
			wft.CreatedDate   
   
		From CTETemp1 t 
		left join WorkflowTriggerRequest wft on wft.WorkflowTriggerRequestId=t.WorkflowTriggerRequestId 
		left join WorkflowTrigger wt on wt.WorkflowTriggerId = wft.WorkflowTriggerId
		left join WorkflowLevel wl on wl.WorkflowLevelId=t.WorkflowLevelId
		left join Workflow w on w.WorkflowId=wl.WorkflowId
		left join WorkflowLevelType wfl on wfl.WorkflowLevelTypeId=wl.WorkflowLevelTypeId 
		left join (select WorkflowLevelId from WorkflowLevelGroup group by WorkflowLevelId)  wfg on wfg.WorkflowLevelId=t.WorkflowLevelId
		left join  EmployeeTimeOffRequest etor on etor.EmployeeTimeOffRequestId =  wft.EmployeeTimeOffRequestId 
		left join ChangeRequestAddress cra on cra.ChangeRequestAddressId =  wft.ChangeRequestAddressId 
		left join ChangeRequestEmailNumbers cren on cren.ChangeRequestEmailNumbersId =  wft.ChangeRequestEmailNumbersId 
		left join ChangeRequestEmergencyContact crec on crec.ChangeRequestEmergencyContactId =  wft.ChangeRequestEmergencyContactId 
		left join ChangeRequestEmployeeDependent cred on cred.ChangeRequestEmployeeDependentId =  wft.ChangeRequestEmployeeDependentId 
		left join SelfServiceEmployeeCredential ssec on ssec.SelfServiceEmployeeCredentialId =  wft.SelfServiceEmployeeCredentialId 
		left join SelfServiceEmployeeDocument ssed on ssed.SelfServiceEmployeeDocumentId =  wft.SelfServiceEmployeeDocumentId 
		)innerData
		Left join UserInformation ui on ui.UserInformationId= innerData.refUserInformationId
		Where refChangeRequestStatusId>=@ChangeRequestStatusId
		and (innerData.WorkflowTriggerTypeId=@WorkFlowTriggerTypeId or @WorkFlowTriggerTypeId is null)
		and (ui.ShortFullName like '%'+@ShortFullName+'%' or @ShortFullName is null)
		and (ui.EmployeeId =@EmployeeId or @EmployeeId is null)


Select *
Into #temp_2
From(
  Select * 
  From(
		Select 
			*,
			@LoginUserId as LoginUserId,
			dbo.fn_checkIsWorkflowNotificationUser(refUserInformationId,@LoginUserId,ClosingNotificationId,WorkflowLevelId,IsZeroLevel,@ClientId) as IsLoginUserForNotification
		From #temp_1
		) NotificationData
  Where NotificationData.IsLoginUserForNotification>0
  ) filteredUserNotification
 Where not exists( Select * from NotificationLogMessageReadBy 
					Where  filteredUserNotification.WorkflowTriggerRequestId= WorkflowTriggerRequestId And filteredUserNotification.LoginUserId=ReadById )
 Or @unread=0

 Select 
	
	case 
		when t3.etoruserinfromationid is not null then 'Time-Off Request'  
		when  t3.crauserinformationid is not null then 'Address Change Request' 
		when  t3.crenuserinfromationid is not null then 'Emails and Numbers' 
		when  t3.crecuerinformationid is not null then 'Emergency Contact' 
		when  t3.creduserinfromationid is not null then 'Employee Dependent'  
		when  t3.ssecuserinformationid is not null then 'Employee Credential' 
		when t3.sseduserinfromationid is not null then 'Employee Document'  
		else '' 
	end as RequestType,  
	case 
		when t3.etorid is not null then etorid  when  t3.craid is not null then craid 
		when  t3.crenid is not null then crenid 
		when  t3.crecid is not null then crecid 
		when  t3.credid is not null then credid  
		when  t3.ssecid is not null then ssecid 
		when t3.ssedid is not null then ssedid  
		else 0 
	end as ReferenceId,
	case 
		when t3.etorid is not null then '/EmployeeTimeOffRequest'  
		when  t3.craid is not null then 'ChangeRequestAddress' 
		when  t3.crenid is not null then 'ChangeRequestEmailsAndNumber' 
		when  t3.crecid is not null then 'ChangeRequestEmergencyContact' 
		when  t3.credid is not null then 'ChangeRequestEmployeeDependent'  
		when  t3.ssecid is not null then 'ChangeRequestEmployeeCredential' 
		when t3.ssedid is not null then 'ChangeRequestEmployeeDocument'  
		else '' 
	end as ControllerName,
	case 
		when t3.etorid is not null then 'TimeOffRequest'  
		when  t3.craid is not null then 'MailingChangeRequestAddress' 
		when  t3.crenid is not null then 'ChangeRequestEmailsAndNumbers' 
		when  t3.crecid is not null then 'ChangeRequestEmergencyContact' 
		when  t3.credid is not null then 'ChangeRequestEmployeeDependent'  
		when  t3.ssecid is not null then 'SelfServiceEmployeeCredential' 
		when t3.ssedid is not null then 'SelfServiceEmployeeDocument'  
		else '' 
		end as ActionName,
	case 
		when refChangeRequestStatusId=2 then 'A' 
		when refChangeRequestStatusId=3 then 'D' 
		when refChangeRequestStatusId=4 then 'C' 
		when refChangeRequestStatusId=5 then 'AC'
		else '' 
		end   as ActionType,
	t3.ShortFullName,
	t3.WorkflowTriggerTypeId,
	t3.WorkflowTriggerRequestId,
	t3.WorkflowTriggerRequestDetailId,
	t3.WorkflowActionTypeId,
	closingActionType.WorkflowActionTypeName,
	t3.TotalLevel,
	t3.CurrentLevel,
	t3.PrevWorkflowTriggerRequestDetailId,
	prevAction.WorkflowActionTypeId as PrevWorkflowActionTypeId,
	prevActionType.WorkflowActionTypeName as PrevWorkflowActionTypeName,
	t3.ActionById,
	'' as ActionPersonShortFullName,
	t3.ActionDate,
	t3.EmployeeId,	
	0 as CanApprove,
	t3.CreatedDate  
		
From #temp_2 t3
Left Join WorkflowActionType closingActionType on closingActionType.WorkflowActionTypeId = t3.WorkflowActionTypeId
Left Join WorkflowTriggerRequestDetail prevAction on prevAction.WorkflowTriggerRequestDetailId = t3.PrevWorkflowTriggerRequestDetailId
Left Join WorkflowActionType prevActionType on prevActionType.WorkflowActionTypeId = prevAction.WorkflowActionTypeId
Order by CreatedDate desc

 

   
END


GO
