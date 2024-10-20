USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblWithholdingsItems_PRPayExport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWithholdingsItems_PRPayExport](
	[strWithholdingsName] [nvarchar](50) NOT NULL,
	[boolCustom_deduction_1] [bit] NOT NULL,
	[boolCustom_deduction_2] [bit] NOT NULL,
	[boolCustom_deduction_3] [bit] NOT NULL,
	[boolCustom_deduction_4] [bit] NOT NULL,
	[boolCustom_deduction_5] [bit] NOT NULL,
	[boolWithholding] [bit] NOT NULL,
	[boolFICA] [bit] NOT NULL,
	[boolSocialSecurity] [bit] NOT NULL,
	[boolMedicare] [bit] NOT NULL,
	[boolDisability] [bit] NOT NULL,
	[boolChauffeur_Insurance] [bit] NOT NULL,
	[boolOther_Deductions] [bit] NOT NULL,
	[boolHealth_CoverageContribution] [bit] NOT NULL,
	[boolCharitable_Contribution] [bit] NOT NULL,
	[boolMoney_Savings] [bit] NOT NULL,
	[boolMedicare_Plus] [bit] NOT NULL,
	[boolCoda_401K] [bit] NOT NULL,
	[boolCoda_ExemptSalary] [bit] NOT NULL,
	[boolMedicalInsurance] [bit] NOT NULL,
 CONSTRAINT [PK_tblWithholdingsItems_PRPayExport] PRIMARY KEY CLUSTERED 
(
	[strWithholdingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblWithholdingsItems_PRPayExport] ADD  DEFAULT ((0)) FOR [boolCoda_401K]
GO
ALTER TABLE [dbo].[tblWithholdingsItems_PRPayExport] ADD  DEFAULT ((0)) FOR [boolCoda_ExemptSalary]
GO
ALTER TABLE [dbo].[tblWithholdingsItems_PRPayExport] ADD  DEFAULT ((0)) FOR [boolMedicalInsurance]
GO
