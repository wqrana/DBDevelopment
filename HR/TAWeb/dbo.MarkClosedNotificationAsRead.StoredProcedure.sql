USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[MarkClosedNotificationAsRead]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MarkClosedNotificationAsRead]  
	@LoginEmail as nvarchar(100),
	@ChangeRequestStatusId int=2


As
Begin

   declare
@userinformationid int ,
@clientid int,
@loginuserid int,
@unread  bit=1

	select @userinformationid=uc.UserInformationId,@clientid=uc.ClientId ,@loginuserid=uc.UserInformationId from UserContactInformation uc where uc.LoginEmail=@LoginEmail

   
   IF OBJECT_ID('tempdb..#temp_1') IS NOT NULL
    DROP TABLE #temp_1

	IF OBJECT_ID('tempdb..#temp_2') IS NOT NULL
    DROP TABLE #temp_2

	IF OBJECT_ID('tempdb..#temp_3') IS NOT NULL
    DROP TABLE #temp_3

	IF OBJECT_ID('tempdb..#FiltersId') IS NOT NULL
    DROP TABLE #FiltersId

	IF OBJECT_ID('tempdb..#ReadId') IS NOT NULL
    DROP TABLE #ReadId





SELECT * into #temp_1
FROM (
 SELECT 
     *,
    ROW_NUMBER() OVER (PARTITION BY workflowtriggerrequestid 
     ORDER BY workflowtriggerrequestdetailid desc) AS row_number 
 FROM WorkflowTriggerRequestDetail where ClientId=@ClientId
) t   where row_number=1


select *, ROW_NUMBER() OVER (
     ORDER BY workflowtriggerrequestdetailid desc) AS row_number_2  into #temp_2 from(
select uf.ShortFullName, t.WorkflowTriggerRequestDetailId,t.WorkflowLevelId,t.WorkflowActionTypeId,t.WorkflowTriggerRequestId,wl.WorkflowLevelName as WorkFlowlevelExist,w.ClosingNotificationId,w.IsZeroLevel,wfl.WorkflowLevelTypeId,wfg.WorkflowLevelId as workflowgrouplevelexistid,


etor.EmployeeTimeOffRequestId as etorid,cra.ChangeRequestAddressId as craid,cren.ChangeRequestEmailNumbersId as crenid,crec.ChangeRequestEmergencyContactId as crecid,cred.ChangeRequestEmployeeDependentId as credid,ssec.SelfServiceEmployeeCredentialId as ssecid
 ,ssed.SelfServiceEmployeeDocumentId as ssedid

,etor.UserInformationId as etoruserinfromationid,cra.UserInformationId as crauserinformationid
 ,cren.UserInformationId as crenuserinfromationid,crec.UserInformationId as crecuerinformationid,cred.UserInformationId as creduserinfromationid,ssec.UserInformationId as ssecuserinformationid
   ,ssed.UserInformationId as sseduserinfromationid ,

    wft.CreatedDate
   
   
   
   from #temp_1 t left join WorkflowTriggerRequest wft on wft.WorkflowTriggerRequestId=t.WorkflowTriggerRequestId 
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
 (etor.ChangeRequestStatusId>=@ChangeRequestStatusId or etor.ChangeRequestStatusId is null)
and (cra.ChangeRequestStatusId>=@ChangeRequestStatusId or cra.ChangeRequestStatusId is null)
and (cren.ChangeRequestStatusId>=@ChangeRequestStatusId or cren.ChangeRequestStatusId is null)
and (crec.ChangeRequestStatusId>=@ChangeRequestStatusId or crec.ChangeRequestStatusId is null)
and (cred.ChangeRequestStatusId>=@ChangeRequestStatusId or cred.ChangeRequestStatusId is null)
and (ssec.ChangeRequestStatusId>=@ChangeRequestStatusId or ssec.ChangeRequestStatusId is null)
and (ssed.ChangeRequestStatusId>=@ChangeRequestStatusId or ssed.ChangeRequestStatusId is null)


)t22




 
DECLARE @Counter INT , @MaxId INT, 
        @CountryName NVARCHAR(100),
		@WorkflowLevelId int =0 ,
		@WorkflowTriggerRequestDetailId int =0 ,
		@IsZeroLevel as bit =0,	
		@ClosingNotificationId as int =0,
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

