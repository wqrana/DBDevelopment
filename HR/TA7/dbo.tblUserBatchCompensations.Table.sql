USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserBatchCompensations]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserBatchCompensations](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[strCompensationName] [nvarchar](50) NOT NULL,
	[decPayRate] [decimal](18, 5) NOT NULL,
	[dtPayDate] [datetime] NOT NULL,
	[decHours] [decimal](18, 5) NOT NULL,
	[decPay] [decimal](18, 2) NOT NULL,
	[dtTimeStamp] [datetime] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
	[intEditType] [int] NOT NULL,
	[intUBMESequence] [int] NOT NULL,
 CONSTRAINT [PK_tblUserBatchCompensations_1] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indexUBC_BatchComp]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUBC_BatchComp] ON [dbo].[tblUserBatchCompensations]
(
	[strBatchID] ASC,
	[strCompensationName] ASC,
	[boolDeleted] ASC
)
INCLUDE([intUserID],[decHours],[decPay]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indexUBC_SequenceNumber]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUBC_SequenceNumber] ON [dbo].[tblUserBatchCompensations]
(
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indexUserBatchCompensation_UseridDelPaydate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserBatchCompensation_UseridDelPaydate] ON [dbo].[tblUserBatchCompensations]
(
	[intUserID] ASC,
	[boolDeleted] ASC,
	[dtPayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserBatchCompensations] ADD  CONSTRAINT [DF_tblBatchCompensations_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
ALTER TABLE [dbo].[tblUserBatchCompensations] ADD  DEFAULT ((0)) FOR [intUBMESequence]
GO
