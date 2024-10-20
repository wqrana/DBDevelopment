USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserDirectDeposit]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserDirectDeposit](
	[intUserID] [int] NOT NULL,
	[intAccountType] [int] NOT NULL,
	[strBankAccountNumber] [nvarchar](50) NOT NULL,
	[strBankRoutingNumber] [nvarchar](50) NOT NULL,
	[strPayeeName] [nvarchar](50) NOT NULL,
	[strBankName] [nvarchar](50) NULL,
	[strBankBranch] [nvarchar](50) NULL,
	[strBankAddress] [nvarchar](150) NULL,
	[decDepositPercent] [decimal](18, 5) NOT NULL,
	[decDepositAmount] [decimal](18, 5) NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblUserDirectDeposit_1] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[intAccountType] ASC,
	[strBankAccountNumber] ASC,
	[strBankRoutingNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
