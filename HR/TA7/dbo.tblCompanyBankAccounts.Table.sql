USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyBankAccounts]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyBankAccounts](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[strBankAccountNumber] [nvarchar](50) NOT NULL,
	[strBankRoutingNumber] [nvarchar](50) NOT NULL,
	[intBankAccountType] [int] NOT NULL,
	[strBankName] [nvarchar](50) NOT NULL,
	[strBankBranch] [nvarchar](50) NULL,
	[strBankAddress] [nvarchar](150) NULL,
	[intPayrollAccount] [int] NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[strACHAccountNumber] [nvarchar](50) NOT NULL,
	[intCheckSeedNumber] [int] NOT NULL,
	[intDirectDepositSeedNumber] [int] NOT NULL,
	[strACHFileLetter] [nvarchar](1) NOT NULL,
	[strACHCompanyNameInFile] [nvarchar](50) NOT NULL,
	[intACHBankAccountIdentifier] [int] NOT NULL,
	[strACHBankAccountIdentifier] [nvarchar](1) NULL,
	[intCheckingAccountID] [int] NOT NULL,
	[decPayrollLimit] [decimal](18, 5) NOT NULL,
	[decPayrollDailyLimit] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblCompanyBankAccounts] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[strBankAccountNumber] ASC,
	[strBankRoutingNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  CONSTRAINT [DF_tblCompanyBankAccounts_intCheckSeedNumber]  DEFAULT ((0)) FOR [intCheckSeedNumber]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  CONSTRAINT [DF_tblCompanyBankAccounts_intDirectDepositSeedNumber]  DEFAULT ((0)) FOR [intDirectDepositSeedNumber]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  DEFAULT ('') FOR [strACHCompanyNameInFile]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  DEFAULT ((1)) FOR [intACHBankAccountIdentifier]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  DEFAULT ((0)) FOR [intCheckingAccountID]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  DEFAULT ((0)) FOR [decPayrollLimit]
GO
ALTER TABLE [dbo].[tblCompanyBankAccounts] ADD  DEFAULT ((0)) FOR [decPayrollDailyLimit]
GO
