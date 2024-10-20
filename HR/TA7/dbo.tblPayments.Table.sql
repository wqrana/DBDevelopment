USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayments]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayments](
	[intPaymentID] [int] NOT NULL,
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intPaymentType] [int] NOT NULL,
	[intPaymentStatus] [int] NOT NULL,
	[intDirectDepositID] [int] NOT NULL,
	[strDebitGLAccount] [nvarchar](50) NOT NULL,
	[strCreditGLAccount] [nvarchar](50) NOT NULL,
	[decPaymentAmount] [decimal](18, 5) NOT NULL,
	[dtPaymentClearedDate] [datetime] NOT NULL,
	[strPaymentMemo] [nvarchar](max) NOT NULL,
	[dtPaymentTranactionDate] [datetime] NOT NULL,
	[dtTimeStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_tblPayments] PRIMARY KEY CLUSTERED 
(
	[intPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPayments] ADD  CONSTRAINT [DF_tblPayments_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
