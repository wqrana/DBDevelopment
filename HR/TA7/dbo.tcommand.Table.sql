USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tcommand]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcommand](
	[c_regtime] [varchar](14) NULL,
	[c_key] [int] NULL,
	[c_type] [varchar](1) NULL,
	[c_gid] [int] NULL,
	[c_time] [varchar](14) NULL,
	[c_retry] [int] NULL,
	[c_data] [image] NULL,
	[c_result] [varchar](1) NULL,
	[c_cmd] [varchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
