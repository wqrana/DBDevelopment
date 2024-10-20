USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyBatchWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyBatchWithholdings](
	[strBatchID] [nvarchar](50) NOT NULL,
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
	[strGLContributionPayable] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblBatchCompanyWithholdings] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_tblCompanyBatchWithholdings_UseridWithholding]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [index_tblCompanyBatchWithholdings_UseridWithholding] ON [dbo].[tblCompanyBatchWithholdings]
(
	[intUserID] ASC,
	[strWithHoldingsName] ASC,
	[boolDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indexCBW_SequenceNumber]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexCBW_SequenceNumber] ON [dbo].[tblCompanyBatchWithholdings]
(
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IndexCompanyBatchWithholdingsWHDeleted]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IndexCompanyBatchWithholdingsWHDeleted] ON [dbo].[tblCompanyBatchWithholdings]
(
	[strWithHoldingsName] ASC,
	[boolDeleted] ASC
)
INCLUDE([strBatchID],[intUserID],[decWithholdingsAmount],[intEditType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblCompanyBatchWithholdings_intUserID_boolDeleted]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblCompanyBatchWithholdings_intUserID_boolDeleted] ON [dbo].[tblCompanyBatchWithholdings]
(
	[intUserID] ASC,
	[boolDeleted] ASC
)
INCLUDE([strWithHoldingsName],[intEditType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tblCompanyBatchWithholdings_intUserID_strWithHoldingsName_boolDeleted]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblCompanyBatchWithholdings_intUserID_strWithHoldingsName_boolDeleted] ON [dbo].[tblCompanyBatchWithholdings]
(
	[intUserID] ASC,
	[strWithHoldingsName] ASC,
	[boolDeleted] ASC
)
INCLUDE([strBatchID],[decWithholdingsAmount],[intEditType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyBatchWithholdings] ADD  CONSTRAINT [DF_tblCompanyBatchWithholdings_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
ALTER TABLE [dbo].[tblCompanyBatchWithholdings] ADD  DEFAULT ((0)) FOR [intUBMESequence]
GO
ALTER TABLE [dbo].[tblCompanyBatchWithholdings] ADD  DEFAULT ('') FOR [strGLContributionPayable]
GO
