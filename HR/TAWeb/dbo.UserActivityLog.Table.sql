USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserActivityLog]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserActivityLog](
	[UserActivityLog] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[IPAddress] [nvarchar](150) NULL,
	[BrowserInformation] [nvarchar](max) NULL,
	[DeviceInformation] [nvarchar](max) NULL,
	[OsInformation] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserActivityLog] PRIMARY KEY CLUSTERED 
(
	[UserActivityLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserActivityLog_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserActivityLog] CHECK CONSTRAINT [FK_dbo.UserActivityLog_dbo.UserInformation_UserInformationId]
GO
