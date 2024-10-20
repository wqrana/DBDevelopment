USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[HolidayCalendar]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HolidayCalendar](
	[TheDate] [date] NOT NULL,
	[HolidayText] [nvarchar](255) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [CIX_HolidayCalendar]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE CLUSTERED INDEX [CIX_HolidayCalendar] ON [dbo].[HolidayCalendar]
(
	[TheDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HolidayCalendar]  WITH CHECK ADD  CONSTRAINT [FK_DateCalendar] FOREIGN KEY([TheDate])
REFERENCES [dbo].[DateCalendar] ([TheDate])
GO
ALTER TABLE [dbo].[HolidayCalendar] CHECK CONSTRAINT [FK_DateCalendar]
GO
