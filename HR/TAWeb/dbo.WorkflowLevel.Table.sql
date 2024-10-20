USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowLevel]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowLevel](
	[WorkflowLevelId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowLevelName] [nvarchar](max) NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[WorkflowLevelTypeId] [int] NOT NULL,
	[NotificationMessageId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowLevel] PRIMARY KEY CLUSTERED 
(
	[WorkflowLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.NotificationMessage_NotificationMessageId] FOREIGN KEY([NotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.NotificationMessage_NotificationMessageId]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.Workflow_WorkflowId]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.WorkflowLevelType_WorkflowLevelTypeId] FOREIGN KEY([WorkflowLevelTypeId])
REFERENCES [dbo].[WorkflowLevelType] ([WorkflowLevelTypeId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.WorkflowLevelType_WorkflowLevelTypeId]
GO
