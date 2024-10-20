USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tSchedModDailyDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSchedModDailyDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nUserID] [int] NULL,
	[sUserName] [nvarchar](50) NULL,
	[sWeekID] [nvarchar](30) NULL,
	[sNote] [nvarchar](50) NULL,
	[dPunchDate] [datetime] NULL,
	[dPunchIn1] [datetime] NULL,
	[dPunchOut1] [datetime] NULL,
	[dPunchIn2] [datetime] NULL,
	[dPunchOut2] [datetime] NULL,
	[dPunchIn3] [datetime] NULL,
	[dPunchOut3] [datetime] NULL,
	[dPunchIn4] [datetime] NULL,
	[dPunchOut4] [datetime] NULL,
	[nWorkDayType] [int] NULL,
	[dblDayHours] [float] NULL,
	[nSupervisorID] [int] NULL,
	[dModifiedDate] [datetime] NULL,
	[nPunchNum] [int] NULL,
	[nPayWeekNum] [int] NULL,
	[nJobCodeID] [int] NULL,
	[nSchedModPeriodSumm] [int] NULL,
 CONSTRAINT [PK_tSchedModDailyDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [tSMDD_USERID_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tSMDD_USERID_PUNCHDATE_INC] ON [dbo].[tSchedModDailyDetail]
(
	[nUserID] ASC,
	[dPunchDate] ASC
)
INCLUDE([ID],[sUserName],[sWeekID],[sNote],[dPunchIn1],[dPunchOut1],[dPunchIn2],[dPunchOut2],[dPunchIn3],[dPunchOut3],[dPunchIn4],[dPunchOut4],[nWorkDayType],[dblDayHours],[nSupervisorID],[dModifiedDate],[nPunchNum],[nPayWeekNum],[nJobCodeID],[nSchedModPeriodSumm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tSMDD_WEEKID]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tSMDD_WEEKID] ON [dbo].[tSchedModDailyDetail]
(
	[sWeekID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
