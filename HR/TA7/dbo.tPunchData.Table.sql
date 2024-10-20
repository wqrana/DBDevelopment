USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchData]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchData](
	[tpdID] [int] IDENTITY(1,1) NOT NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[DTPunchDateTime] [smalldatetime] NULL,
	[g_id] [int] NULL,
	[e_id] [int] NULL,
	[e_name] [nvarchar](30) NULL,
	[e_idno] [nvarchar](30) NULL,
	[e_group] [smallint] NULL,
	[e_user] [nvarchar](1) NULL,
	[e_mode] [nvarchar](1) NULL,
	[e_type] [nvarchar](1) NULL,
	[e_result] [nvarchar](1) NULL,
	[b_Processed] [bit] NULL,
	[b_Modified] [bit] NULL,
	[nAdminID] [int] NULL,
	[sModType] [nvarchar](3) NULL,
	[nJobCodeID] [int] NULL,
	[sNote] [nvarchar](30) NULL,
	[nPunchType] [int] NULL,
	[intTerminalType] [int] NULL,
	[DTPunchdate_Original] [smalldatetime] NULL,
	[DTPunchDateTime_Original] [smalldatetime] NULL,
	[DTPunchDateTime_Rounded] [datetime] NULL,
 CONSTRAINT [PK_tPunchData] PRIMARY KEY CLUSTERED 
(
	[tpdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexPunchdataProcessed]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexPunchdataProcessed] ON [dbo].[tPunchData]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[b_Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tPunchData_e_id_b_Processed_sModType]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchData_e_id_b_Processed_sModType] ON [dbo].[tPunchData]
(
	[e_id] ASC,
	[b_Processed] ASC,
	[sModType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tPunchData_e_id_DTPunchDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tPunchData_e_id_DTPunchDate] ON [dbo].[tPunchData]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([DTPunchDateTime],[g_id],[e_name],[e_idno],[e_group],[e_user],[e_mode],[e_type],[e_result],[b_Processed],[b_Modified],[nAdminID],[sModType],[nJobCodeID],[sNote],[nPunchType],[intTerminalType],[DTPunchdate_Original],[DTPunchDateTime_Original],[DTPunchDateTime_Rounded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [tPData_PROCESSED_MODTYPE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPData_PROCESSED_MODTYPE_INC] ON [dbo].[tPunchData]
(
	[b_Processed] ASC,
	[sModType] ASC
)
INCLUDE([tpdID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPData_PUNCHDATE_EID]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPData_PUNCHDATE_EID] ON [dbo].[tPunchData]
(
	[DTPunchDate] ASC,
	[e_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPData_PUNCHDATE_EID_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPData_PUNCHDATE_EID_INC] ON [dbo].[tPunchData]
(
	[e_id] ASC,
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[DTPunchDateTime],[g_id],[e_name],[e_idno],[e_group],[e_user],[e_mode],[e_type],[e_result],[b_Processed],[b_Modified],[nAdminID],[sModType],[nJobCodeID],[sNote],[nPunchType],[intTerminalType],[DTPunchDateTime_Original]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [tPData_PUNCHDATE_INC]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tPData_PUNCHDATE_INC] ON [dbo].[tPunchData]
(
	[DTPunchDate] ASC
)
INCLUDE([tpdID],[b_Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPunchData] ADD  CONSTRAINT [DF_tPunchData_b_Processed]  DEFAULT ((0)) FOR [b_Processed]
GO
ALTER TABLE [dbo].[tPunchData] ADD  CONSTRAINT [DF_tPunchData_nJobCodeID]  DEFAULT ((0)) FOR [nJobCodeID]
GO
ALTER TABLE [dbo].[tPunchData] ADD  CONSTRAINT [DF_tPunchData_sNote]  DEFAULT ('') FOR [sNote]
GO
ALTER TABLE [dbo].[tPunchData] ADD  CONSTRAINT [DF_tPunchData_nPunchType]  DEFAULT ((0)) FOR [nPunchType]
GO
