USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChatConversationParticipant]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatConversationParticipant](
	[ChatConversationParticipantId] [int] IDENTITY(1,1) NOT NULL,
	[ChatConversationId] [int] NOT NULL,
	[ParticipantId] [int] NOT NULL,
	[LastMessageReadTime] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatConversationParticipant] PRIMARY KEY CLUSTERED 
(
	[ChatConversationParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChatConversationParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.ChatConversation_ChatConversationId] FOREIGN KEY([ChatConversationId])
REFERENCES [dbo].[ChatConversation] ([ChatConversationId])
GO
ALTER TABLE [dbo].[ChatConversationParticipant] CHECK CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.ChatConversation_ChatConversationId]
GO
ALTER TABLE [dbo].[ChatConversationParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.UserInformation_ParticipantId] FOREIGN KEY([ParticipantId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChatConversationParticipant] CHECK CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.UserInformation_ParticipantId]
GO
