USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NotificationItemsSchedule]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/9/2020
-- Description:	Returns all Notification Items and their status
--				for ClientID and Dates
-- =============================================
CREATE FUNCTION [dbo].[fn_NotificationItemsSchedule]
(
	@ClientID int,
	@NotificationFromDate date,
	@NotificationToDate date
)
RETURNS 
	@NotificationItemsSchedule TABLE 
(
				NotificationScheduleDetailId int 
			   ,EmployeeDocumentId int
			   ,UserInformationId int 
			   ,ShortFullName nvarchar(50)
			   ,DocumentName nvarchar(500)
			   ,DocumentNote nvarchar(250)
			   ,ExpirationDate date
			   ,NotificationDate date
			   ,IsExpired bit
			   ,[EmployeeCredentialId] int
			   ,[EmployeeCustomFieldId] int 
			   ,[DeliveryStatusId] int
			   ,[ClientId] int
			   ,ClientName nvarchar(50)
			   ,[CompanyId] int
			   ,CompanyName nvarchar(50)
			   ,NotificationType int
)
AS
BEGIN
		-- DOCUMENTS WITH EXPIRATION DATES
		INSERT INTO @NotificationItemsSchedule
	select	
			    nsl.[NotificationScheduleDetailId]
			   ,ed.[EmployeeDocumentId]
			   ,ui.UserInformationId
			   ,ui.ShortFullName
			   ,d.DocumentName
			   ,ed.DocumentNote
			   ,ed.ExpirationDate
			   ,DATEADD(DAY,-nsl.DaysBefore,ed.ExpirationDate) NotificationDate
			   ,iif(ed.ExpirationDate >= CAST(getdate() AS DATE) ,0,1) IsExpired
			   ,NULL as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,0 as [DeliveryStatusId]
			   ,ui.[ClientId]
			   ,cl.ClientName
			   ,ui.[CompanyId]
			   ,c.CompanyName
			   ,1 --Documents = 1
	FROM
	EmployeeDocument ed inner join UserInformation ui on ed.UserInformationId = ui.UserInformationId
	inner join Client cl on ui.ClientId = cl.ClientId
	inner join Company c on ui.CompanyID = c.CompanyId
	inner join Document d on ed.DocumentId = d.DocumentId
	inner join dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	inner join dbo.NotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	left outer join dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId
	and nl.EmployeeDocumentId = ed.EmployeeDocumentId
	and DATEADD(DAY,-nsl.DaysBefore,ed.ExpirationDate) BETWEEN @NotificationFromDate and @NotificationToDate
	and ui.ClientId = @ClientID

	RETURN 
END




GO
