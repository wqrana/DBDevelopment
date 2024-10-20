USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserPayChecks]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserPayChecks](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[dtPayDate] [datetime] NOT NULL,
	[intSequenceNum] [int] IDENTITY(1,1) NOT NULL,
	[decCheckAmount] [decimal](18, 2) NOT NULL,
	[intPayCheckStatus] [int] NOT NULL,
	[intCheckNumber] [int] NOT NULL,
	[intPayMethodType] [int] NOT NULL,
	[intAccountType] [int] NOT NULL,
	[strBankAccountNumber] [nvarchar](50) NOT NULL,
	[strBankRoutingNumber] [nvarchar](50) NOT NULL,
	[strBankName] [nvarchar](50) NOT NULL,
	[decDepositPercent] [decimal](18, 5) NOT NULL,
	[decDepositAmount] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblUserPayChecks] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[dtPayDate] ASC,
	[intSequenceNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexUserPayChecksMethod]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserPayChecksMethod] ON [dbo].[tblUserPayChecks]
(
	[intPayMethodType] ASC
)
INCLUDE([strBatchID],[intUserID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblUserPayChecks_intPayMethodType]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblUserPayChecks_intPayMethodType] ON [dbo].[tblUserPayChecks]
(
	[intPayMethodType] ASC
)
INCLUDE([intCheckNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblUserPayChecks_intUserID_intPayMethodType]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblUserPayChecks_intUserID_intPayMethodType] ON [dbo].[tblUserPayChecks]
(
	[intUserID] ASC,
	[intPayMethodType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
