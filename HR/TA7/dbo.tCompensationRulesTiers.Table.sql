USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCompensationRulesTiers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompensationRulesTiers](
	[ID] [int] NOT NULL,
	[nCompRulesID] [int] NOT NULL,
	[nTierNum] [int] NOT NULL,
	[nYearsWorkedType] [int] NULL,
	[dblYearsWorkedFrom] [float] NULL,
	[dblYearsWorkedTo] [float] NULL,
	[nWaitingPeriodType] [int] NULL,
	[nWaitingPeriodLength] [int] NULL,
	[nCarryOverMaxType] [int] NULL,
	[dblCarryOverMaxHours] [float] NULL,
	[nAllowedMaxHoursType] [int] NULL,
	[dblAllowedMaxHours] [float] NULL,
	[nAlertHoursType] [int] NULL,
	[dblAlertHours] [float] NULL,
	[nResetAccruedHoursType] [int] NULL,
	[nMinWorkedHoursTiersNum] [int] NULL,
	[sTierDescription] [nvarchar](50) NULL,
	[nMinWorkedHoursType] [int] NULL,
	[dblAccrualHours] [float] NULL,
	[sAccrualTypeExcess] [varchar](50) NULL,
	[dblResetHours] [float] NULL,
 CONSTRAINT [PK_tCompensationRulesTiers_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
