USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tReportWeek]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tReportWeek](
	[tpwID] [int] IDENTITY(1,1) NOT NULL,
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
	[nWeekID] [bigint] NULL,
	[dblMEAL] [float] NULL,
	[dblOTHERS] [float] NULL,
	[nLocked] [int] NULL,
	[intUserReviewed] [int] NOT NULL,
	[intUserReviewedID] [int] NULL,
	[strUserReviewedName] [nvarchar](50) NULL,
	[dtUserReviewDate] [datetime] NULL,
 CONSTRAINT [PK_tReportWeek] PRIMARY KEY CLUSTERED 
(
	[tpwID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ucRW] UNIQUE NONCLUSTERED 
(
	[e_id] ASC,
	[nPayWeekNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexReportWeekPayweeknum]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexReportWeekPayweeknum] ON [dbo].[tReportWeek]
(
	[nPayWeekNum] ASC
)
INCLUDE([e_id],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tReportWeek_DTEndDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tReportWeek_DTEndDate] ON [dbo].[tReportWeek]
(
	[DTEndDate] ASC
)
INCLUDE([e_id],[nPayRuleID],[DTStartDate],[sHoursSummary]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tReportWeek_nDept_nPayPeriod_DTStartDate_DTEndDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tReportWeek_nDept_nPayPeriod_DTStartDate_DTEndDate] ON [dbo].[tReportWeek]
(
	[nDept] ASC,
	[nPayPeriod] ASC,
	[DTStartDate] ASC,
	[DTEndDate] ASC
)
INCLUDE([e_id],[e_idno],[e_name],[nPayRuleID],[sPayRuleName],[nPayWeekNum],[dblREGULAR],[dblONEHALF],[dblDOUBLE],[sHoursSummary],[sWeekID],[sDeptName],[nCompID],[sCompanyName],[nEmployeeType],[sEmployeeTypeName],[nJobTitleID],[sJobTitleName],[nScheduleID],[sScheduleName],[nReviewStatus],[nReviewSupervisorID],[sSupervisorName],[nWeekID],[dblMEAL],[dblOTHERS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tRW_COMPID_PAYPERIOD_STARTDATE_ENDDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tRW_COMPID_PAYPERIOD_STARTDATE_ENDDATE_INC] ON [dbo].[tReportWeek]
(
	[nCompID] ASC,
	[nPayPeriod] ASC,
	[DTStartDate] ASC,
	[DTEndDate] ASC
)
INCLUDE([tpwID],[e_id],[e_idno],[e_name],[nPayRuleID],[sPayRuleName],[nPayWeekNum],[dblREGULAR],[dblONEHALF],[dblDOUBLE],[sHoursSummary],[sWeekID],[nDept],[sDeptName],[sCompanyName],[nEmployeeType],[sEmployeeTypeName],[nJobTitleID],[sJobTitleName],[nScheduleID],[sScheduleName],[nReviewStatus],[nReviewSupervisorID],[sSupervisorName],[nWeekID],[dblMEAL],[dblOTHERS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tRW_EID]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tRW_EID] ON [dbo].[tReportWeek]
(
	[e_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tRW_LOCKED_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tRW_LOCKED_INC] ON [dbo].[tReportWeek]
(
	[nLocked] ASC
)
INCLUDE([nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tRW_PAYPERIOD_STARTDATE_ENDDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tRW_PAYPERIOD_STARTDATE_ENDDATE_INC] ON [dbo].[tReportWeek]
(
	[nPayPeriod] ASC,
	[DTStartDate] ASC,
	[DTEndDate] ASC
)
INCLUDE([nPayWeekNum]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tRW_PAYWEEKNUM_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tRW_PAYWEEKNUM_INC] ON [dbo].[tReportWeek]
(
	[nPayWeekNum] ASC
)
INCLUDE([nDept],[sDeptName],[nCompID],[sCompanyName],[nEmployeeType],[sEmployeeTypeName],[nJobTitleID],[sJobTitleName],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tReportWeek] ADD  CONSTRAINT [DF_tReportWeek_nLocked]  DEFAULT ((0)) FOR [nLocked]
GO
ALTER TABLE [dbo].[tReportWeek] ADD  DEFAULT ((0)) FOR [intUserReviewed]
GO
