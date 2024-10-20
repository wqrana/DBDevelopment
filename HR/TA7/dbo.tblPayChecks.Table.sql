USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayChecks]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayChecks](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intUserID] [int] NOT NULL,
	[intCheckNumber] [int] NOT NULL,
	[dtPayDate] [smalldatetime] NOT NULL,
	[decCheckAmount] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblPayChecks_1] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC,
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
