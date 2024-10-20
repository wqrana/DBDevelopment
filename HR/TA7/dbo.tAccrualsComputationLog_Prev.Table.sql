USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAccrualsComputationLog_Prev]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAccrualsComputationLog_Prev](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[strAccrualType] [nvarchar](50) NULL,
	[strAccrualTypeDesc] [nvarchar](50) NULL,
	[dtEffectiveMonth] [smalldatetime] NULL,
	[dtPeriodStartDate] [smalldatetime] NOT NULL,
	[dtPeriodEndDate] [smalldatetime] NULL,
	[intUserID] [int] NULL,
	[strUserName] [nvarchar](50) NULL,
	[dblHoursWorked] [float] NULL,
	[dblPreviousAccrualHours] [float] NULL,
	[dblCurrentAccrualHours] [float] NULL,
	[dblAccruedHours] [float] NULL,
	[intAdminID] [int] NULL,
	[strAdminName] [nvarchar](50) NULL,
	[dblEffectivePayRate] [nchar](10) NULL,
	[dtAccrualsComputeDate] [smalldatetime] NULL,
	[intAccrualLogMode] [int] NULL
) ON [PRIMARY]
GO
