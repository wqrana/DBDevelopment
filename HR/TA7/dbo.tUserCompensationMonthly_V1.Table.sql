USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensationMonthly_V1]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensationMonthly_V1](
	[nUserID] [int] NOT NULL,
	[sAccrualType] [nvarchar](30) NOT NULL,
	[dblAccruedHours] [float] NULL,
	[dEffectiveDate] [datetime] NOT NULL,
	[dblAccrualDailyHours] [float] NULL,
	[sAccrualDays] [nvarchar](50) NULL,
	[dPeriodStartDate] [datetime] NULL,
	[dPeriodEndDate] [datetime] NULL,
	[dblAccrualComputedHours] [float] NULL
) ON [PRIMARY]
GO
