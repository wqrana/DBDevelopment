USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeAction]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAction](
	[EmployeeActionId] [int] IDENTITY(1,1) NOT NULL,
	[ApprovedById] [int] NULL,
	[ActionTypeId] [int] NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionEndDate] [datetime] NULL,
	[ActionName] [nvarchar](max) NULL,
	[ActionDescription] [nvarchar](max) NULL,
	[ActionNotes] [nvarchar](max) NULL,
	[ActionExpiryDate] [datetime] NULL,
	[ActionClosingInfo] [nvarchar](max) NULL,
	[ActionApprovedDate] [datetime] NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAction] PRIMARY KEY CLUSTERED 
(
	[EmployeeActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAction_dbo.ActionType_ActionTypeId] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[EmployeeAction] CHECK CONSTRAINT [FK_dbo.EmployeeAction_dbo.ActionType_ActionTypeId]
GO
ALTER TABLE [dbo].[EmployeeAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAction_dbo.UserInformation_ApprovedById] FOREIGN KEY([ApprovedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeAction] CHECK CONSTRAINT [FK_dbo.EmployeeAction_dbo.UserInformation_ApprovedById]
GO
