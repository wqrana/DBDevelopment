USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyWithholdingPRPayExport]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingPRPayExport](
	[CompanyWithholdingPRPayExportId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[CustomDeduction1] [bit] NOT NULL,
	[CustomDeduction2] [bit] NOT NULL,
	[CustomDeduction3] [bit] NOT NULL,
	[CustomDeduction4] [bit] NOT NULL,
	[CustomDeduction5] [bit] NOT NULL,
	[IsWithholding] [bit] NOT NULL,
	[IsFICA] [bit] NOT NULL,
	[IsSocialSecurity] [bit] NOT NULL,
	[IsMedicare] [bit] NOT NULL,
	[IsDisability] [bit] NOT NULL,
	[IsChauffeurInsurance] [bit] NOT NULL,
	[IsOtherDeduction] [bit] NOT NULL,
	[IsHealthCoverageContribution] [bit] NOT NULL,
	[Charitable_Contribution] [bit] NOT NULL,
	[IsMoneySaving] [bit] NOT NULL,
	[IsMedicarePlus] [bit] NOT NULL,
	[IsCoda401K] [bit] NOT NULL,
	[IsCodaExemptSalary] [bit] NOT NULL,
	[IsMedicalInsurance] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingPRPayExport] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingPRPayExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyWithholdingPRPayExport]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholdingPRPayExport_dbo.CompanyWithholding_CompanyWithholdingPRPayExportId] FOREIGN KEY([CompanyWithholdingPRPayExportId])
REFERENCES [dbo].[CompanyWithholding] ([CompanyWithholdingId])
GO
ALTER TABLE [dbo].[CompanyWithholdingPRPayExport] CHECK CONSTRAINT [FK_dbo.CompanyWithholdingPRPayExport_dbo.CompanyWithholding_CompanyWithholdingPRPayExportId]
GO
