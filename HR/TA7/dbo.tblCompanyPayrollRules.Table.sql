USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyPayrollRules]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyPayrollRules](
	[strPayrollCompany] [nvarchar](50) NOT NULL,
	[intPayrollRule] [int] NOT NULL,
	[intPaymentSchedule] [int] NOT NULL,
 CONSTRAINT [PK_tblCompanyPayrollRule] PRIMARY KEY CLUSTERED 
(
	[strPayrollCompany] ASC,
	[intPayrollRule] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
