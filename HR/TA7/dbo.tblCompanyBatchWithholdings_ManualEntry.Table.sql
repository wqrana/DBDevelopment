USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyBatchWithholdings_ManualEntry]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyBatchWithholdings_ManualEntry](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[strWithHoldingsName] [nvarchar](50) NOT NULL,
	[dtPayDate] [datetime] NOT NULL,
	[decBatchEffectivePay] [decimal](18, 2) NOT NULL,
	[decWithholdingsAmount] [decimal](18, 2) NOT NULL,
	[intPrePostTaxDeduction] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
	[intSupervisorID] [int] NOT NULL,
	[strNote] [nvarchar](50) NOT NULL,
	[dtTimeStamp] [datetime] NOT NULL,
	[intEditType] [int] NULL,
	[strGLContributionPayable] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblCompanyBatchWithholdings_ManualEntry] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyBatchWithholdings_ManualEntry] ADD  CONSTRAINT [DF_tblCompanyBatchWithholdings_ManualEntry_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
ALTER TABLE [dbo].[tblCompanyBatchWithholdings_ManualEntry] ADD  DEFAULT ('') FOR [strGLContributionPayable]
GO
