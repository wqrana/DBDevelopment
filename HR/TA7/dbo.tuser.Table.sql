USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tuser]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tuser](
	[id] [int] NOT NULL,
	[name] [varchar](30) NULL,
	[reg_date] [varchar](12) NULL,
	[datelimit] [varchar](17) NULL,
	[idno] [varchar](30) NULL,
	[badmin] [varchar](1) NULL,
	[padmin] [int] NULL,
	[company] [varchar](30) NULL,
	[dept] [varchar](30) NULL,
	[phone] [varchar](50) NULL,
	[group_id] [smallint] NULL,
	[cantgate] [image] NULL,
	[timegate] [image] NULL,
	[validtype] [varchar](1) NULL,
	[pwd] [varchar](8) NULL,
	[cancard] [varchar](1) NULL,
	[cardnum] [varchar](20) NULL,
	[identify] [varchar](1) NULL,
	[seculevel] [varchar](1) NULL,
	[fpdata] [image] NULL,
	[fpimage] [image] NULL,
	[fpname] [image] NULL,
	[face] [image] NULL,
	[voice] [image] NULL,
	[remark] [varchar](50) NULL,
	[antipass_state] [int] NULL,
	[antipass_lasttime] [varchar](14) NULL,
	[nCompanyID] [int] NULL,
	[nDeptID] [int] NULL,
	[nJobTitleID] [int] NULL,
	[nGroupID] [int] NULL,
	[nEmployeeType] [int] NULL,
	[nStatus] [int] NULL,
	[sNotes] [nvarchar](50) NULL,
	[objPhoto] [image] NULL,
	[nPunchClockID] [int] NULL,
	[nPayrollRuleID] [int] NULL,
	[nScheduleID] [int] NULL,
	[nSupervisorType] [int] NULL,
	[sPwd] [nvarchar](10) NULL,
	[nCompanyRest] [int] NULL,
	[nDeptRest] [int] NULL,
	[nCatRest] [int] NULL,
	[bEmpRecordsView] [bit] NULL,
	[bEmpRecordsEdit] [bit] NULL,
	[bEmpReportsView] [bit] NULL,
	[bPunchMaintView] [bit] NULL,
	[bPunchMaintEdit] [bit] NULL,
	[bPunchSuperView] [bit] NULL,
	[bReptPeriod] [bit] NULL,
	[bReptHistorical] [bit] NULL,
	[bReptAudit] [bit] NULL,
	[bExportPayroll] [bit] NULL,
	[bPayRuleView] [bit] NULL,
	[bPayRuleEdit] [bit] NULL,
	[bSchedView] [bit] NULL,
	[bSchedEdit] [bit] NULL,
	[bCompanySettings] [bit] NULL,
	[bMonitor] [bit] NULL,
	[bEmployeeImport] [bit] NULL,
	[bRestrictClock] [bit] NULL,
	[nRestrickClock] [int] NULL,
	[nSupervisorViewOptions] [int] NULL,
	[bHoursLostView] [bit] NULL,
	[bHoursLostEdit] [bit] NULL,
	[nSickRule] [int] NULL,
	[nVacationRule] [int] NULL,
	[nEmployeeTypeRest] [int] NULL,
	[sPwdHash] [nvarchar](max) NULL,
	[intPositionID] [int] NOT NULL,
	[FirstName] [nvarchar](30) NULL,
	[MiddleInitial] [nvarchar](2) NULL,
	[FirstLastName] [varchar](30) NULL,
	[SecondLastName] [varchar](30) NULL,
	[ShortFullName] [nvarchar](50) NULL,
	[Comments] [nvarchar](200) NULL,
	[AutoShortFullName] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_tuser] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [indexUserStatus]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserStatus] ON [dbo].[tuser]
(
	[nStatus] ASC
)
INCLUDE([id],[name],[idno],[nCompanyID],[nDeptID],[nJobTitleID],[nEmployeeType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tU_STATUS_PUNCHCLOCKID_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tU_STATUS_PUNCHCLOCKID_INC] ON [dbo].[tuser]
(
	[nStatus] ASC,
	[nPunchClockID] ASC
)
INCLUDE([id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nCompanyID]  DEFAULT ((0)) FOR [nCompanyID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nDeptID]  DEFAULT ((0)) FOR [nDeptID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nJobTitleID]  DEFAULT ((0)) FOR [nJobTitleID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nGroupID]  DEFAULT ((0)) FOR [nGroupID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nEmployeeType]  DEFAULT ((0)) FOR [nEmployeeType]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nStatus2]  DEFAULT ((-2)) FOR [nStatus]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_sNotes]  DEFAULT (N'""') FOR [sNotes]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nPunchClockID]  DEFAULT ((0)) FOR [nPunchClockID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nPayrollRuleID]  DEFAULT ((0)) FOR [nPayrollRuleID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nScheduleID]  DEFAULT ((0)) FOR [nScheduleID]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nSupervisorType]  DEFAULT ((0)) FOR [nSupervisorType]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_sPwd]  DEFAULT (N'""') FOR [sPwd]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nCompanyRest]  DEFAULT ((0)) FOR [nCompanyRest]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nDeptRest]  DEFAULT ((0)) FOR [nDeptRest]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nCatRest]  DEFAULT ((0)) FOR [nCatRest]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bEmpRecordsView]  DEFAULT ((0)) FOR [bEmpRecordsView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bEmpRecordsEdit]  DEFAULT ((0)) FOR [bEmpRecordsEdit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bEmpReportsView]  DEFAULT ((0)) FOR [bEmpReportsView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bPunchMaintView]  DEFAULT ((0)) FOR [bPunchMaintView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bPunchMaintEdit]  DEFAULT ((0)) FOR [bPunchMaintEdit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bPunchSuperView]  DEFAULT ((0)) FOR [bPunchSuperView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bReptPeriod]  DEFAULT ((0)) FOR [bReptPeriod]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bReptHistorical]  DEFAULT ((0)) FOR [bReptHistorical]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bReptAudit]  DEFAULT ((0)) FOR [bReptAudit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bExportPayroll]  DEFAULT ((0)) FOR [bExportPayroll]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bPayRuleView]  DEFAULT ((0)) FOR [bPayRuleView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bPayRuleEdit]  DEFAULT ((0)) FOR [bPayRuleEdit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bSchedView]  DEFAULT ((0)) FOR [bSchedView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bSchedEdit]  DEFAULT ((0)) FOR [bSchedEdit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bCompanySettings]  DEFAULT ((0)) FOR [bCompanySettings]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bMonitor]  DEFAULT ((0)) FOR [bMonitor]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bEmployeeImport]  DEFAULT ((0)) FOR [bEmployeeImport]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bRestrictClock]  DEFAULT ((0)) FOR [bRestrictClock]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nRestrickClock]  DEFAULT ((0)) FOR [nRestrickClock]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_nSupervisorViewOptions]  DEFAULT ((0)) FOR [nSupervisorViewOptions]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bHoursLostView]  DEFAULT ((0)) FOR [bHoursLostView]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF_tuser_bHoursLostEdit]  DEFAULT ((0)) FOR [bHoursLostEdit]
GO
ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [DF__tuser__nEmployee__6E8B6712]  DEFAULT ((0)) FOR [nEmployeeTypeRest]
GO
ALTER TABLE [dbo].[tuser] ADD  DEFAULT ((0)) FOR [intPositionID]
GO
