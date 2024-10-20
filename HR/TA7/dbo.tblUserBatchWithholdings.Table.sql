USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserBatchWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserBatchWithholdings](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[strWithHoldingsName] [nvarchar](50) NOT NULL,
	[dtPayDate] [datetime] NOT NULL,
	[decBatchEffectivePay] [decimal](18, 2) NOT NULL,
	[decWithholdingsAmount] [decimal](18, 2) NOT NULL,
	[intPrePostTaxDeduction] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[dtTimeStamp] [datetime] NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
	[intEditType] [int] NOT NULL,
	[intUBMESequence] [int] NOT NULL,
 CONSTRAINT [PK_tblBatchEmployeeWithholdings] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indextblUserBatchWithholdings_UseridWHPaydate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indextblUserBatchWithholdings_UseridWHPaydate] ON [dbo].[tblUserBatchWithholdings]
(
	[intUserID] ASC,
	[strWithHoldingsName] ASC,
	[dtPayDate] ASC
)
INCLUDE([decWithholdingsAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indexUBW_SequenceNumber]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUBW_SequenceNumber] ON [dbo].[tblUserBatchWithholdings]
(
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserBatchWithholdings] ADD  CONSTRAINT [DF_tblUserBatchWithholdings_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
ALTER TABLE [dbo].[tblUserBatchWithholdings] ADD  DEFAULT ((0)) FOR [intUBMESequence]
GO
