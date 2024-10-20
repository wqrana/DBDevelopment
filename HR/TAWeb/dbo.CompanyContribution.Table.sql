USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyContribution]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContribution](
	[CompanyContributionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyContributionName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[WitholdingPrePostTypeId] [int] NOT NULL,
	[WitholdingComputationTypeId] [int] NOT NULL,
	[ContributionTaxTypeId] [int] NULL,
	[EmployeeContributionPercentage] [decimal](18, 2) NOT NULL,
	[EmployeeContributionAmount] [decimal](18, 2) NOT NULL,
	[CompanyContributionPercent] [decimal](18, 2) NOT NULL,
	[CompanyContributionAmount] [decimal](18, 2) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 2) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[intReportOrder] [int] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLContributionAccountId] [int] NULL,
	[GLContributionPayableAccountId] [int] NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[Is401kPlan] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyContribution] PRIMARY KEY CLUSTERED 
(
	[CompanyContributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
