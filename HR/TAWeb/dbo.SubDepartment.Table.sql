USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[SubDepartment]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubDepartment](
	[SubDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[SubDepartmentName] [nvarchar](50) NOT NULL,
	[SubDepartmentDescription] [nvarchar](200) NULL,
	[USECFSEAssignment] [bit] NOT NULL,
	[CFSECodeId] [int] NULL,
	[CFSECompanyPercent] [decimal](18, 5) NULL,
	[DepartmentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SubDepartment] PRIMARY KEY CLUSTERED 
(
	[SubDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.CFSECode_CFSECodeId] FOREIGN KEY([CFSECodeId])
REFERENCES [dbo].[CFSECode] ([CFSECodeId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.CFSECode_CFSECodeId]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.Department_DepartmentId]
GO
