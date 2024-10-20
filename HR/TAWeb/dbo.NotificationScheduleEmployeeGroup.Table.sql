USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[NotificationScheduleEmployeeGroup]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationScheduleEmployeeGroup](
	[NotificationScheduleEmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationScheduleDetailId] [int] NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationScheduleEmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[NotificationScheduleEmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup] CHECK CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId]
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.NotificationScheduleDetail_NotificationScheduleDetailId] FOREIGN KEY([NotificationScheduleDetailId])
REFERENCES [dbo].[NotificationScheduleDetail] ([NotificationScheduleDetailId])
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup] CHECK CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.NotificationScheduleDetail_NotificationScheduleDetailId]
GO
