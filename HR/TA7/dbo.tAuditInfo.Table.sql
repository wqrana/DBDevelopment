USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAuditInfo]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAuditInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DTTimeStamp] [datetime] NULL,
	[nAdminID] [int] NULL,
	[sAdminName] [nvarchar](30) NULL,
	[sAdminAction] [nvarchar](30) NULL,
	[sRecordAffected] [nvarchar](30) NULL,
	[nUserIDAffected] [int] NULL,
	[sUserNameAffected] [nvarchar](30) NULL,
	[sFieldName] [nvarchar](30) NULL,
	[PrevValue] [nvarchar](30) NULL,
	[NewValue] [nvarchar](30) NULL,
	[nWeekID] [bigint] NULL,
	[sNote] [nvarchar](500) NULL,
 CONSTRAINT [PK_tAuditInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexAuditInfo_UseridDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexAuditInfo_UseridDate] ON [dbo].[tAuditInfo]
(
	[DTTimeStamp] ASC
)
INCLUDE([ID],[nAdminID],[sAdminName],[sAdminAction],[sRecordAffected],[nUserIDAffected],[sUserNameAffected],[sFieldName],[PrevValue],[NewValue],[nWeekID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tAuditInfo_sRecordAffected]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tAuditInfo_sRecordAffected] ON [dbo].[tAuditInfo]
(
	[sRecordAffected] ASC
)
INCLUDE([ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
