USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserBatchTransactions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserBatchTransactions](
	[intSequence] [int] IDENTITY(1,1) NOT NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
	[intUserID] [int] NOT NULL,
	[dtPunchDate] [smalldatetime] NOT NULL,
	[strTransactionType] [nvarchar](50) NOT NULL,
	[decHours] [decimal](18, 5) NOT NULL,
	[decMoneyValue] [decimal](18, 5) NOT NULL,
	[decPayRate] [decimal](18, 5) NOT NULL,
	[intJobCode] [int] NOT NULL,
	[dtTimeStamp] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_tblBatchTransactions_1] PRIMARY KEY CLUSTERED 
(
	[intSequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indexUBT_BatchUserid]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUBT_BatchUserid] ON [dbo].[tblUserBatchTransactions]
(
	[strBatchID] ASC,
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indexUserBatchTransactions_Userid]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserBatchTransactions_Userid] ON [dbo].[tblUserBatchTransactions]
(
	[strBatchID] ASC
)
INCLUDE([decHours]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserBatchTransactions] ADD  CONSTRAINT [DF_tblBatchTransactions_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
