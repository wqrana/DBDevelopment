USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWorkflowNotificationHistory]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWorkflowNotificationHistory]  
	@ClientId as int,
	@LoginEmail as nvarchar(100),
	@FromDate date=null,
	@ToDate date=null,
	@EmployeeId as int =null,
	@ShortFullName as nvarchar(250)=null,
	@WorkFlowTriggerTypeId as int =null,
	@WorkFlowActionTypeIds as nvarchar(250)=null
  
AS
BEGIN
	 

	IF OBJECT_ID('tempdb..#temp_2') IS NOT NULL
    DROP TABLE #temp_1

	IF OBJECT_ID('tempdb..#FiltersId') IS NOT NULL
    DROP TABLE #FiltersId




select *, ROW_NUMBER() OVER (
     ORDER BY workflowtriggerrequestdetailid desc) AS row_number_1  into #temp_1 from(
  select 0 as CanApprove,t.WorkflowTriggerRequestId,t.ActionById,t.ActionDate, uf.ShortFullName,uf.EmployeeId,wt.WorkflowTriggerTypeId,t.WorkflowActionTypeId, t.WorkflowTriggerRequestDetailId,t.WorkflowLevelId,wl.WorkflowLevelName as WorkFlowlevelExist,wfl.WorkflowLevelTypeId,wfg.WorkflowLevelId as workflowgrouplevelexistid
 ,(select COUNT(*) from WorkflowLevel where WorkflowId=w.WorkflowId) as TotalLevel
 ,etor.EmployeeTimeOffRequestId as etorid,cra.ChangeRequestAddressId as craid,cren.ChangeRequestEmailNumbersId as crenid,crec.ChangeRequestEmergencyContactId as crecid,cred.ChangeRequestEmployeeDependentId as credid,ssec.SelfServiceEmployeeCredentialId as ssecid
 ,ssed.SelfServiceEmployeeDocumentId as ssedid,etor.UserInformationId as etoruserinfromationid,cra.UserInformationId as crauserinformationid
 ,cren.UserInformationId as crenuserinfromationid,crec.UserInformationId as crecuerinformationid,cred.UserInformationId as creduserinfromationid,ssec.UserInformationId as ssecuserinformationid
 ,ssed.UserInformationId as sseduserinfromationid,wft.CreatedDate
   
   
   
   from workflowtriggerrequestdetail t 
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
left join UserInformation uf on ( etor.UserInformationId is null or uf.UserInformationId= etor.UserInformationId ) and (cra.UserInformationId is null or uf.UserInformationId= cra.UserInformationId )
and (cren.UserInformationId is null or  uf.UserInformationId= cren.UserInformationId ) and ( crec.UserInformationId is null or uf.UserInformationId= crec.UserInformationId  )
and ( cred.UserInformationId is null or  uf.UserInformationId= cred.UserInformationId ) and (ssec.UserInformationId is null or  uf.UserInformationId= ssec.UserInformationId )
and (ssed.UserInformationId is null or  uf.UserInformationId= ssed.UserInformationId  )



WHERE
t.ClientId=@ClientId
and WorkflowActionTypeId != 6
and (Convert(date,t.CreatedDate) >= CONVERT(date,@FromDate) or @FromDate is null) and (Convert(date,t.CreatedDate) <= CONVERT(date,@ToDate) or @ToDate is null)
and (t.WorkflowActionTypeId in (SELECT * FROM fn_splitIntIds(@WorkFlowActionTypeIds, ',')) or @WorkFlowActionTypeIds is null)
and (wt.WorkflowTriggerTypeId=@WorkFlowTriggerTypeId or @WorkFlowTriggerTypeId is null)
and (uf.ShortFullName like '%'+@ShortFullName+'%' or @ShortFullName is null)
and (uf.EmployeeId =@EmployeeId or @EmployeeId is null)



)t1



 
DECLARE @Counter INT , @MaxId INT, 
        @CountryName NVARCHAR(100),
		@WorkflowLevelId int =0 ,
		@WorkflowTriggerRequestDetailId int =0 ,
		@counttable as int =0,
		@workflowgrouplevelExit as int =0,
		@WorkFlowLevelTypeId as int = 0,
		@workflowActionTypeId as int =0,
		@WorkFlowlevelExist as nvarchar =null,
		@crauserinformationid as int = 0,
		@crenuserinfromationid as int = 0,
		@etoruserinformationid as int =0,
		@crecuerinformationid as int =0,
		@ssecuserinformationid as int =0,
		@sseduserinfromationid as int =0,
		@creduserinfromationid as int =0,
		@workflowTriggerRequestId as int =0,
		@ActionType as varchar(10),
		@condition1 as int =0,
		@condition2 as int =0,
		@condition3 as int =0,
		@condition4 as int =0,
        @condition5 as int =0,
		@condition5_1 as int =0,
		@condition5_2 as int =0,
		@condition5_3 as int =0,
		@counttable2 as int =0

