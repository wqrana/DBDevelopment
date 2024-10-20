USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPayCycleLog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPayCycleLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DTPayPeriodDate] [smalldatetime] NULL,
	[nPayWeekNum] [int] NULL,
	[nPayPeriodType] [int] NULL,
	[sPayPeriodType] [nvarchar](30) NULL,
	[sPeriodNote] [nvarchar](50) NULL,
	[nAdminID] [int] NULL,
	[sAdminName] [nvarchar](50) NULL,
	[DTProcessDate] [smalldatetime] NULL,
	[sStatus] [nvarchar](10) NULL,
	[nCompanyID] [int] NULL,
	[nDeptID] [int] NULL,
	[nJobTitleID] [int] NULL,
	[nEmployeeTypeID] [int] NULL,
 CONSTRAINT [PK_tPayCycleLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
