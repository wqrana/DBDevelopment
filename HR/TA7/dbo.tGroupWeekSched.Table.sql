USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tGroupWeekSched]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGroupWeekSched](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NULL,
	[DayofWeek] [int] NULL,
	[bRight] [bit] NULL,
	[BeginHr] [smalldatetime] NULL,
	[EndHr] [smalldatetime] NULL,
	[bOvernight] [bit] NULL,
 CONSTRAINT [PK_tGroupWeekSched] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