SELECT @Counter = min(row_number_2) , @MaxId = max(row_number_2) 
FROM #temp_2



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
		@IsZeroLevel=IsZeroLevel,
		@ClosingNotificationId=ClosingNotificationId,
		@workflowActionTypeId=WorkflowActionTypeId,
		@WorkFlowlevelExist=WorkFlowlevelExist
   FROM #temp_2 WHERE row_number_2 = @Counter

   --select @etoruserinformationid,@crauserinformationid,@crenuserinfromationid,@crecuerinformationid,@ssecuserinformationid,@creduserinfromationid,@sseduserinfromationid

if(@workflowActionTypeId <> 6 or @WorkFlowlevelExist = null)
--condition 1
begin
 SET @Counter  = @Counter  + 1 
 SET @condition1  = @condition1  + 1  
 continue  
end


 if @IsZeroLevel=1

     begin 
	  SET @condition2  = @condition2  + 1  
   --Condition 2 
  
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
	 SET @condition2  = @condition2  + 1  
	end 

	 

 end

 --condition 3
 else if @ClosingNotificationId=1

   
   begin
   SET @condition3  = @condition3  + 1  
     if ((@etoruserinformationid =@LoginUserId or @etoruserinformationid is null) and ( @crauserinformationid =@LoginUserId or @crauserinformationid is null ) and ( @crenuserinfromationid =@LoginUserId or @crenuserinfromationid is null  ) and ( @crecuerinformationid =@LoginUserId or @crecuerinformationid is null ) and  ( @ssecuserinformationid =@LoginUserId or @ssecuserinformationid is null) and (  @creduserinfromationid =@LoginUserId or @creduserinfromationid is null) and ( @sseduserinfromationid=@LoginUserId or @sseduserinfromationid is null) )

     begin

	    insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	      SET @condition3  = @condition3  + 1  
	 end 
   
  
 end 


 else if @ClosingNotificationId=2

   begin
    SET @condition4  = @condition4  + 1  
  --Condition 4 

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
	   SET @condition4  = @condition4  + 1  
	end 

	if ((@etoruserinformationid =@LoginUserId or @etoruserinformationid is null) and ( @crauserinformationid =@LoginUserId or @crauserinformationid is null ) and ( @crenuserinfromationid =@LoginUserId or @crenuserinfromationid is null  ) and ( @crecuerinformationid =@LoginUserId or @crecuerinformationid is null ) and  ( @ssecuserinformationid =@LoginUserId or @ssecuserinformationid is null) and (  @creduserinfromationid =@LoginUserId or @creduserinfromationid is null) and ( @sseduserinfromationid=@LoginUserId or @sseduserinfromationid is null) )

     begin

	    insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	       SET @condition4  = @condition4  + 1  
	 end 

	 
 end


 else if @ClosingNotificationId=3
 --condition 5
   begin

   SET @condition5  = @condition5  + 1  
   SET @counttable = 0
   SET @counttable2=0

      Select @counttable = count(distinct userInfo.Id)   From vw_UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join EmployeeSupervisor ES on ES.SupervisorUserId = userInfo.UserInformationId
	Where  userInfo.ClientId = @ClientId And ES.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	and UCI.LoginEmail=@LoginEmail
	and (userInfo.Id <> @etoruserinformationid or @etoruserinformationid is null) and (  userInfo.id <> @crauserinformationid or @crauserinformationid is null ) and( userInfo.id <> @crenuserinfromationid or @crenuserinfromationid is null) and( userInfo.id <> @crecuerinformationid or @crecuerinformationid is null )  and  ( userInfo.id <> @ssecuserinformationid or @ssecuserinformationid is null ) and (userInfo.id <> @creduserinfromationid  or @creduserinfromationid is null)   and (userInfo.id <>  @sseduserinfromationid  or @sseduserinfromationid is null )    
	and (ES.EmployeeUserId = @etoruserinformationid or @etoruserinformationid is null) and ( ES.EmployeeUserId  = @crauserinformationid or @crauserinformationid is null ) and (ES.EmployeeUserId  = @crenuserinfromationid or @crenuserinfromationid is null) and ( ES.EmployeeUserId = @crecuerinformationid or @crecuerinformationid is null ) and ( ES.EmployeeUserId  = @ssecuserinformationid or @ssecuserinformationid is null ) and ( ES.EmployeeUserId  = @creduserinfromationid  or @creduserinfromationid is null )  and (ES.EmployeeUserId = @sseduserinfromationid or @sseduserinfromationid is null )  
	
	if @counttable>0  

	begin 
	--select @WorkflowTriggerRequestDetailId,@counttable as fetching_Rows_count ,@etoruserinformationid,@crauserinformationid,@crenuserinfromationid,@crecuerinformationid,@ssecuserinformationid,@creduserinfromationid,@sseduserinfromationid
	insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	   SET @condition5_1  = @condition5_1  + 1  
	end 



   Select @counttable2 = count(distinct userInfo.UserInformationId)   From vw_UserInformation userInfo 
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join UserEmployeeGroup UEG on  userInfo.UserInformationId=UEG.UserInformationId
	Inner Join EmployeeGroup EG on  EG.EmployeeGroupId=UEG.EmployeeGroupId
	Inner Join WorkflowLevelGroup WFG on  WFG.EmployeeGroupId= EG.EmployeeGroupId
	Where WFG.WorkflowLevelId = @WorkflowLevelId And userInfo.ClientId = @ClientId And UEG.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	and UCI.LoginEmail=@LoginEmail
	and (userInfo.id <> @etoruserinformationid or @etoruserinformationid is null) and (  userInfo.id <> @crauserinformationid or @crauserinformationid is null ) and( userInfo.id <> @crenuserinfromationid or @crenuserinfromationid is null) and( userInfo.id <> @crecuerinformationid or @crecuerinformationid is null )  and  ( userInfo.id <> @ssecuserinformationid or @ssecuserinformationid is null ) and (userInfo.id <> @creduserinfromationid  or @creduserinfromationid is null)   and (userInfo.id <>  @sseduserinfromationid  or @sseduserinfromationid is null )    



	if @counttable2>0  

	begin 
	insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	   SET @condition5_2  = @condition5_2  + 1  
	end 

	if ((@etoruserinformationid =@LoginUserId or @etoruserinformationid is null) and ( @crauserinformationid =@LoginUserId or @crauserinformationid is null ) and ( @crenuserinfromationid =@LoginUserId or @crenuserinfromationid is null  ) and ( @crecuerinformationid =@LoginUserId or @crecuerinformationid is null ) and  ( @ssecuserinformationid =@LoginUserId or @ssecuserinformationid is null) and (  @creduserinfromationid =@LoginUserId or @creduserinfromationid is null) and ( @sseduserinfromationid=@LoginUserId or @sseduserinfromationid is null) )

     begin

	    insert into #FiltersId values (@WorkflowTriggerRequestDetailId)
	      SET @condition5_3  = @condition5_3  + 1   
	 end 


  

