USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[NotificationLogMessageReadBy]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationLogMessageReadBy](
	[NotificationLogMessageReadById] [int] IDENTITY(1,1) NOT NULL,
	[NotificationLogId] [int] NULL,
	[ReadById] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[WorkflowTriggerRequestId] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationLogMessageReadBy] PRIMARY KEY CLUSTERED 
(
	[NotificationLogMessageReadById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.NotificationLog_NotificationLogId] FOREIGN KEY([NotificationLogId])
REFERENCES [dbo].[NotificationLog] ([NotificationLogId])
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy] CHECK CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.NotificationLog_NotificationLogId]
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.UserInformation_ReadById] FOREIGN KEY([ReadById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy] CHECK CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.UserInformation_ReadById]
GO
