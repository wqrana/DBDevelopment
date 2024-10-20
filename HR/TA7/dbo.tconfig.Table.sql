USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tconfig]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tconfig](
	[maxuser] [int] NULL,
	[minvid] [int] NULL,
	[maxvid] [int] NULL,
	[fpnum] [varchar](1) NULL,
	[autodn] [varchar](1) NULL,
	[dntime] [varchar](4) NULL,
	[autoup] [varchar](1) NULL,
	[groupid] [varchar](1) NULL,
	[gateid] [varchar](1) NULL,
	[userid] [varchar](1) NULL,
	[passwd] [varchar](1) NULL,
	[attend] [varchar](1) NULL,
	[tsockport] [int] NULL,
	[csockport] [int] NULL,
	[polltime] [int] NULL,
	[serverip] [varchar](20) NULL,
	[savemode] [varchar](1) NULL,
	[update_flag] [varchar](1) NULL,
	[latetime] [varchar](4) NULL,
	[lfdlevel] [varchar](1) NULL
) ON [PRIMARY]
GO
