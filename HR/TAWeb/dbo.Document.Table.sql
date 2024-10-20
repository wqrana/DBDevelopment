USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [nvarchar](500) NOT NULL,
	[DocumentDescription] [nvarchar](1000) NULL,
	[IsExpirable] [bit] NOT NULL,
	[NotificationScheduleId] [int] NULL,
	[DocumentRequiredById] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[SelfServiceUpload] [bit] NOT NULL,
	[SelfServiceDisplay] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Document_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Document_dbo.NotificationSchedule_NotificationScheduleId]
GO
