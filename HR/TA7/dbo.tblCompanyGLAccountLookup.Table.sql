USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyGLAccountLookup]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyGLAccountLookup](
	[intAccountLookup] [int] IDENTITY(1,1) NOT NULL,
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intCompanyID] [int] NOT NULL,
	[intDepartmentID] [int] NOT NULL,
	[intSubdepartmentID] [int] NOT NULL,
	[intEmployeeTypeID] [int] NOT NULL,
	[strGLAccountCompensation] [nvarchar](50) NOT NULL,
	[strGLAccountWithholdings] [nvarchar](50) NOT NULL,
	[strGLAccountContributions] [nvarchar](50) NOT NULL,
	[strGLPayrollBankAccount] [nvarchar](50) NOT NULL,
	[strGLPayrollTaxes] [nvarchar](50) NOT NULL,
	[intPositionID] [int] NOT NULL,
 CONSTRAINT [PK_tblCompanyGLAccountLookup] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intCompanyID] ASC,
	[intDepartmentID] ASC,
	[intSubdepartmentID] ASC,
	[intEmployeeTypeID] ASC,
	[intPositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ('') FOR [strGLAccountCompensation]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ('') FOR [strGLAccountWithholdings]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ('') FOR [strGLAccountContributions]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ('') FOR [strGLPayrollBankAccount]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ('') FOR [strGLPayrollTaxes]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountLookup] ADD  DEFAULT ((0)) FOR [intPositionID]
GO
