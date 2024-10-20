USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAccrualsComputationLog_V1]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAccrualsComputationLog_V1](
	[ID] [int] NULL,
	[strAccrualType] [nvarchar](50) NOT NULL,
	[strAccrualTypeDesc] [nvarchar](50) NULL,
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
	[intAccrualLogMode] [int] NOT NULL
) ON [PRIMARY]
GO
