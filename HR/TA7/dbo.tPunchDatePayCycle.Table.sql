USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchDatePayCycle]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchDatePayCycle](
	[tpdID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NOT NULL,
	[e_idno] [nvarchar](14) NULL,
	[e_name] [nvarchar](30) NULL,
	[e_group] [smallint] NULL,
	[nSchedID] [int] NULL,
	[DayID] [nvarchar](16) NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[dblPunchHrs] [float] NULL,
	[sType] [nvarchar](20) NULL,
	[b_Processed] [bit] NULL,
	[sPunchSummary] [nvarchar](175) NULL,
	[sExceptions] [nvarchar](50) NULL,
	[sDaySchedule] [nvarchar](50) NULL,
	[sHoursSummary] [nvarchar](100) NULL,
	[bLocked] [bit] NULL,
	[dblREGULAR] [float] NULL,
	[dblONEHALF] [float] NULL,
	[dblDOUBLE] [float] NULL,
	[sWeekID] [nvarchar](30) NULL,
	[nCompanyID] [int] NULL,
	[nDeptID] [int] NULL,
	[nEmployeeTypeID] [int] NULL,
	[nPayWeekNum] [int] NULL,
 CONSTRAINT [PK_tPunchDatePayCycle] PRIMARY KEY CLUSTERED 
(
	[tpdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
