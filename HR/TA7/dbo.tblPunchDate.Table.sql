USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPunchDate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPunchDate](
	[e_id] [int] NOT NULL,
	[e_idno] [nvarchar](14) NULL,
	[e_name] [nvarchar](30) NULL,
	[e_group] [smallint] NULL,
	[nSchedID] [int] NULL,
	[DayID] [nvarchar](16) NULL,
	[DtPunchDate] [smalldatetime] NOT NULL,
	[dblPunchHrs] [float] NULL,
	[sType] [nvarchar](20) NULL,
	[b_Processed] [bit] NULL,
	[sPunchSummary] [nvarchar](200) NULL,
	[sExceptions] [nvarchar](50) NULL,
	[sDaySchedule] [nvarchar](50) NULL,
	[sHoursSummary] [nvarchar](150) NULL,
	[bLocked] [bit] NULL,
	[dblREGULAR] [float] NULL,
	[dblONEHALF] [float] NULL,
	[dblDOUBLE] [float] NULL,
	[sWeekID] [nvarchar](30) NULL,
	[nCompanyID] [int] NULL,
	[nDeptID] [int] NULL,
	[nEmployeeTypeID] [int] NULL,
	[dblMEAL] [float] NULL,
	[dblOTHERS] [float] NULL,
	[nAbsentStatus] [int] NULL,
	[nJobTitleID] [int] NULL,
	[nWeekID] [bigint] NULL,
	[intPayWeekNum] [int] NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblPunchDate_1] PRIMARY KEY CLUSTERED 
(
	[e_id] ASC,
	[DtPunchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
