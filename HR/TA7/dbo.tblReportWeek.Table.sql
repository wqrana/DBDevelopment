USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblReportWeek]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReportWeek](
	[e_id] [int] NULL,
	[e_idno] [nvarchar](14) NULL,
	[e_name] [nvarchar](30) NULL,
	[nPayRuleID] [int] NULL,
	[sPayRuleName] [nvarchar](50) NULL,
	[nPayWeekNum] [int] NULL,
	[DTStartDate] [smalldatetime] NULL,
	[DTEndDate] [smalldatetime] NULL,
	[dblREGULAR] [float] NULL,
	[dblONEHALF] [float] NULL,
	[dblDOUBLE] [float] NULL,
	[sHoursSummary] [nvarchar](175) NULL,
	[sWeekID] [nvarchar](30) NULL,
	[nDept] [int] NULL,
	[sDeptName] [nvarchar](30) NULL,
	[nCompID] [int] NULL,
	[sCompanyName] [nvarchar](50) NULL,
	[nEmployeeType] [int] NULL,
	[sEmployeeTypeName] [nvarchar](30) NULL,
	[nJobTitleID] [int] NULL,
	[sJobTitleName] [nvarchar](30) NULL,
	[nScheduleID] [int] NULL,
	[sScheduleName] [nvarchar](30) NULL,
	[nPayPeriod] [int] NULL,
	[nReviewStatus] [int] NULL,
	[nReviewSupervisorID] [int] NULL,
	[sSupervisorName] [nvarchar](50) NULL,
	[nWeekID] [bigint] NOT NULL,
	[dblMEAL] [float] NULL,
	[dblOTHERS] [float] NULL,
	[nLocked] [int] NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_tblReportWeek] PRIMARY KEY CLUSTERED 
(
	[nWeekID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblReportWeek] ADD  CONSTRAINT [DF_tblReportWeek_nLocked]  DEFAULT ((0)) FOR [nLocked]
GO
