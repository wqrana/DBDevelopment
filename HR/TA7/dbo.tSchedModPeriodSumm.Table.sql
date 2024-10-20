USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tSchedModPeriodSumm]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSchedModPeriodSumm](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nUserID] [int] NULL,
	[sUserName] [nvarchar](50) NULL,
	[sWeekID] [nvarchar](30) NULL,
	[sNote] [nvarchar](50) NULL,
	[dStartDate] [datetime] NULL,
	[dEndDate] [datetime] NULL,
	[dblPeriodHours] [float] NULL,
	[nSupervisorID] [int] NULL,
	[dModifiedDate] [datetime] NULL,
	[nPayPeriodType] [int] NULL,
	[nPayWeekNum] [int] NULL,
 CONSTRAINT [PK_tSchedModPeriodSumm] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [tSMPS_USERID_STARTDATE_ENDDATE]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [tSMPS_USERID_STARTDATE_ENDDATE] ON [dbo].[tSchedModPeriodSumm]
(
	[nUserID] ASC,
	[dStartDate] ASC,
	[dEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
