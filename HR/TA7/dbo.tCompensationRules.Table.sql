USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCompensationRules]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompensationRules](
	[ID] [int] NOT NULL,
	[sCompensationRuleName] [nvarchar](50) NULL,
	[sCompensationRuleDesc] [nvarchar](50) NULL,
	[sAccrualCodeID] [nvarchar](50) NULL,
	[sAccrualCodeUnavailableD] [nvarchar](50) NULL,
	[nAccrualPeriodType] [int] NULL,
	[dBeginningOfYear] [datetime] NULL,
	[nReferenceType] [int] NULL,
	[nAccumulationType] [int] NULL,
	[dblAccumulationMultiplier] [float] NULL,
	[nCompensationTiers] [int] NULL,
	[nUseYearsWorked] [int] NULL,
	[sAccrualTypeID] [nvarchar](50) NULL,
	[sAccrualTypeUnavailableID] [nvarchar](50) NULL,
 CONSTRAINT [PK_tCompensationRules] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
