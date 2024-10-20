USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](50) NOT NULL,
	[DepartmentDescription] [nvarchar](200) NULL,
	[USECFSEAssignment] [bit] NOT NULL,
	[CFSECodeId] [int] NULL,
	[CFSECompanyPercent] [decimal](18, 5) NULL,
	[JobCertificationSigneeId] [int] NULL,
	[JobCertificationTemplateId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.CFSECode_CFSECodeId] FOREIGN KEY([CFSECodeId])
REFERENCES [dbo].[CFSECode] ([CFSECodeId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.CFSECode_CFSECodeId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.JobCertificationSignee_JobCertificationSigneeId] FOREIGN KEY([JobCertificationSigneeId])
REFERENCES [dbo].[JobCertificationSignee] ([JobCertificationSigneeId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.JobCertificationSignee_JobCertificationSigneeId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.JobCertificationTemplate_JobCertificationTemplateId] FOREIGN KEY([JobCertificationTemplateId])
REFERENCES [dbo].[JobCertificationTemplate] ([JobCertificationTemplateId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.JobCertificationTemplate_JobCertificationTemplateId]
GO