SELECT @Counter = min(row_number_1) , @MaxId = max(row_number_1) 
FROM #temp_1



 create table #FiltersId(
   Id int
   )

 
WHILE(@Counter IS NOT NULL
      AND @Counter <= @MaxId)
BEGIN



   SELECT @crecuerinformationid =crecuerinformationid,
		@sseduserinfromationid = sseduserinfromationid,
		@etoruserinformationid  =etoruserinfromationid ,
		@crauserinformationid  =crauserinformationid,
		@ssecuserinformationid  =ssecuserinformationid,
		@crenuserinfromationid  =crenuserinfromationid,
		@creduserinfromationid  = creduserinfromationid ,
		@workflowgrouplevelExit=workflowgrouplevelexistid, 
		@WorkflowLevelId=WorkflowLevelId ,
		@WorkFlowLevelTypeId=WorkFlowLevelTypeId,
		@WorkflowTriggerRequestDetailId  = WorkflowTriggerRequestDetailId,
		@workflowActionTypeId=WorkflowLevelTypeId,
		@WorkFlowlevelExist=WorkFlowlevelExist,
		@workflowgrouplevelExit=workflowgrouplevelexistid
   FROM #temp_1 WHERE row_number_1 = @Counter

  

if(@WorkFlowlevelExist = null)
--condition 1
  begin
 SET @Counter  = @Counter  + 1 
 SET @condition1  = @condition1  + 1  
 continue  
end

if @WorkFlowLevelTypeId=1
--condition 2
  begin 

     
	SET @counttable = 0

    Select @counttable = count(distinct userInfo.UserInformationId)   From vw_UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join EmployeeSupervisor ES on ES.SupervisorUserId = userInfo.UserInformationId
	Where  userInfo.ClientId = @ClientId And ES.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	and UCI.LoginEmail=@LoginEmail
	and (userInfo.Id <> @etoruserinformationid or @etoruserinformationid is null) and (  userInfo.id <> @crauserinformationid or @crauserinformationid is null ) and( userInfo.id <> @crenuserinfromationid or @crenuserinfromationid is null) and( userInfo.id <> @crecuerinformationid or @crecuerinformationid is null )  and  ( userInfo.id <> @ssecuserinformationid or @ssecuserinformationid is null ) and (userInfo.id <> @creduserinfromationid  or @creduserinfromationid is null)   and (userInfo.id <>  @sseduserinfromationid  or @sseduserinfromationid is null )    
	and (ES.EmployeeUserId = @etoruserinformationid or @etoruserinformationid is null) and ( ES.EmployeeUserId  = @crauserinformationid or @crauserinformationid is null ) and (ES.EmployeeUserId  = @crenuserinfromationid or @crenuserinfromationid is null) and ( ES.EmployeeUserId = @crecuerinformationid or @crecuerinformationid is null ) and ( ES.EmployeeUserId  = @ssecuserinformationid or @ssecuserinformationid is null ) and ( ES.EmployeeUserId  = @creduserinfromationid  or @creduserinfromationid is null )  and (ES.EmployeeUserId = @sseduserinfromationid or @sseduserinfromationid is null )  
	
	if @counttable>0  

	begin 
	insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	   
 

	  if @workflowActionTypeId=1  

	   begin 
	     update #temp_1 set CanApprove=1  WHERE row_number_1 = @Counter
	   end

	end 

 end

if @workflowgrouplevelExit>0
--condition 3
  begin

    SET @counttable = 0

   Select @counttable = count(distinct userInfo.UserInformationId)   From vw_UserInformation userInfo 
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join UserEmployeeGroup UEG on  userInfo.UserInformationId=UEG.UserInformationId
	Inner Join EmployeeGroup EG on  EG.EmployeeGroupId=UEG.EmployeeGroupId
	Inner Join WorkflowLevelGroup WFG on  WFG.EmployeeGroupId= EG.EmployeeGroupId
	Where WFG.WorkflowLevelId = @WorkflowLevelId And userInfo.ClientId = @ClientId And UEG.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	and UCI.LoginEmail=@LoginEmail

	and (userInfo.id <> @etoruserinformationid or @etoruserinformationid is null) and (  userInfo.id <> @crauserinformationid or @crauserinformationid is null ) and( userInfo.id <> @crenuserinfromationid or @crenuserinfromationid is null) and( userInfo.id <> @crecuerinformationid or @crecuerinformationid is null )  and  ( userInfo.id <> @ssecuserinformationid or @ssecuserinformationid is null ) and (userInfo.id <> @creduserinfromationid  or @creduserinfromationid is null)   and (userInfo.id <>  @sseduserinfromationid  or @sseduserinfromationid is null )    


	if @counttable>0  

	begin 
	insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	  if @workflowActionTypeId=1  

	   begin 
	     update #temp_1 set CanApprove=1  WHERE row_number_1 = @Counter
	   end
	 

	end 

   end

  

   SET @Counter  = @Counter  + 1    
   

