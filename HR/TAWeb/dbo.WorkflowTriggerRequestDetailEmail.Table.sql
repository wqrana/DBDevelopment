USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetailEmail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetailEmail](
	[WorkflowTriggerRequestDetailEmailId] [int] IDENTITY(1,1) NOT NULL,
	[SenderAddress] [nvarchar](max) NULL,
	[ToAddress] [nvarchar](max) NULL,
	[CcAddress] [nvarchar](max) NULL,
	[BccAddress] [nvarchar](max) NULL,
	[WorkflowTriggerRequestDetailId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequestDetailEmail] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestDetailEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetailEmail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetailEmail_dbo.WorkflowTriggerRequestDetail_WorkflowTriggerRequestDetailId] FOREIGN KEY([WorkflowTriggerRequestDetailId])
REFERENCES [dbo].[WorkflowTriggerRequestDetail] ([WorkflowTriggerRequestDetailId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetailEmail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetailEmail_dbo.WorkflowTriggerRequestDetail_WorkflowTriggerRequestDetailId]
GO
