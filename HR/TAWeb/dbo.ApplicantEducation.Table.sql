USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantEducation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantEducation](
	[ApplicantEducationId] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [nvarchar](max) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Note] [nvarchar](max) NULL,
	[DateCompleted] [datetime] NOT NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[DegreeId] [int] NOT NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantEducation] PRIMARY KEY CLUSTERED 
(
	[ApplicantEducationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantEducation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEducation_dbo.Degree_DegreeId] FOREIGN KEY([DegreeId])
REFERENCES [dbo].[Degree] ([DegreeId])
GO
ALTER TABLE [dbo].[ApplicantEducation] CHECK CONSTRAINT [FK_dbo.ApplicantEducation_dbo.Degree_DegreeId]
GO
