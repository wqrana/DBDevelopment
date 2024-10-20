USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserChatAttachment]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserChatAttachment](
	[UserChatAttachmentId] [int] NOT NULL,
	[Url] [nvarchar](max) NULL,
	[Id] [nvarchar](max) NULL,
	[RoomKey] [int] NOT NULL,
	[OwnerKey] [int] NOT NULL,
	[When] [datetimeoffset](7) NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[ContentType] [nvarchar](max) NULL,
	[Size] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserChatAttachment] ADD  CONSTRAINT [DF_UserChatAttachment_Size]  DEFAULT ((0)) FOR [Size]
GO
