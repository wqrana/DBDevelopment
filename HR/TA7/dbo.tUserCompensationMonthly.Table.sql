USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensationMonthly]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensationMonthly](
	[nUserID] [int] NOT NULL,
	[sAccrualType] [nvarchar](30) NOT NULL,
	[dblAccruedHours] [float] NULL,
	[dEffectiveDate] [datetime] NOT NULL,
	[dblAccrualDailyHours] [float] NULL,
	[sAccrualDays] [nvarchar](50) NULL,
	[dPeriodStartDate] [datetime] NULL,
	[dPeriodEndDate] [datetime] NULL,
	[dblAccrualComputedHours] [float] NULL,
 CONSTRAINT [PK_tUserCompensationDaily] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC,
	[sAccrualType] ASC,
	[dEffectiveDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
