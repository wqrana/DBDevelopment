USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeCredential]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCredential](
	[EmployeeCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCredentialName] [nvarchar](max) NULL,
	[EmployeeCredentialDescription] [nvarchar](200) NULL,
	[IssueDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[Note] [nvarchar](200) NULL,
	[DocumentName] [nvarchar](500) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[DocumentFile] [image] NULL,
	[CredentialId] [int] NOT NULL,
	[ExpirationDateRequired] [int] NULL,
	[IsRequired] [bit] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CredentialTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeCredential] PRIMARY KEY CLUSTERED 
(
	[EmployeeCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[EmployeeCredential] CHECK CONSTRAINT [FK_dbo.EmployeeCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[EmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCredential_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCredential] CHECK CONSTRAINT [FK_dbo.EmployeeCredential_dbo.UserInformation_UserInformationId]
GO
