USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowLevelGroup]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowLevelGroup](
	[WorkflowLevelGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[WorkflowLevelId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowLevelGroup] PRIMARY KEY CLUSTERED 
(
	[WorkflowLevelGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowLevelGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.EmployeeGroup_EmployeeGroupId] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[WorkflowLevelGroup] CHECK CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.EmployeeGroup_EmployeeGroupId]
GO
ALTER TABLE [dbo].[WorkflowLevelGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.WorkflowLevel_WorkflowLevelId] FOREIGN KEY([WorkflowLevelId])
REFERENCES [dbo].[WorkflowLevel] ([WorkflowLevelId])
GO
ALTER TABLE [dbo].[WorkflowLevelGroup] CHECK CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.WorkflowLevel_WorkflowLevelId]
GO
