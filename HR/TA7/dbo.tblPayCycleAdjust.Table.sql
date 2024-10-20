USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayCycleAdjust]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayCycleAdjust](
	[e_id] [int] NOT NULL,
	[DTPunchDate] [smalldatetime] NOT NULL,
	[dblHours] [decimal](18, 2) NOT NULL,
	[sType] [nvarchar](30) NOT NULL,
	[nWeekID] [bigint] NOT NULL,
	[nPayWeekNum] [int] NOT NULL,
	[bRejected] [bit] NOT NULL,
	[strAdjustType] [nvarchar](50) NOT NULL,
	[decAdjustAmount] [decimal](18, 2) NOT NULL,
	[decPayRate] [decimal](18, 2) NOT NULL,
	[intPayrollScheduleID] [int] NULL,
 CONSTRAINT [PK_tPayCycleAdjust] PRIMARY KEY CLUSTERED 
(
	[e_id] ASC,
	[DTPunchDate] ASC,
	[sType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
