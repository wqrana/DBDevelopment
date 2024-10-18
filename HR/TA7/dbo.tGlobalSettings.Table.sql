USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tGlobalSettings]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGlobalSettings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[dblNextDayHours] [float] NULL,
	[nProcessType] [int] NULL,
	[dblPrimaryLunchStart] [float] NULL,
	[dblPrimaryLunchEnd] [float] NULL,
	[dblSecondayLunchStart] [float] NULL,
	[dblSecondayLunchEnd] [float] NULL,
	[nlNextPunchMin] [int] NULL,
	[nTimeOutPeriod] [int] NULL,
	[nTimeOutPeriodMin] [int] NULL,
 CONSTRAINT [PK_tGlobalSettings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
