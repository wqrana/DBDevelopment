USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ReportCriteriaTemplate]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportCriteriaTemplate](
	[ReportCriteriaTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NULL,
	[ReportCriteriaTemplateName] [nvarchar](50) NOT NULL,
	[CriteriaType] [int] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[SuperviorId] [int] NULL,
	[EmployeeSelectionIds] [nvarchar](max) NULL,
	[DepartmentSelectionIds] [nvarchar](max) NULL,
	[SubDepartmentSelectionIds] [nvarchar](max) NULL,
	[EmployeeTypeSelectionIds] [nvarchar](max) NULL,
	[EmploymentTypeSelectionIds] [nvarchar](max) NULL,
	[PositionSelectionIds] [nvarchar](max) NULL,
	[StatusSelectionIds] [nvarchar](max) NULL,
	[DegreeSelectionIds] [nvarchar](max) NULL,
	[TrainingSelectionIds] [nvarchar](max) NULL,
	[CredentialSelectionIds] [nvarchar](max) NULL,
	[CustomFieldSelectionIds] [nvarchar](max) NULL,
	[BenefitSelectionIds] [nvarchar](max) NULL,
	[ActionTypeSelectionIds] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ReportCriteriaTemplate] PRIMARY KEY CLUSTERED 
(
	[ReportCriteriaTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
