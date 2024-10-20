USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyContribution401K]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContribution401K](
	[CompanyContribution401KId] [int] NOT NULL,
	[CompanyContributionId] [int] NOT NULL,
	[PlanDescription] [nvarchar](250) NULL,
	[EEMaxYearlyAmount] [decimal](18, 5) NULL,
	[ERMaxYearlyAmount] [decimal](18, 5) NULL,
	[EmployerMatchPercentage] [decimal](18, 5) NULL,
	[EmployerPeriodMax] [decimal](18, 5) NULL,
	[EmployerPercentageLimitType] [decimal](18, 5) NULL,
	[Is401K1165eStTaxExempted] [bit] NOT NULL,
	[Withholding401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyContribution401K] PRIMARY KEY CLUSTERED 
(
	[CompanyContribution401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
