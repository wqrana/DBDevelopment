USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblWithholdingsItems]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWithholdingsItems](
	[strWithHoldingsName] [nvarchar](50) NOT NULL,
	[strDescription] [nvarchar](150) NULL,
	[intPrePostTaxDeduction] [int] NOT NULL,
	[intComputationType] [int] NOT NULL,
	[decEmployeePercent] [decimal](18, 5) NOT NULL,
	[decEmployeeAmount] [decimal](18, 5) NOT NULL,
	[decCompanyPercent] [decimal](18, 5) NOT NULL,
	[decCompanyAmount] [decimal](18, 5) NOT NULL,
	[decMaximumSalaryLimit] [decimal](18, 5) NOT NULL,
	[decMinimumSalaryLimit] [decimal](18, 5) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[intWithholdingsTaxType] [int] NULL,
	[strGLAccount] [nvarchar](50) NULL,
	[strContributionsName] [nvarchar](50) NOT NULL,
	[strGLAccount_Contributions] [nvarchar](50) NOT NULL,
	[boolIsLoan] [bit] NOT NULL,
	[boolIs401kPlan] [bit] NOT NULL,
	[boolUserWithholding] [bit] NOT NULL,
	[boolCompanyContribution] [bit] NOT NULL,
	[strGLContributionPayable] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblWithholdings] PRIMARY KEY CLUSTERED 
(
	[strWithHoldingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_intPrePostTaxDeduction]  DEFAULT ((0)) FOR [intPrePostTaxDeduction]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_intComputationType]  DEFAULT ((0)) FOR [intComputationType]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decEmployeePercent]  DEFAULT ((0)) FOR [decEmployeePercent]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decEmployeeAmount]  DEFAULT ((0)) FOR [decEmployeeAmount]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decCompanyPercent]  DEFAULT ((0)) FOR [decCompanyPercent]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decCompanyAmount]  DEFAULT ((0)) FOR [decCompanyAmount]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decMaximumSalaryLimit]  DEFAULT ((0)) FOR [decMaximumSalaryLimit]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_decMinimumSalaryLimit]  DEFAULT ((0)) FOR [decMinimumSalaryLimit]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  CONSTRAINT [DF_tblWithholdings_intEnabled]  DEFAULT ((0)) FOR [boolDeleted]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ('') FOR [strContributionsName]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ('') FOR [strGLAccount_Contributions]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ((0)) FOR [boolIsLoan]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ((0)) FOR [boolIs401kPlan]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ((0)) FOR [boolUserWithholding]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ((0)) FOR [boolCompanyContribution]
GO
ALTER TABLE [dbo].[tblWithholdingsItems] ADD  DEFAULT ('') FOR [strGLContributionPayable]
GO
