USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblBatchImportCompensationAmount]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBatchImportCompensationAmount](
	[strBatchID] [nvarchar](50) NOT NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[strCompensationName] [nvarchar](50) NOT NULL,
	[decMoneyAmount] [decimal](18, 5) NOT NULL,
	[intImportStatus] [int] NOT NULL,
	[dtImportDate] [datetime] NOT NULL,
	[intSupervisorID] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[dtPayDate] [date] NOT NULL,
 CONSTRAINT [PK_tblBatchImportCompensationAmount] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
