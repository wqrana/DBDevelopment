USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[HaciendaTaxDepositSchedule]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HaciendaTaxDepositSchedule](
	[HaciendaTaxDepositScheduleId] [int] NOT NULL,
	[HaciendaTaxDepositScheduleName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_HaciendaTaxDepositSchedule] PRIMARY KEY CLUSTERED 
(
	[HaciendaTaxDepositScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
