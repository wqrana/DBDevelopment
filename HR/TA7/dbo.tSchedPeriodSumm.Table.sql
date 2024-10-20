USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tSchedPeriodSumm]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSchedPeriodSumm](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](50) NULL,
	[sDesc] [nvarchar](50) NULL,
	[sNote] [nvarchar](50) NULL,
	[dblSchedHours] [float] NULL,
	[nPayPeriodType] [int] NULL,
	[nShiftDiff] [int] NULL,
	[sShiftDiffName] [nvarchar](10) NULL,
	[sShiftDiffCode] [nvarchar](10) NULL,
	[nShiftDiffCount] [int] NULL,
	[dShiftDiffStart] [smalldatetime] NULL,
	[dShiftDiffEnd] [smalldatetime] NULL,
	[sShiftDiffName2] [nvarchar](10) NULL,
	[sShiftDiffCode2] [nvarchar](10) NULL,
	[dShiftDiffStart2] [smalldatetime] NULL,
	[dShiftDiffEnd2] [smalldatetime] NULL,
 CONSTRAINT [PK_tSchedPeriodSumm] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
