USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tgroup]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tgroup](
	[id] [smallint] NULL,
	[name] [varchar](30) NULL,
	[reg_date] [varchar](12) NULL,
	[timelimit] [varchar](8) NULL,
	[gate_id] [image] NULL,
	[remark] [varchar](50) NULL,
	[bWeekSchedule] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
