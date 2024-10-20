USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vNotificationScheduleDetail]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vNotificationScheduleDetail]
AS
SELECT        [NotificationScheduleDetailId], [NotificationScheduleId], [DaysBefore], LAG([DaysBefore], 1, 0) OVER (PARTITION BY [NotificationScheduleId]
ORDER BY [DaysBefore]) AS PreviousDaysBefore, [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate], [ClientId], [NotificationMessageId]
FROM            [NotificationScheduleDetail]
GO
