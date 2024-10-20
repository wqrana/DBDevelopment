USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[DateCalendar]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateCalendar](
	[TheDate] [date] NULL,
	[TheDay] [int] NULL,
	[TheDaySuffix] [char](2) NULL,
	[TheDayName] [nvarchar](30) NULL,
	[TheDayOfWeek] [int] NULL,
	[TheDayOfWeekInMonth] [tinyint] NULL,
	[TheDayOfYear] [int] NULL,
	[IsWeekend] [int] NOT NULL,
	[TheWeek] [int] NULL,
	[TheISOweek] [int] NULL,
	[TheFirstOfWeek] [date] NULL,
	[TheLastOfWeek] [date] NULL,
	[TheWeekOfMonth] [tinyint] NULL,
	[TheMonth] [int] NULL,
	[TheMonthName] [nvarchar](30) NULL,
	[TheFirstOfMonth] [date] NULL,
	[TheLastOfMonth] [date] NULL,
	[TheFirstOfNextMonth] [date] NULL,
	[TheLastOfNextMonth] [date] NULL,
	[TheQuarter] [int] NULL,
	[TheFirstOfQuarter] [date] NULL,
	[TheLastOfQuarter] [date] NULL,
	[TheYear] [int] NULL,
	[TheISOYear] [int] NULL,
	[TheFirstOfYear] [date] NULL,
	[TheLastOfYear] [date] NULL,
	[IsLeapYear] [bit] NULL,
	[Has53Weeks] [int] NOT NULL,
	[Has53ISOWeeks] [int] NOT NULL,
	[MMYYYY] [char](6) NULL,
	[Style101] [char](10) NULL,
	[Style103] [char](10) NULL,
	[Style112] [char](8) NULL,
	[Style120] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [PK_DateCalendar]    Script Date: 10/18/2024 8:10:08 PM ******/
CREATE UNIQUE CLUSTERED INDEX [PK_DateCalendar] ON [dbo].[DateCalendar]
(
	[TheDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
