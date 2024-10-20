USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tvisitor]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tvisitor](
	[id] [int] NULL,
	[name] [varchar](30) NULL,
	[reg_date] [varchar](12) NULL,
	[datelimit] [varchar](17) NULL,
	[timelimit] [varchar](8) NULL,
	[out_date] [varchar](12) NULL,
	[idno] [varchar](30) NULL,
	[contact] [varchar](50) NULL,
	[company] [varchar](30) NULL,
	[dept] [varchar](30) NULL,
	[phone] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[group_id] [smallint] NULL,
	[cantgate] [image] NULL,
	[timegate] [image] NULL,
	[validtype] [varchar](1) NULL,
	[pwd] [varchar](8) NULL,
	[cancard] [varchar](1) NULL,
	[cardnum] [varchar](20) NULL,
	[identify] [varchar](1) NULL,
	[seculevel] [varchar](1) NULL,
	[fpdata] [image] NULL,
	[fpimage] [image] NULL,
	[fpname] [image] NULL,
	[face] [image] NULL,
	[id_image] [image] NULL,
	[voice] [image] NULL,
	[remark] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
