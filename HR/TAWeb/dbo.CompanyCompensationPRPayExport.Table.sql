USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyCompensationPRPayExport]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyCompensationPRPayExport](
	[CompanyCompensationPRPayExportId] [int] NOT NULL,
	[CompanyCompensationId] [int] NULL,
	[CustomIncome1] [bit] NOT NULL,
	[CustomIncome2] [bit] NOT NULL,
	[CustomIncome3] [bit] NOT NULL,
	[CustomIncome4] [bit] NOT NULL,
	[CustomIncome5] [bit] NOT NULL,
	[NonTaxable1] [bit] NOT NULL,
	[NonTaxable2] [bit] NOT NULL,
	[NonTaxable3] [bit] NOT NULL,
	[NonTaxable4] [bit] NOT NULL,
	[NonTaxable5] [bit] NOT NULL,
	[Wages] [bit] NOT NULL,
	[Commissions] [bit] NOT NULL,
	[Allowances] [bit] NOT NULL,
	[Tips] [bit] NOT NULL,
	[Income401K] [bit] NOT NULL,
	[OtherRetirement] [bit] NOT NULL,
	[Cafeteria] [bit] NOT NULL,
	[Reimbursements] [bit] NOT NULL,
	[CODA401K] [bit] NOT NULL,
	[ExemptSalaries] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyCompensationPRPayExport] PRIMARY KEY CLUSTERED 
(
	[CompanyCompensationPRPayExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensationPRPayExport_dbo.CompanyCompensation_CompanyCompensationPRPayExportId] FOREIGN KEY([CompanyCompensationPRPayExportId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport] CHECK CONSTRAINT [FK_dbo.CompanyCompensationPRPayExport_dbo.CompanyCompensation_CompanyCompensationPRPayExportId]
GO
