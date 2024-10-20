USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensation]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nUserID] [int] NULL,
	[sAccrualType] [nvarchar](30) NULL,
	[nCompRulesID] [int] NULL,
	[dblAccruedHours] [float] NULL,
	[dEffectiveDate] [datetime] NULL,
	[nAccrualMode] [int] NULL,
	[sHash] [nvarchar](50) NULL,
	[dblAccrualDailyHours] [float] NULL,
	[sAccrualDays] [nvarchar](50) NULL,
 CONSTRAINT [PK_tUserCompensation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
