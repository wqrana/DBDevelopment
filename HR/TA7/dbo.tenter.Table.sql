USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tenter]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tenter](
	[e_date] [varchar](8) NULL,
	[e_time] [varchar](6) NULL,
	[g_id] [int] NULL,
	[e_id] [int] NULL,
	[e_name] [varchar](30) NULL,
	[e_idno] [varchar](30) NULL,
	[e_group] [smallint] NULL,
	[e_user] [varchar](1) NULL,
	[e_mode] [varchar](1) NULL,
	[e_type] [varchar](1) NULL,
	[e_result] [varchar](1) NULL,
	[e_etc] [varchar](1) NULL,
	[e_uptime] [varchar](14) NULL,
	[e_upmode] [varchar](1) NULL,
	[b_Processed] [bit] NULL,
	[teID] [int] IDENTITY(1,1) NOT NULL,
	[nJobCodeID] [int] NULL,
	[intTerminalType] [int] NULL,
 CONSTRAINT [PK_tenter] PRIMARY KEY CLUSTERED 
(
	[teID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ucTEnter] UNIQUE NONCLUSTERED 
(
	[e_id] ASC,
	[g_id] ASC,
	[e_date] ASC,
	[e_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_tenter_b_Processed]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tenter_b_Processed] ON [dbo].[tenter]
(
	[b_Processed] ASC
)
INCLUDE([e_id],[teID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tenter_b_Processed_e_result]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tenter_b_Processed_e_result] ON [dbo].[tenter]
(
	[b_Processed] ASC,
	[e_result] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tenter_e_id_b_Processed_e_date]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tenter_e_id_b_Processed_e_date] ON [dbo].[tenter]
(
	[e_id] ASC,
	[b_Processed] ASC,
	[e_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tenter_e_mode_b_Processed]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tenter_e_mode_b_Processed] ON [dbo].[tenter]
(
	[e_mode] ASC,
	[b_Processed] ASC
)
INCLUDE([teID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tE_DATE_EID_RESULT]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tE_DATE_EID_RESULT] ON [dbo].[tenter]
(
	[e_date] ASC,
	[e_id] ASC,
	[e_result] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tE_EID_RESULT_PROCESSED_MODE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tE_EID_RESULT_PROCESSED_MODE_INC] ON [dbo].[tenter]
(
	[e_id] ASC,
	[e_result] ASC,
	[b_Processed] ASC,
	[e_mode] ASC
)
INCLUDE([e_date],[e_time],[g_id],[e_name],[e_idno],[e_group],[e_user],[e_type],[e_etc],[e_uptime],[e_upmode],[teID],[nJobCodeID],[intTerminalType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tE_PROCESSED_DATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tE_PROCESSED_DATE_INC] ON [dbo].[tenter]
(
	[b_Processed] ASC,
	[e_date] ASC
)
INCLUDE([teID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tE_RESULT_PROCESSED_MODE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tE_RESULT_PROCESSED_MODE_INC] ON [dbo].[tenter]
(
	[e_result] ASC,
	[b_Processed] ASC,
	[e_mode] ASC
)
INCLUDE([e_date],[e_time],[g_id],[e_id],[e_name],[e_idno],[e_group],[e_user],[e_type],[e_etc],[e_uptime],[e_upmode],[teID],[nJobCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tenter] ADD  CONSTRAINT [DF_tenter_b_Processed2]  DEFAULT ((0)) FOR [b_Processed]
GO
ALTER TABLE [dbo].[tenter] ADD  CONSTRAINT [DF_tenter_nJobCodeID]  DEFAULT ((0)) FOR [nJobCodeID]
GO
