USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeAppraisal]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisal](
	[EmployeeAppraisalId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[SubDepartmentId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalReviewDate] [datetime] NULL,
	[AppraisalDueDate] [datetime] NULL,
	[EvaluationStartDate] [datetime] NULL,
	[EvaluationEndDate] [datetime] NULL,
	[NextAppraisalDueDate] [datetime] NULL,
	[AppraisalResultId] [int] NULL,
	[AppraisalOverallScore] [decimal](18, 2) NULL,
	[AppraisalTotalMaxValue] [decimal](18, 2) NULL,
	[AppraisalOverallPct] [decimal](18, 2) NULL,
	[AppraisalReviewerComments] [nvarchar](max) NULL,
	[AppraisalEmployeeComments] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisal] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalResult_AppraisalResultId] FOREIGN KEY([AppraisalResultId])
REFERENCES [dbo].[AppraisalResult] ([AppraisalResultId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalResult_AppraisalResultId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.SubDepartment_SubDepartmentId]
GO
