USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_NotificationItemsCalendar]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/9/2020
-- Description:	Returns all Notification Items and their status
--				for ClientID and Dates
--				IsNotified: A notification was sent
--				IsExpired: The item has expired
-- =============================================
CREATE FUNCTION [dbo].[fn_NotificationItemsCalendar]
(
	@ClientID int,
	@NotificationFromDate date,
	@NotificationToDate date
)
RETURNS 
	@NotificationItemsSchedule TABLE 
(
			   EmployeeDocumentId int
			   ,UserInformationId int 
			   ,ShortFullName nvarchar(50)
			   ,DocumentName nvarchar(500)
			   ,DocumentNote nvarchar(250)
			   ,ExpirationDate date
			   ,ExpirationMonth int
			   ,ExpirationYear int
			   ,IsNotified bit
			   ,IsExpired bit
			   ,[EmployeeCredentialId] int
			   ,[EmployeeCustomFieldId] int 
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
			   ed.[EmployeeDocumentId]
			   ,ui.UserInformationId
			   ,ui.ShortFullName
			   ,d.DocumentName
			   ,ed.DocumentNote
			   ,ed.ExpirationDate
   				,MONTH(ed.ExpirationDate) TheMonth
				,YEAR (ed.ExpirationDate) TheYear
			   ,iif((select top(1) NotificationLogId from NotificationLog nl where nl.EmployeeDocumentId = ed.EmployeeDocumentId ) IS NULL,0,1) IsNotified
			   ,iif(ed.ExpirationDate >= CAST(getdate() AS DATE) ,0,1) IsExpired
			   ,NULL as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,ui.[ClientId]
			   ,cl.ClientName
			   ,ui.[CompanyId]
			   ,c.CompanyName
			   ,1 --Documents = 1
	FROM
	EmployeeDocument ed 
	inner join UserInformation ui on ed.UserInformationId = ui.UserInformationId
	inner join Client cl on ui.ClientId = cl.ClientId
	inner join Company c on ui.CompanyID = c.CompanyId
	inner join Document d on ed.DocumentId = d.DocumentId
	RETURN 
END


GO
