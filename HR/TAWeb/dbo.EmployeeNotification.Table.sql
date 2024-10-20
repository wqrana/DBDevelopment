USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeNotification]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeNotification](
	[EmployeeNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNotificationName] [nvarchar](150) NOT NULL,
	[EmployeeNotificationDescription] [nvarchar](150) NULL,
	[EmployeeNotificationTypeId] [int] NOT NULL,
	[NotificationScheduleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeNotification] PRIMARY KEY CLUSTERED 
(
	[EmployeeNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeNotification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeNotification_dbo.EmployeeNotificationType_EmployeeNotificationTypeId] FOREIGN KEY([EmployeeNotificationTypeId])
REFERENCES [dbo].[EmployeeNotificationType] ([EmployeeNotificationTypeId])
GO
ALTER TABLE [dbo].[EmployeeNotification] CHECK CONSTRAINT [FK_dbo.EmployeeNotification_dbo.EmployeeNotificationType_EmployeeNotificationTypeId]
GO
ALTER TABLE [dbo].[EmployeeNotification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeNotification_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[EmployeeNotification] CHECK CONSTRAINT [FK_dbo.EmployeeNotification_dbo.NotificationSchedule_NotificationScheduleId]
GO
