USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchPair]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchPair](
	[tppID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NULL,
	[e_idno] [nvarchar](14) NULL,
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
	[nJobCodeID] [int] NULL,
 CONSTRAINT [PK_tPunchPair] PRIMARY KEY CLUSTERED 
(
	[tppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexPunchPair_UseridDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexPunchPair_UseridDate] ON [dbo].[tPunchPair]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tppID],[b_Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indextPunchPair_Weekid]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indextPunchPair_Weekid] ON [dbo].[tPunchPair]
(
	[nWeekID] ASC
)
INCLUDE([e_id],[e_idno],[e_name],[DTPunchDate],[DTimeIn],[DTimeOut],[HoursWorked],[sType],[pCode],[b_Processed],[DayID],[bTrans],[sTCode],[sTDesc],[sTimeIn],[sTimeOut],[nIsTransAbsent],[nPunchDateDayOfWeek],[nHRAttendanceCat],[nHRProcessedCode],[nHRReportCode],[nJobCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPunchPair_b_Processed]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchPair_b_Processed] ON [dbo].[tPunchPair]
(
	[b_Processed] ASC
)
INCLUDE([e_id],[DTPunchDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tPunchPair_e_id_sType_DTPunchDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchPair_e_id_sType_DTPunchDate] ON [dbo].[tPunchPair]
(
	[e_id] ASC,
	[sType] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tppID],[e_idno],[e_name],[DTimeIn],[DTimeOut],[HoursWorked],[pCode],[b_Processed],[DayID],[bTrans],[sTCode],[sTDesc],[sTimeIn],[sTimeOut],[nWeekID],[nIsTransAbsent],[nPunchDateDayOfWeek],[nHRAttendanceCat],[nHRProcessedCode],[nHRReportCode],[nJobCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPP_EID_PROCESSED]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPP_EID_PROCESSED] ON [dbo].[tPunchPair]
(
	[e_id] ASC,
	[b_Processed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPP_EID_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPP_EID_PUNCHDATE_INC] ON [dbo].[tPunchPair]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tppID],[e_idno],[e_name],[DTimeIn],[DTimeOut],[HoursWorked],[sType],[pCode],[b_Processed],[DayID],[bTrans],[sTCode],[sTDesc],[sTimeIn],[sTimeOut],[nWeekID],[nIsTransAbsent],[nPunchDateDayOfWeek],[nHRAttendanceCat],[nHRProcessedCode],[nHRReportCode],[nJobCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPP_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPP_PUNCHDATE_INC] ON [dbo].[tPunchPair]
(
	[DTPunchDate] ASC
)
INCLUDE([tppID],[b_Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPunchPair] ADD  CONSTRAINT [DF_tPunchPair_nJobCodeID]  DEFAULT ((0)) FOR [nJobCodeID]
GO
