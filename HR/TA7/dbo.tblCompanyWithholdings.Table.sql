USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyWithholdings](
	[strCompanyName] [nvarchar](50) NOT NULL,
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
	[intReportOrder] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[intWithholdingsTaxType] [int] NOT NULL,
	[strContributionsName] [nvarchar](50) NOT NULL,
	[strGLAccount_Contributions] [nvarchar](50) NOT NULL,
	[intGLLookupField] [int] NOT NULL,
	[strGLContributionPayable] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblCompanyWithholdings] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[strWithHoldingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyWithholdings] ADD  DEFAULT ('') FOR [strContributionsName]
GO
ALTER TABLE [dbo].[tblCompanyWithholdings] ADD  DEFAULT ('') FOR [strGLAccount_Contributions]
GO
ALTER TABLE [dbo].[tblCompanyWithholdings] ADD  DEFAULT ((0)) FOR [intGLLookupField]
GO
ALTER TABLE [dbo].[tblCompanyWithholdings] ADD  DEFAULT ('') FOR [strGLContributionPayable]
GO
