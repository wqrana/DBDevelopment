USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCompensationWorkedHoursTiers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompensationWorkedHoursTiers](
	[nCompRulesTiersID] [int] NOT NULL,
	[nTierNum] [int] NOT NULL,
	[nCompRulesID] [int] NULL,
	[dblTierWorkedHoursMin] [float] NOT NULL,
	[dblTierWorkedHoursMax] [float] NULL,
	[dblAccrualHours] [float] NULL,
	[sTierDescription] [nvarchar](50) NULL,
 CONSTRAINT [PK_tCompensationWorkedHoursTiers] PRIMARY KEY CLUSTERED 
(
	[nCompRulesTiersID] ASC,
	[nTierNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
