USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[SelfServiceEmployeeDocument]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SelfServiceEmployeeDocument](
	[SelfServiceEmployeeDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeDocumentId] [int] NULL,
	[DocumentId] [int] NOT NULL,
	[DocumentName] [nvarchar](250) NOT NULL,
	[OriginalDocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](250) NULL,
	[DocumentNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SelfServiceEmployeeDocument] PRIMARY KEY CLUSTERED 
(
	[SelfServiceEmployeeDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.Document_DocumentId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.EmployeeDocument_EmployeeDocumentId] FOREIGN KEY([EmployeeDocumentId])
REFERENCES [dbo].[EmployeeDocument] ([EmployeeDocumentId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.EmployeeDocument_EmployeeDocumentId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.UserInformation_UserInformationId]
GO
