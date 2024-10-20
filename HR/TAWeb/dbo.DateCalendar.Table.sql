USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[DateCalendar]    Script Date: 10/18/2024 8:30:43 PM ******/
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
