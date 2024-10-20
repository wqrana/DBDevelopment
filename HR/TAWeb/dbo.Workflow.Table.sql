USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Workflow]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workflow](
	[WorkflowId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowName] [nvarchar](max) NOT NULL,
	[IsZeroLevel] [bit] NOT NULL,
	[WorkflowDescription] [nvarchar](max) NULL,
	[ClosingNotificationId] [int] NOT NULL,
	[ClosingNotificationMessageId] [int] NOT NULL,
	[ReminderNotificationMessageId] [int] NULL,
	[CancelNotificationMessageId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[WorkflowTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.Workflow] PRIMARY KEY CLUSTERED 
(
	[WorkflowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.ClosingNotificationType_ClosingNotificationId] FOREIGN KEY([ClosingNotificationId])
REFERENCES [dbo].[ClosingNotificationType] ([ClosingNotificationTypeId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.ClosingNotificationType_ClosingNotificationId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_CancelNotificationMessageId] FOREIGN KEY([CancelNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_CancelNotificationMessageId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ClosingNotificationMessageId] FOREIGN KEY([ClosingNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ClosingNotificationMessageId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ReminderNotificationMessageId] FOREIGN KEY([ReminderNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ReminderNotificationMessageId]
GO