end 

  
   SET @Counter  = @Counter  + 1  
          

END

select * into #temp_3 from (select * from #temp_2 where WorkflowTriggerRequestDetailId in (select * from #FiltersId)) t3

select * into #ReadId from  ( select t3.WorkflowTriggerRequestDetailId from #temp_3 t3 left join NotificationLogMessageReadBy nlm on t3.WorkflowTriggerRequestId=nlm.WorkflowTriggerRequestId  where nlm.ReadById=@LoginUserId ) ReadId

 select *, ROW_NUMBER() OVER (
     ORDER BY CreatedDate desc) AS row_number_3  into #temp_4 from(   select case when t3.etoruserinfromationid is not null then 'Time-Off Request'  when  t3.crauserinformationid is not null then 'Address Change Request' when  t3.crenuserinfromationid is not null then 'Emails and Numbers' when  t3.crecuerinformationid is not null then 'Emergency Contact' when  t3.creduserinfromationid is not null then 'Employee Dependent'  when  t3.ssecuserinformationid is not null then 'Employee Credential' when t3.sseduserinfromationid is not null then 'Employee Document'  else '' end as RequestType,  
   case when t3.etorid is not null then etorid  when  t3.craid is not null then craid when  t3.crenid is not null then crenid when  t3.crecid is not null then crecid when  t3.credid is not null then credid  when  t3.ssecid is not null then ssecid when t3.ssedid is not null then ssedid  else 0 end as ReferenceId
   ,case when t3.etorid is not null then '/EmployeeTimeOffRequest'  when  t3.craid is not null then 'ChangeRequestAddress' when  t3.crenid is not null then 'ChangeRequestEmailsAndNumber' when  t3.crecid is not null then 'ChangeRequestEmergencyContact' when  t3.credid is not null then 'ChangeRequestEmployeeDependent'  when  t3.ssecid is not null then 'ChangeRequestEmployeeCredential' when t3.ssedid is not null then 'ChangeRequestEmployeeDocument'  else '' end as ControllerName
  ,case when t3.etorid is not null then 'TimeOffRequest'  when  t3.craid is not null then 'MailingChangeRequestAddress' when  t3.crenid is not null then 'ChangeRequestEmailsAndNumbers' when  t3.crecid is not null then 'ChangeRequestEmergencyContact' when  t3.credid is not null then 'ChangeRequestEmployeeDependent'  when  t3.ssecid is not null then 'SelfServiceEmployeeCredential' when t3.ssedid is not null then 'SelfServiceEmployeeDocument'  else '' end as ActionName
  ,'' as ActionType,t3.ShortFullName ,t3.WorkflowTriggerRequestId,t3.WorkflowTriggerRequestDetailId,t3.CreatedDate  from #temp_3 t3 where (WorkflowTriggerRequestDetailId not in (select * from #ReadId)) or @unread<>1 )t4



   
  SELECT @Counter = min(row_number_3) , @MaxId = max(row_number_3) 
