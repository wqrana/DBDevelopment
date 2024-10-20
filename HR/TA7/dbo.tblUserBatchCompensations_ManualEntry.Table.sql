USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserBatchCompensations_ManualEntry]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserBatchCompensations_ManualEntry](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[strCompensationName] [nvarchar](50) NOT NULL,
	[decPayRate] [decimal](18, 5) NOT NULL,
	[dtPayDate] [datetime] NOT NULL,
	[decHours] [decimal](18, 5) NOT NULL,
	[decPay] [decimal](18, 2) NOT NULL,
	[dtTimeStamp] [datetime] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[intSequenceNumber] [int] IDENTITY(1,1) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[intSupervisorID] [int] NOT NULL,
	[strNote] [nvarchar](50) NOT NULL,
	[intEditType] [int] NOT NULL,
 CONSTRAINT [PK_tblUserBatchCompensations_ManualEntry_1] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC,
	[intSequenceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserBatchCompensations_ManualEntry] ADD  CONSTRAINT [DF_tblUserBatchCompensations_ManualEntry_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
