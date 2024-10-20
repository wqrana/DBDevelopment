USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowTrigger]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTrigger](
	[WorkflowTriggerId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTriggerName] [nvarchar](max) NULL,
	[WorkflowTriggerDescription] [nvarchar](max) NULL,
	[WorkflowId] [int] NOT NULL,
	[WorkflowTriggerTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTrigger] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowTrigger]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowId])
GO
ALTER TABLE [dbo].[WorkflowTrigger] CHECK CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.Workflow_WorkflowId]
GO
ALTER TABLE [dbo].[WorkflowTrigger]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.WorkflowTriggerType_WorkflowTriggerTypeId] FOREIGN KEY([WorkflowTriggerTypeId])
REFERENCES [dbo].[WorkflowTriggerType] ([WorkflowTriggerTypeId])
GO
ALTER TABLE [dbo].[WorkflowTrigger] CHECK CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.WorkflowTriggerType_WorkflowTriggerTypeId]
GO
