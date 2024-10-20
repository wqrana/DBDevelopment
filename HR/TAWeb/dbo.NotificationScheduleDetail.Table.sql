USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[NotificationScheduleDetail]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationScheduleDetail](
	[NotificationScheduleDetailId] [int] IDENTITY(1,1) NOT NULL,
	[DaysBefore] [int] NOT NULL,
	[NotificationScheduleId] [int] NOT NULL,
	[NotificationMessageId] [int] NOT NULL,
	[ExcludeUser] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ExcludeSupervisor] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.NotificationScheduleDetail] PRIMARY KEY CLUSTERED 
(
	[NotificationScheduleDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationMessage_NotificationMessageId] FOREIGN KEY([NotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[NotificationScheduleDetail] CHECK CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationMessage_NotificationMessageId]
GO
ALTER TABLE [dbo].[NotificationScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[NotificationScheduleDetail] CHECK CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationSchedule_NotificationScheduleId]
GO
