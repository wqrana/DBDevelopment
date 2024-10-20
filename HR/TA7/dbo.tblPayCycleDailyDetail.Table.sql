USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayCycleDailyDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayCycleDailyDetail](
	[e_id] [int] NOT NULL,
	[DTPunchDate] [smalldatetime] NOT NULL,
	[dblHours] [float] NOT NULL,
	[sType] [nvarchar](30) NOT NULL,
	[nWeekID] [bigint] NOT NULL,
	[nPayWeekNum] [int] NOT NULL,
 CONSTRAINT [PK_tblPayCycleDailyDetail] PRIMARY KEY CLUSTERED 
(
	[e_id] ASC,
	[DTPunchDate] ASC,
	[sType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
