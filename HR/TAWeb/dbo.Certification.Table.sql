USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Certification]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certification](
	[CertificationId] [int] IDENTITY(1,1) NOT NULL,
	[CertificationName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[CertificationTypeId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Certification] PRIMARY KEY CLUSTERED 
(
	[CertificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Certification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Certification_dbo.CertificationType_CertificationTypeId] FOREIGN KEY([CertificationTypeId])
REFERENCES [dbo].[CertificationType] ([CertificationTypeId])
GO
ALTER TABLE [dbo].[Certification] CHECK CONSTRAINT [FK_dbo.Certification_dbo.CertificationType_CertificationTypeId]
GO
