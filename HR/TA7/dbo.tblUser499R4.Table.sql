USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUser499R4]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser499R4](
	[intUserID] [int] NOT NULL,
	[dtEntryDate] [datetime] NOT NULL,
	[strSpouseName] [nvarchar](50) NOT NULL,
	[strSpouseSSN] [nvarchar](50) NOT NULL,
	[intWagesLess20000] [int] NOT NULL,
	[intMilitarySpouseReliefAct] [int] NOT NULL,
	[intOptionalMarriedJointReturn] [int] NOT NULL,
	[intIndividualExemption] [int] NOT NULL,
	[intMarriedExemption] [int] NOT NULL,
	[intVeteranAdditionalExemption] [int] NOT NULL,
	[intDependentsTotalExemption] [int] NOT NULL,
	[intDependentsSharedCustody] [int] NOT NULL,
	[intSpecialAllowance20000] [int] NOT NULL,
	[decHomeMortgageInterest] [decimal](18, 5) NOT NULL,
	[decCharitableContributions] [decimal](18, 5) NOT NULL,
	[decMedicalExpenses] [decimal](18, 5) NOT NULL,
	[decStudentLoanInterest] [decimal](18, 5) NOT NULL,
	[decGovernmentPensionsRetirement] [decimal](18, 5) NOT NULL,
	[decEducationContributionAccount] [decimal](18, 5) NOT NULL,
	[decHealthSavingsAccount] [decimal](18, 5) NOT NULL,
	[decCasualtyResidenceLoss] [decimal](18, 5) NOT NULL,
	[decPersonalProperyLoss] [decimal](18, 5) NOT NULL,
	[decTotalDeductions] [decimal](18, 5) NOT NULL,
	[decNumberAllowancesAllowed] [decimal](18, 5) NOT NULL,
	[decAllowancesClaimed] [decimal](18, 5) NOT NULL,
	[intGovernmentTWSPlan] [int] NULL,
	[intGovernmentRSAProgram] [int] NULL,
	[decGovernmnetRSAProgramPercent] [decimal](18, 5) NULL,
	[decAdditionalWithholdingAmount] [decimal](18, 5) NULL,
	[decAddtionalWithholdingPercent] [decimal](18, 5) NULL,
 CONSTRAINT [PK_tbl499R4] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[dtEntryDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
