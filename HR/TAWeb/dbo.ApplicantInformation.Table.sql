USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantInformation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInformation](
	[ApplicantInformationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantExternalId] [int] NULL,
	[FirstName] [nvarchar](30) NULL,
	[MiddleInitial] [nvarchar](1) NULL,
	[FirstLastName] [nvarchar](30) NULL,
	[SecondLastName] [nvarchar](30) NULL,
	[ShortFullName] [nvarchar](50) NULL,
	[GenderId] [int] NULL,
	[DisabilityId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[SSNEncrypted] [nvarchar](512) NULL,
	[PictureFilePath] [nvarchar](512) NULL,
	[ResumeFilePath] [nvarchar](512) NULL,
	[CreatedBy] [int] NULL,
	[ApplicantStatusId] [int] NULL,
	[UserInformationId] [int] NULL,
	[JobPostingDetailId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInformation] PRIMARY KEY CLUSTERED 
(
	[ApplicantInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.ApplicantStatus_ApplicantStatusId] FOREIGN KEY([ApplicantStatusId])
REFERENCES [dbo].[ApplicantStatus] ([ApplicantStatusId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.ApplicantStatus_ApplicantStatusId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Disability_DisabilityId] FOREIGN KEY([DisabilityId])
REFERENCES [dbo].[Disability] ([DisabilityId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Disability_DisabilityId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.JobPostingDetail_JobPostingDetailId] FOREIGN KEY([JobPostingDetailId])
REFERENCES [dbo].[JobPostingDetail] ([JobPostingDetailId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.JobPostingDetail_JobPostingDetailId]
GO
