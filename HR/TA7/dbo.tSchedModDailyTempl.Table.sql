USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tSchedModDailyTempl]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSchedModDailyTempl](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[sDailyTemplateName] [nvarchar](50) NULL,
	[sNote] [nvarchar](50) NULL,
	[dPunchIn1] [datetime] NULL,
	[dPunchOut1] [datetime] NULL,
	[dPunchIn2] [datetime] NULL,
	[dPunchOut2] [datetime] NULL,
	[dPunchIn3] [datetime] NULL,
	[dPunchOut3] [datetime] NULL,
	[dPunchIn4] [datetime] NULL,
	[dPunchOut4] [datetime] NULL,
	[nWorkDayType] [int] NULL,
	[dblDayHours] [float] NULL,
	[nSupervisorID] [int] NULL,
	[nPunchNum] [int] NULL,
	[nCompanyID] [int] NULL,
 CONSTRAINT [PK_tSchedModDailyTempl] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