END


select

(SELECT cast(sub.row_num as int) as row_num
FROM (
  SELECT ROW_NUMBER() OVER ( PARTITION BY workflowtriggerrequestid ORDER BY workflowtriggerrequestdetailid ) AS row_num
      , WorkflowTriggerRequestDetailId
      FROM
      WorkflowTriggerRequestDetail
	  where WorkflowTriggerRequestId=t22.WorkflowTriggerRequestId
  ) sub
WHERE 
    sub.WorkflowTriggerRequestDetailId =t22.WorkflowTriggerRequestDetailId) as CurrentLevel,

case when t22.etoruserinfromationid is not null then 'Time-Off Request'  when  t22.crauserinformationid is not null then 'Address Change Request' when  t22.crenuserinfromationid is not null then 'Emails and Numbers' when  t22.crecuerinformationid is not null then 'Emergency Contact' when  t22.creduserinfromationid is not null then 'Employee Dependent'  when  t22.ssecuserinformationid is not null then 'Employee Credential' when t22.sseduserinfromationid is not null then 'Employee Document'  else '' end as RequestType,  
case when t22.etorid is not null then etorid  when  t22.craid is not null then craid when  t22.crenid is not null then crenid when  t22.crecid is not null then crecid when  t22.credid is not null then credid  when  t22.ssecid is not null then ssecid when t22.ssedid is not null then ssedid  else 0 end as ReferenceId
,case when t22.etorid is not null then '/EmployeeTimeOffRequest'  when  t22.craid is not null then 'ChangeRequestAddress' when  t22.crenid is not null then 'ChangeRequestEmailsAndNumber' when  t22.crecid is not null then 'ChangeRequestEmergencyContact' when  t22.credid is not null then 'ChangeRequestEmployeeDependent'  when  t22.ssecid is not null then 'ChangeRequestEmployeeCredential' when t22.ssedid is not null then 'ChangeRequestEmployeeDocument'  else '' end as ControllerName
,case when t22.etorid is not null then 'TimeOffRequest'  when  t22.craid is not null then 'MailingChangeRequestAddress' when  t22.crenid is not null then 'ChangeRequestEmailsAndNumbers' when  t22.crecid is not null then 'ChangeRequestEmergencyContact' when  t22.credid is not null then 'ChangeRequestEmployeeDependent'  when  t22.ssecid is not null then 'SelfServiceEmployeeCredential' when t22.ssedid is not null then 'SelfServiceEmployeeDocument'  else '' end as ActionName
,t22.ShortFullName,wfat.WorkflowActionTypeName,t22.WorkflowActionTypeId,t22.WorkflowTriggerTypeId,t22.EmployeeId,t22.TotalLevel,t22.CanApprove,t22.WorkflowTriggerRequestId,t22.WorkflowTriggerRequestDetailId,t22.CreatedDate,t22.ActionById,t22.ActionDate,uf.ShortFullName as ActionPersonShortFullName 
from #temp_1 t22 
left join (SELECT wftrd.WorkflowTriggerRequestId, wftrd.WorkflowTriggerRequestDetailId,wftrd.WorkflowActionTypeId,wfat.WorkflowActionTypeName,ROW_NUMBER() OVER (PARTITION BY workflowtriggerrequestid ORDER BY workflowtriggerrequestdetailid desc) AS row_no FROM WorkflowTriggerRequestDetail wftrd 
left join WorkflowActionType wfat on wftrd.WorkflowActionTypeId=wfat.WorkflowActionTypeId ) Prev on Prev.WorkflowTriggerRequestDetailId!=t22.WorkflowTriggerRequestDetailId and Prev.WorkflowTriggerRequestId=t22.WorkflowTriggerRequestId and Prev.row_no=2 
left join UserInformation uf on uf.UserInformationId=t22.ActionById left join WorkflowActionType wfat on t22.WorkflowActionTypeId=wfat.WorkflowActionTypeId where t22.WorkflowTriggerRequestDetailId in (select * from #FiltersId)





END
GO
