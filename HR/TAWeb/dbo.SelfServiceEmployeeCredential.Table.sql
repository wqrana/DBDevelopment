USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[SelfServiceEmployeeCredential]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SelfServiceEmployeeCredential](
	[SelfServiceEmployeeCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCredentialId] [int] NULL,
	[EmployeeCredentialName] [nvarchar](max) NULL,
	[EmployeeCredentialDescription] [nvarchar](200) NULL,
	[IssueDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[Note] [nvarchar](200) NULL,
	[DocumentName] [nvarchar](500) NULL,
	[OriginalDocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[DocumentFile] [image] NULL,
	[CredentialId] [int] NOT NULL,
	[ExpirationDateRequired] [int] NULL,
	[IsRequired] [bit] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CredentialTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.SelfServiceEmployeeCredential] PRIMARY KEY CLUSTERED 
(
	[SelfServiceEmployeeCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.EmployeeCredential_EmployeeCredentialId] FOREIGN KEY([EmployeeCredentialId])
REFERENCES [dbo].[EmployeeCredential] ([EmployeeCredentialId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.EmployeeCredential_EmployeeCredentialId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.UserInformation_UserInformationId]
GO
