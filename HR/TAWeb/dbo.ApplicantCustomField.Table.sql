USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantCustomField]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantCustomField](
	[ApplicantCustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldId] [int] NOT NULL,
	[CustomFieldValue] [nvarchar](500) NULL,
	[CustomFieldNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantCustomField] PRIMARY KEY CLUSTERED 
(
	[ApplicantCustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.ApplicantInformation_ApplicantInformationId] FOREIGN KEY([ApplicantInformationId])
REFERENCES [dbo].[ApplicantInformation] ([ApplicantInformationId])
GO
ALTER TABLE [dbo].[ApplicantCustomField] CHECK CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.ApplicantInformation_ApplicantInformationId]
GO
ALTER TABLE [dbo].[ApplicantCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.CustomField_CustomFieldId] FOREIGN KEY([CustomFieldId])
REFERENCES [dbo].[CustomField] ([CustomFieldId])
GO
ALTER TABLE [dbo].[ApplicantCustomField] CHECK CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.CustomField_CustomFieldId]
GO
