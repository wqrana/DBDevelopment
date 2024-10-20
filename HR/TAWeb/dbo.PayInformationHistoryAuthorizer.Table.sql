USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PayInformationHistoryAuthorizer]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayInformationHistoryAuthorizer](
	[PayInformationHistoryAuthorizerId] [int] IDENTITY(1,1) NOT NULL,
	[AuthorizeById] [int] NULL,
	[PayInformationHistoryId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayInformationHistoryAuthorizer] PRIMARY KEY CLUSTERED 
(
	[PayInformationHistoryAuthorizerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.PayInformationHistory_PayInformationHistoryId] FOREIGN KEY([PayInformationHistoryId])
REFERENCES [dbo].[PayInformationHistory] ([PayInformationHistoryId])
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer] CHECK CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.PayInformationHistory_PayInformationHistoryId]
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.UserInformation_AuthorizeById] FOREIGN KEY([AuthorizeById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer] CHECK CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.UserInformation_AuthorizeById]
GO
