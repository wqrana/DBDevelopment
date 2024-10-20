USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyWithholding]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholding](
	[CompanyWithholdingId] [int] IDENTITY(1,1) NOT NULL,
	[WithHoldingName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[WitholdingPrePostTypeId] [int] NOT NULL,
	[WitholdingComputationTypeId] [int] NOT NULL,
	[WithholdingTaxTypeId] [int] NOT NULL,
	[EmployeeWithholdingPercentage] [decimal](18, 2) NOT NULL,
	[EmployeeWithholdingAmount] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingPercent] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingAmount] [decimal](18, 2) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 2) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[intReportOrder] [int] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[IsLoan] [bit] NOT NULL,
	[Is401kPlan] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ContributionName] [nvarchar](150) NULL,
	[GLContributionAccountId] [int] NULL,
	[GLContributionPayableAccountId] [int] NULL,
	[IsUserWithholding] [bit] NULL,
	[IsCompanyContribution] [bit] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholding] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.GLAccount_GLAccountId] FOREIGN KEY([GLAccountId])
REFERENCES [dbo].[GLAccount] ([GLAccountId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.GLAccount_GLAccountId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WithholdingTaxType_WithholdingTaxTypeId] FOREIGN KEY([WithholdingTaxTypeId])
REFERENCES [dbo].[WithholdingTaxType] ([WithholdingTaxTypeId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WithholdingTaxType_WithholdingTaxTypeId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingComputationType_WitholdingComputationTypeId] FOREIGN KEY([WitholdingComputationTypeId])
REFERENCES [dbo].[WitholdingComputationType] ([WitholdingComputationTypeId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingComputationType_WitholdingComputationTypeId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingPrePostType_WitholdingPrePostTypeId] FOREIGN KEY([WitholdingPrePostTypeId])
REFERENCES [dbo].[WitholdingPrePostType] ([WitholdingPrePostTypeId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingPrePostType_WitholdingPrePostTypeId]
GO
