USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompensationsItems_PRPayExport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompensationsItems_PRPayExport](
	[strCompensationName] [nvarchar](50) NOT NULL,
	[boolCustom_income_1] [bit] NOT NULL,
	[boolCustom_income_2] [bit] NOT NULL,
	[boolCustom_income_3] [bit] NOT NULL,
	[boolCustom_income_4] [bit] NOT NULL,
	[boolCustom_income_5] [bit] NOT NULL,
	[boolNon_taxable_1] [bit] NOT NULL,
	[boolNon_taxable_2] [bit] NOT NULL,
	[boolNon_taxable_3] [bit] NOT NULL,
	[boolNon_taxable_4] [bit] NOT NULL,
	[boolNon_taxable_5] [bit] NOT NULL,
	[boolWages] [bit] NOT NULL,
	[boolCommissions] [bit] NOT NULL,
	[boolAllowances] [bit] NOT NULL,
	[boolTips] [bit] NOT NULL,
	[bool401K_Income] [bit] NOT NULL,
	[boolOther_Retirement] [bit] NOT NULL,
	[boolCafeteria] [bit] NOT NULL,
	[boolReimbursements] [bit] NOT NULL,
	[boolCODA_401K] [bit] NOT NULL,
	[boolExempt_Salaries] [bit] NOT NULL,
 CONSTRAINT [PK_tblCompensationsItems_PRPayExport] PRIMARY KEY CLUSTERED 
(
	[strCompensationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
