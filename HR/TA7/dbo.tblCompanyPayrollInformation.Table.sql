USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyPayrollInformation]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyPayrollInformation](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[strAddress1] [nvarchar](50) NULL,
	[strAddress2] [nvarchar](50) NULL,
	[strCity] [nvarchar](50) NULL,
	[strState] [nvarchar](50) NULL,
	[strZipCode] [nvarchar](50) NULL,
	[strCountry] [nvarchar](50) NULL,
	[strPhone] [nvarchar](50) NULL,
	[strFax] [nvarchar](50) NULL,
	[strEmail] [nvarchar](100) NULL,
	[strWebSite] [nvarchar](50) NULL,
	[strContactName] [nvarchar](50) NULL,
	[strPayrollName] [nvarchar](50) NULL,
	[strPayrollAddress1] [nvarchar](50) NULL,
	[strPayrollAddress2] [nvarchar](50) NULL,
	[strPayrollCountry] [nvarchar](50) NULL,
	[strPayrollCity] [nvarchar](50) NULL,
	[strPayrollState] [nvarchar](50) NULL,
	[strPayrollZipCode] [nvarchar](50) NULL,
	[strEIN] [nvarchar](50) NOT NULL,
	[strPayrollFax] [nvarchar](50) NULL,
	[strPayrollContactName] [nvarchar](50) NULL,
	[strPayrollContactTitle] [nvarchar](50) NULL,
	[strPayrollContactPhone] [nvarchar](50) NOT NULL,
	[strPayrollEmail] [nvarchar](50) NULL,
	[dtCompanyStartDate] [date] NULL,
	[strSICCode] [nvarchar](50) NOT NULL,
	[strNAICSCode] [nvarchar](50) NOT NULL,
	[strSeguroChoferilAccount] [nvarchar](50) NOT NULL,
	[strDepartamentoDelTrabajoAccount] [nvarchar](50) NOT NULL,
	[decDepartamentoDelTrabajoRate] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblCompanyInformation] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyPayrollInformation] ADD  DEFAULT ('') FOR [strSICCode]
GO
ALTER TABLE [dbo].[tblCompanyPayrollInformation] ADD  DEFAULT ('') FOR [strNAICSCode]
GO
ALTER TABLE [dbo].[tblCompanyPayrollInformation] ADD  DEFAULT ('') FOR [strSeguroChoferilAccount]
GO
ALTER TABLE [dbo].[tblCompanyPayrollInformation] ADD  DEFAULT ('') FOR [strDepartamentoDelTrabajoAccount]
GO
ALTER TABLE [dbo].[tblCompanyPayrollInformation] ADD  DEFAULT ((0)) FOR [decDepartamentoDelTrabajoRate]
GO
