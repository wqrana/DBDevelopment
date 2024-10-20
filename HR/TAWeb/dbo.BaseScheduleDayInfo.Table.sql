USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[BaseScheduleDayInfo]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseScheduleDayInfo](
	[BaseScheduleDayInfoId] [int] IDENTITY(1,1) NOT NULL,
	[BaseScheduleId] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[NoOfPunch] [int] NOT NULL,
	[IsRight] [bit] NOT NULL,
	[TimeIn1] [datetime] NULL,
	[TimeOut1] [datetime] NULL,
	[TimeIn2] [datetime] NULL,
	[TimeOut2] [datetime] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.BaseScheduleDayInfo] PRIMARY KEY CLUSTERED 
(
	[BaseScheduleDayInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BaseScheduleDayInfo]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BaseScheduleDayInfo_dbo.BaseSchedule_BaseScheduleId] FOREIGN KEY([BaseScheduleId])
REFERENCES [dbo].[BaseSchedule] ([BaseScheduleId])
GO
ALTER TABLE [dbo].[BaseScheduleDayInfo] CHECK CONSTRAINT [FK_dbo.BaseScheduleDayInfo_dbo.BaseSchedule_BaseScheduleId]
GO
