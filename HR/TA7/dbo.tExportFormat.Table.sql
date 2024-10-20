USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tExportFormat]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tExportFormat](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nCompanyID] [int] NULL,
	[nDeptID] [int] NULL,
	[nEmployeeTypeID] [int] NULL,
	[nPayPeriodID] [int] NULL,
	[nTimePeriodID] [int] NULL,
	[nFileFormatID] [int] NULL,
	[nLockDates] [int] NULL,
	[sExportFileName] [nvarchar](150) NULL,
	[sCompanyCode] [nvarchar](50) NULL,
	[sTransName] [nvarchar](50) NULL,
	[nFieldID] [int] NULL,
	[sEarnCode] [nvarchar](50) NULL,
	[nTransNum] [int] NULL,
 CONSTRAINT [PK_tExportFormat] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
