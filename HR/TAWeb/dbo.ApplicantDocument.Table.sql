USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantDocument]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantDocument](
	[ApplicantDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[DocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](250) NULL,
	[DocumentNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantDocument] PRIMARY KEY CLUSTERED 
(
	[ApplicantDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantDocument_dbo.ApplicantInformation_ApplicantInformationId] FOREIGN KEY([ApplicantInformationId])
REFERENCES [dbo].[ApplicantInformation] ([ApplicantInformationId])
GO
ALTER TABLE [dbo].[ApplicantDocument] CHECK CONSTRAINT [FK_dbo.ApplicantDocument_dbo.ApplicantInformation_ApplicantInformationId]
GO
ALTER TABLE [dbo].[ApplicantDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantDocument_dbo.Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[ApplicantDocument] CHECK CONSTRAINT [FK_dbo.ApplicantDocument_dbo.Document_DocumentId]
GO
