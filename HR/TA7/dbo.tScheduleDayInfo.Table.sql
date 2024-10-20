USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tScheduleDayInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tScheduleDayInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nSchedID] [int] NULL,
	[nDayofWeek] [int] NULL,
	[bRight] [bit] NULL,
	[bOvernight] [bit] NULL,
	[dIn1Hr] [smalldatetime] NULL,
	[dOut1Hr] [smalldatetime] NULL,
	[dIn2Hr] [smalldatetime] NULL,
	[dOut2Hr] [smalldatetime] NULL,
	[dIn3Hr] [smalldatetime] NULL,
	[dOut3Hr] [smalldatetime] NULL,
	[dIn4Hr] [smalldatetime] NULL,
	[dOut4Hr] [smalldatetime] NULL,
	[nJobCodeID] [int] NULL,
 CONSTRAINT [PK_tScheduleDayInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
