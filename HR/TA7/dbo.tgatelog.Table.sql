USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tgatelog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tgatelog](
	[e_date] [varchar](8) NULL,
	[e_time] [varchar](6) NULL,
	[id] [int] NULL,
	[bstatus] [varchar](1) NULL
) ON [PRIMARY]
GO
