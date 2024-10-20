USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchDate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchDate](
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
	[intPayrollLock] [int] NOT NULL,
 CONSTRAINT [PK_tPunchDate] PRIMARY KEY CLUSTERED 
(
	[tpdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ucCodes] UNIQUE NONCLUSTERED 
(
	[e_id] ASC,
	[DTPunchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPunchDate_DTPunchDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchDate_DTPunchDate] ON [dbo].[tPunchDate]
(
	[DTPunchDate] ASC
)
INCLUDE([e_id],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_ABSENTSTATUS_JOBTITLEID_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_ABSENTSTATUS_JOBTITLEID_PUNCHDATE_INC] ON [dbo].[tPunchDate]
(
	[nAbsentStatus] ASC,
	[nJobTitleID] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[e_id],[e_idno],[e_name],[e_group],[nSchedID],[DayID],[dblPunchHrs],[sType],[b_Processed],[sPunchSummary],[sExceptions],[sDaySchedule],[sHoursSummary],[bLocked],[dblREGULAR],[dblONEHALF],[dblDOUBLE],[sWeekID],[nCompanyID],[nDeptID],[nEmployeeTypeID],[dblMEAL],[dblOTHERS],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_EID_PROCESSED_LOCKED_PUNCHDATE]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_EID_PROCESSED_LOCKED_PUNCHDATE] ON [dbo].[tPunchDate]
(
	[e_id] ASC,
	[b_Processed] ASC,
	[bLocked] ASC,
	[DTPunchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_EID_PUNCHDATE]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_EID_PUNCHDATE] ON [dbo].[tPunchDate]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_EID_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_EID_PUNCHDATE_INC] ON [dbo].[tPunchDate]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[nCompanyID],[nDeptID],[nEmployeeTypeID],[nJobTitleID],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_PROCESSED_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_PROCESSED_INC] ON [dbo].[tPunchDate]
(
	[b_Processed] ASC
)
INCLUDE([tpdID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_PUNCHDATE_INC] ON [dbo].[tPunchDate]
(
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[b_Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDate_WEEKID]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDate_WEEKID] ON [dbo].[tPunchDate]
(
	[nWeekID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPunchDate] ADD  CONSTRAINT [DF_tPunchDate_b_Processed]  DEFAULT ((0)) FOR [b_Processed]
GO
ALTER TABLE [dbo].[tPunchDate] ADD  DEFAULT ((0)) FOR [intPayrollLock]
GO
