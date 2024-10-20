USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWorkFlowNotifications]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--used for pending notifications

CREATE PROCEDURE [dbo].[sp_GetWorkFlowNotifications] 
	-- Add the parameters for the stored procedure here
		
	@ClientId as int,
	@LoginUserId as int,
    @ChangeRequestStatusId as int=1

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
	SELECT WorkflowTriggerRequestId,WorkflowTriggerRequestDetailId,WorkflowLevelId,WorkflowActionTypeId

	FROM WorkflowTriggerRequestDetail 
	WHERE WorkflowTriggerRequestDetailId in(
		 SELECT  max(WorkflowTriggerRequestDetailId)  
		 FROM WorkflowTriggerRequestDetail 
		 WHERE ClientId=@ClientId		
		 AND DataEntryStatus=1		
		 Group by WorkflowTriggerRequestId
		 )
	AND WorkflowActionTypeId=1 -- pending notification
	
 )

	SELECT ui.ShortFullName,innerData.*
	into #temp_1 
	FROM(
		SELECT 
			--uf.ShortFullName, 
			t.WorkflowTriggerRequestDetailId,
			t.WorkflowLevelId,
			t.WorkflowActionTypeId,
			t.WorkflowTriggerRequestId,
			wl.WorkflowLevelName as WorkFlowlevelExist,
			w.ClosingNotificationId,
			w.IsZeroLevel,
			wfl.WorkflowLevelTypeId,
			wfg.WorkflowLevelId as workflowgrouplevelexistid,
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
		Where refChangeRequestStatusId=@ChangeRequestStatusId

-- Filter Notifications which are pending for read
Select *
Into #temp_2
From(
  Select * 
  From(
		Select 
			*,
			@LoginUserId as LoginUserId,
			dbo.fn_checkIsWorkflowPendingNotificationUser(refUserInformationId,@LoginUserId,WorkflowLevelTypeId,WorkflowLevelId,workflowgrouplevelexistid,@ClientId) as IsLoginUserForNotification
		From #temp_1
		) NotificationData
  Where NotificationData.IsLoginUserForNotification>0
  ) filteredUserNotification
 Where not exists( Select * from NotificationLogMessageReadBy 
					Where  filteredUserNotification.WorkflowTriggerRequestId= WorkflowTriggerRequestId And filteredUserNotification.LoginUserId=ReadById )

--select * from #temp_3
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
	
	t3.ShortFullName,
	t3.WorkflowTriggerRequestId,
	t3.WorkflowTriggerRequestDetailId,
	t3.CreatedDate  
		
	From #temp_2 t3
	Order by CreatedDate desc

END


GO
