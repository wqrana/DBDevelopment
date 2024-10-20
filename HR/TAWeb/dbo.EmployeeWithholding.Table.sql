USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeWithholding]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWithholding](
	[EmployeeWithholdingId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[EmployeeWithholdingPercentage] [decimal](18, 2) NOT NULL,
	[EmployeeWithholdingAmount] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingPercent] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingAmount] [decimal](18, 2) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 2) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[Apply401kPlan] [bit] NOT NULL,
	[PeriodEntryId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[WitholdingPrePostTypeId] [int] NOT NULL,
	[WitholdingComputationTypeId] [int] NOT NULL,
	[WithholdingTaxTypeId] [int] NOT NULL,
	[intReportOrder] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[MoneyAmount] [decimal](18, 2) NOT NULL,
	[LoanAmount] [decimal](18, 2) NULL,
	[RemainingBalance] [decimal](18, 2) NULL,
	[LoanNumber] [int] NULL,
 CONSTRAINT [PK_EmployeeWithholding] PRIMARY KEY CLUSTERED 
(
	[EmployeeWithholdingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
