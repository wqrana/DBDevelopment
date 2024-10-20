USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[davidexport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[davidexport](
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
	[nTransNum] [int] NULL
) ON [PRIMARY]
GO
