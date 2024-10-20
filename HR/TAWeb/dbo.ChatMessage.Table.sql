USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChatMessage]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessage](
	[ChatMessageId] [int] IDENTITY(1,1) NOT NULL,
	[ChatConversationParticipantId] [int] NOT NULL,
	[ChatConversationId] [int] NOT NULL,
	[ChatMessageText] [nvarchar](max) NULL,
	[ChatDocumentFilePath] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatMessage] PRIMARY KEY CLUSTERED 
(
	[ChatMessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChatMessage]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversation_ChatConversationId] FOREIGN KEY([ChatConversationId])
REFERENCES [dbo].[ChatConversation] ([ChatConversationId])
GO
ALTER TABLE [dbo].[ChatMessage] CHECK CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversation_ChatConversationId]
GO
ALTER TABLE [dbo].[ChatMessage]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversationParticipant_ChatConversationParticipantId] FOREIGN KEY([ChatConversationParticipantId])
REFERENCES [dbo].[ChatConversationParticipant] ([ChatConversationParticipantId])
GO
ALTER TABLE [dbo].[ChatMessage] CHECK CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversationParticipant_ChatConversationParticipantId]
GO
