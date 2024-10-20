USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchWeek]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchWeek](
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
	[sHoursSummary] [nvarchar](200) NULL,
	[sWeekID] [nvarchar](30) NULL,
 CONSTRAINT [PK_tPunchWeek] PRIMARY KEY CLUSTERED 
(
	[tpwID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [tPW_EID_STARTDATE_ENDDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPW_EID_STARTDATE_ENDDATE_INC] ON [dbo].[tPunchWeek]
(
	[e_id] ASC,
	[DTStartDate] ASC,
	[DTEndDate] ASC
)
INCLUDE([tpwID],[e_idno],[e_name],[nPayRuleID],[sPayRuleName],[nPayWeekNum],[dblREGULAR],[dblONEHALF],[dblDOUBLE],[sHoursSummary],[sWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPW_ENDDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPW_ENDDATE_INC] ON [dbo].[tPunchWeek]
(
	[DTEndDate] ASC
)
INCLUDE([tpwID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
