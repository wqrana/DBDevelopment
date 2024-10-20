USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetail](
	[WorkflowTriggerRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[ActionRemarks] [nvarchar](max) NULL,
	[WorkflowLevelId] [int] NULL,
	[WorkflowTriggerRequestId] [int] NOT NULL,
	[WorkflowActionTypeId] [int] NOT NULL,
	[ActionById] [int] NULL,
	[ActionDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequestDetail] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.UserInformation_ActionById] FOREIGN KEY([ActionById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.UserInformation_ActionById]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowActionType_WorkflowActionTypeId] FOREIGN KEY([WorkflowActionTypeId])
REFERENCES [dbo].[WorkflowActionType] ([WorkflowActionTypeId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowActionType_WorkflowActionTypeId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowLevel_WorkflowLevelId] FOREIGN KEY([WorkflowLevelId])
REFERENCES [dbo].[WorkflowLevel] ([WorkflowLevelId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowLevel_WorkflowLevelId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowTriggerRequest_WorkflowTriggerRequestId] FOREIGN KEY([WorkflowTriggerRequestId])
REFERENCES [dbo].[WorkflowTriggerRequest] ([WorkflowTriggerRequestId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowTriggerRequest_WorkflowTriggerRequestId]
GO
