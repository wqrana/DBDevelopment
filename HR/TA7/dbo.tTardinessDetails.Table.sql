USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tTardinessDetails]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTardinessDetails](
	[tppID] [int] NOT NULL,
	[e_id] [int] NULL,
	[e_idno] [nvarchar](14) NULL,
	[nRptID] [int] NULL,
	[e_name] [nvarchar](30) NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[DTimeIn] [smalldatetime] NULL,
	[DTimeOut] [smalldatetime] NULL,
	[HoursWorked] [float] NULL,
	[sType] [nvarchar](30) NULL,
	[pCode] [nvarchar](10) NULL,
	[b_Processed] [bit] NULL,
	[DayID] [nvarchar](16) NULL,
	[bTrans] [bit] NULL,
	[sTCode] [nvarchar](10) NULL,
	[sTDesc] [nvarchar](50) NULL,
	[sTimeIn] [nvarchar](25) NULL,
	[sTimeOut] [nvarchar](25) NULL,
	[nWeekID] [bigint] NULL,
	[nIsTransAbsent] [int] NULL,
	[nPunchDateDayOfWeek] [int] NULL,
	[nHRAttendanceCat] [int] NULL,
	[nHRProcessedCode] [int] NULL,
	[nHRReportCode] [int] NULL,
 CONSTRAINT [PK_tTardinessDetails] PRIMARY KEY CLUSTERED 
(
	[tppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
