USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[DailyMealSales_Common]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyMealSales_Common](
	[DigitYear] [int] NULL,
	[NameMonth] [nvarchar](30) NULL,
	[MonthSort] [int] NULL,
	[SCHID] [bigint] NULL,
	[SchoolName] [varchar](60) NULL,
	[FreeElig] [int] NULL,
	[RedElig] [int] NULL,
	[PaidElig] [int] NULL,
	[AttendFactor] [numeric](10, 2) NULL,
	[SNPTotalMember] [numeric](10, 2) NULL,
	[SNPUNumber] [numeric](10, 2) NULL,
	[AttendAdjElig] [numeric](25, 4) NULL,
	[LunchServDays] [int] NULL,
	[BreakServDays] [int] NULL,
	[SnackServDays] [int] NULL
) ON [PRIMARY]
GO
