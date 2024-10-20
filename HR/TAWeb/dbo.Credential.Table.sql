USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Credential]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credential](
	[CredentialId] [int] IDENTITY(1,1) NOT NULL,
	[CredentialName] [nvarchar](1000) NULL,
	[CredentialDescription] [nvarchar](1000) NULL,
	[NotificationScheduleId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[SelfServiceDisplay] [bit] NOT NULL,
	[SelfServiceUpload] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Credential] PRIMARY KEY CLUSTERED 
(
	[CredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Credential_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[Credential] CHECK CONSTRAINT [FK_dbo.Credential_dbo.NotificationSchedule_NotificationScheduleId]
GO
