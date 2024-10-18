USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tauditlog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tauditlog](
	[seqno] [int] NOT NULL,
	[id] [int] NULL,
	[idtype] [varchar](1) NULL,
	[rid] [int] NULL,
	[menu] [varchar](1) NULL,
	[mode] [varchar](1) NULL,
	[rdate] [varchar](12) NULL
) ON [PRIMARY]
GO
