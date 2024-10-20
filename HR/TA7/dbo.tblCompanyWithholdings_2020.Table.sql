USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyWithholdings_2020]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyWithholdings_2020](
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
	[strGLContributionPayable] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
