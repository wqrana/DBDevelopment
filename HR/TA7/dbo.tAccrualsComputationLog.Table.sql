USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAccrualsComputationLog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAccrualsComputationLog](
	[ID] [int] NULL,
	[strAccrualType] [nvarchar](50) NOT NULL,
	[strAccrualTypeDesc] [nvarchar](50) NOT NULL,
	[dtEffectiveMonth] [datetime] NOT NULL,
	[dtPeriodStartDate] [datetime] NULL,
	[dtPeriodEndDate] [datetime] NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[dblHoursWorked] [float] NULL,
	[dblPreviousAccrualHours] [float] NULL,
	[dblCurrentAccrualHours] [float] NULL,
	[dblAccruedHours] [float] NULL,
	[intAdminID] [int] NULL,
	[strAdminName] [nvarchar](50) NULL,
	[dblEffectivePayRate] [nchar](10) NULL,
	[dtAccrualsComputeDate] [datetime] NULL,
	[intAccrualLogMode] [int] NOT NULL,
 CONSTRAINT [PK_tAccrualsComputationLogV2] PRIMARY KEY CLUSTERED 
(
	[strAccrualType] ASC,
	[strAccrualTypeDesc] ASC,
	[dtEffectiveMonth] ASC,
	[intUserID] ASC,
	[intAccrualLogMode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [indexACL_AccrualtypeUseridMode]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexACL_AccrualtypeUseridMode] ON [dbo].[tAccrualsComputationLog]
(
	[strAccrualType] ASC,
	[intUserID] ASC,
	[intAccrualLogMode] ASC
)
INCLUDE([dtEffectiveMonth]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tAccrualsComputationLog_strAccrualType_intUserID_intAccrualLogMode]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tAccrualsComputationLog_strAccrualType_intUserID_intAccrualLogMode] ON [dbo].[tAccrualsComputationLog]
(
	[strAccrualType] ASC,
	[intUserID] ASC,
	[intAccrualLogMode] ASC
)
INCLUDE([dtPeriodStartDate],[dtPeriodEndDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tAccrualsComputationLog] ADD  CONSTRAINT [DF_tAccrualsComputationLog_strAccrualTypeDesc]  DEFAULT (N'') FOR [strAccrualTypeDesc]
GO
