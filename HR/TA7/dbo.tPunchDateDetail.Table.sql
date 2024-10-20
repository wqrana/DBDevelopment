USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchDateDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchDateDetail](
	[tpdID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NOT NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[dblHours] [float] NULL,
	[sType] [nvarchar](30) NULL,
	[sExportCode] [nvarchar](10) NULL,
	[nHRProcessedCode] [int] NULL,
	[nWeekID] [bigint] NULL,
	[sNote] [nvarchar](50) NULL,
	[nCompensationStatus] [int] NULL,
	[nAccrualStatus] [int] NULL,
	[dblHoursOriginal] [float] NULL,
	[nCompensationStatusOriginal] [int] NULL,
	[nAccrualStatusOriginal] [int] NULL,
	[nAttendanceLetterCode] [int] NULL,
	[nTardinessLetterCode] [int] NULL,
 CONSTRAINT [PK_tPunchDateDetail] PRIMARY KEY CLUSTERED 
(
	[tpdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tPunchDateDetail_e_id_sType_nAccrualStatus_DTPunchDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchDateDetail_e_id_sType_nAccrualStatus_DTPunchDate] ON [dbo].[tPunchDateDetail]
(
	[e_id] ASC,
	[sType] ASC,
	[nAccrualStatus] ASC,
	[DTPunchDate] ASC
)
INCLUDE([dblHours]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tPunchDateDetail_sType]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchDateDetail_sType] ON [dbo].[tPunchDateDetail]
(
	[sType] ASC
)
INCLUDE([e_id],[DTPunchDate],[dblHours],[nWeekID],[sNote]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDD_EID_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDD_EID_INC] ON [dbo].[tPunchDateDetail]
(
	[e_id] ASC
)
INCLUDE([tpdID],[DTPunchDate],[dblHours],[sType],[nWeekID],[sNote]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDD_EID_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDD_EID_PUNCHDATE_INC] ON [dbo].[tPunchDateDetail]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[dblHours],[sType],[sExportCode],[nHRProcessedCode],[nWeekID],[sNote],[nCompensationStatus],[nAccrualStatus],[dblHoursOriginal],[nCompensationStatusOriginal],[nAccrualStatusOriginal]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPDD_WEEKID_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPDD_WEEKID_INC] ON [dbo].[tPunchDateDetail]
(
	[nWeekID] ASC
)
INCLUDE([tpdID],[e_id],[DTPunchDate],[dblHours],[sType],[sExportCode],[nHRProcessedCode],[sNote],[nCompensationStatus],[nAccrualStatus],[dblHoursOriginal],[nCompensationStatusOriginal],[nAccrualStatusOriginal]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nHRProcessedCode]  DEFAULT ((0)) FOR [nHRProcessedCode]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nWeekID]  DEFAULT ((0)) FOR [nWeekID]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_sNote]  DEFAULT (N'') FOR [sNote]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nCompensationStatus]  DEFAULT ((0)) FOR [nCompensationStatus]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nAccrualStatus]  DEFAULT ((0)) FOR [nAccrualStatus]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_dblHoursOriginal]  DEFAULT ((0)) FOR [dblHoursOriginal]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nCompensationStatusOriginal]  DEFAULT ((0)) FOR [nCompensationStatusOriginal]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nAccrualStatusOriginal]  DEFAULT ((0)) FOR [nAccrualStatusOriginal]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nAttendanceLetterCode]  DEFAULT ((0)) FOR [nAttendanceLetterCode]
GO
ALTER TABLE [dbo].[tPunchDateDetail] ADD  CONSTRAINT [DF_tPunchDateDetail_nTardinessLetterCode]  DEFAULT ((0)) FOR [nTardinessLetterCode]
GO
