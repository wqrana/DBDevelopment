USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblWithholdingsItems_W2Export]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWithholdingsItems_W2Export](
	[strWithholdingsName] [nvarchar](50) NOT NULL,
	[boolHealth_CoverageContribution] [bit] NOT NULL,
	[boolCharitable_Contribution] [bit] NOT NULL,
	[boolReimbursements] [bit] NOT NULL,
	[boolTaxWithheld] [bit] NOT NULL,
	[boolGovtRetirementFund] [bit] NOT NULL,
	[boolCODA_401k] [bit] NOT NULL,
	[boolExemptSalary] [bit] NOT NULL,
	[boolSaveAndDouble] [bit] NOT NULL,
	[boolSocialSecurity] [bit] NOT NULL,
	[boolMedicare] [bit] NOT NULL,
	[boolMedicarePlus] [bit] NOT NULL,
 CONSTRAINT [PK_tblWithholdingsItems_W2Export] PRIMARY KEY CLUSTERED 
(
	[strWithholdingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
