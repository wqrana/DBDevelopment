USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PositionCredential]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionCredential](
	[PositionCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[CredentialId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsRequired] [bit] NULL,
 CONSTRAINT [PK_dbo.PositionCredential] PRIMARY KEY CLUSTERED 
(
	[PositionCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PositionCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[PositionCredential] CHECK CONSTRAINT [FK_dbo.PositionCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[PositionCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionCredential_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionCredential] CHECK CONSTRAINT [FK_dbo.PositionCredential_dbo.Position_PositionId]
GO
