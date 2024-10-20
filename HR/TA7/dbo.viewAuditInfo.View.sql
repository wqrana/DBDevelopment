USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewAuditInfo]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAuditInfo]
AS

SELECT (1000000 + ai.[ID] )ID
      ,[DTTimeStamp]
      ,[nAdminID] as [nAdminID]
      ,[sAdminName] as [sAdminName]
      ,[sAdminAction] as [sAdminAction]
      ,[sRecordAffected] as [sRecordAffected]
      ,[nUserIDAffected] as [nUserIDAffected]
      ,[sUserNameAffected] as [sUserNameAffected]
      ,[sFieldName] as [sFieldName]
	  ,'' as [strFieldDesc]
      ,[PrevValue] as [PrevValue]
      ,[NewValue]as [NewValue]
      ,isnull([nWeekID],0) nWeekID
	  ,'' as [strBatchID] 
	  ,nCompanyID 
	  ,'tAuditInfo' as Source
  FROM [dbo].[tAuditInfo] ai inner join tuser u on ai.nUserIDAffected = u.id
UNION ALL
SELECT pai.[ID]
      ,[DTTimeStamp]
      ,[intAdminID] [nAdminID]
      ,[strAdminName] [sAdminName]
      ,[strAdminAction] [sAdminAction]
      ,[strRecordAffected] [sRecordAffected]
      ,[intUserID] [nUserIDAffected]
      ,[strUserName] [sUserNameAffected]
      ,[strFieldName] [sFieldName]
      ,[strFieldDesc]
      ,[strPrevValue] [PrevValue]
      ,[strNewValue] [NewValue]
      ,0 as [nWeekID]
	  ,[strBatchID]
	  ,nCompanyID 
	  ,'tblPayrollAuditInfo' as Source
  FROM [dbo].[tblPayrollAuditInfo] pai inner join tuser u on pai.intUserID = u.id
GO
