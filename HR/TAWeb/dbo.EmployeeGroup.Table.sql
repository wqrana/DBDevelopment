USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeGroup]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeGroup](
	[EmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupName] [nvarchar](150) NOT NULL,
	[EmployeeGroupDescription] [nvarchar](150) NULL,
	[EmployeeGroupTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[EmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeGroup_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[EmployeeGroup] CHECK CONSTRAINT [FK_dbo.EmployeeGroup_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[EmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeGroup_dbo.EmployeeGroupType_EmployeeGroupTypeId] FOREIGN KEY([EmployeeGroupTypeId])
REFERENCES [dbo].[EmployeeGroupType] ([EmployeeGroupTypeId])
GO
ALTER TABLE [dbo].[EmployeeGroup] CHECK CONSTRAINT [FK_dbo.EmployeeGroup_dbo.EmployeeGroupType_EmployeeGroupTypeId]
GO