FROM #temp_4


while (@Counter is not null and @counter <=@MaxId)

Begin



    SELECT @workflowTriggerRequestId=WorkflowTriggerRequestId,@WorkflowTriggerRequestDetailId=WorkflowTriggerRequestDetailId
   FROM #temp_4 WHERE row_number_3 = @Counter


 
   Select top 1 @ActionType = case when WorkflowActionTypeId=2 then 'A' when WorkflowActionTypeId=3 then 'D' when WorkflowActionTypeId=4 then 'C' else '' end  From WorkflowTriggerRequestDetail
   where WorkflowTriggerRequestId=@workflowTriggerRequestId and WorkflowTriggerRequestDetailId<>@WorkflowTriggerRequestDetailId
   order by WorkflowTriggerRequestDetailId desc
   

	if @ActionType is not null  

	begin 

	  Update #temp_4 set ActionType = @ActionType where row_number_3=@Counter
	  
	end

	 SET @Counter  = @Counter  + 1  

End 

  
	insert into NotificationLogMessageReadBy (NotificationLogId,WorkflowTriggerRequestId,ReadById,CompanyId,ClientId,CreatedBy,CreatedDate,DataEntryStatus,ModifiedBy,ModifiedDate,Old_Id) select null as NotificationLogId,WorkflowTriggerRequestId as WorkflowTriggerRequestId,@LoginUserId as ReadById,7 as CompanyId,@ClientId as ClientId,@LoginUserId as CreatedBy,GetDate() as CreatedDate,1 as DataEntryStatus,null as ModifiedBy,null as ModifiedDate,null as Old_Id  from #temp_4 
     select * from #temp_4

END


	


GO
