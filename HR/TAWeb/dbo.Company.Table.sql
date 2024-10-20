USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyCode] [nvarchar](25) NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[CompanyDescription] [nvarchar](200) NULL,
	[EIN] [nvarchar](25) NULL,
	[ParentCompany] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](50) NULL,
	[Address1] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[CityId] [int] NULL,
	[StateId] [int] NULL,
	[ZipCode] [nvarchar](9) NULL,
	[ContactName] [nvarchar](50) NULL,
	[ContactTelephone] [nvarchar](max) NULL,
	[ContactEmail] [nvarchar](50) NULL,
	[ContactPosition] [nvarchar](50) NULL,
	[NAICS] [nvarchar](9) NULL,
	[DUNS] [nvarchar](max) NULL,
	[EmployerID] [nvarchar](9) NULL,
	[NameInLetters] [nvarchar](200) NULL,
	[SIC] [nvarchar](4) NULL,
	[PortalPictureFilePath] [nvarchar](max) NULL,
	[IsDefaultPortalPicture] [bit] NULL,
	[PortalWelcomeStatement] [nvarchar](max) NULL,
	[IsDefaultPortalStatement] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CompanyLogo] [varbinary](max) NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[DefaultLetterSigneeId] [int] NULL,
	[DefaultLetterTemplateId] [int] NULL,
 CONSTRAINT [PK_dbo.Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Company_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_dbo.Company_dbo.Client_ClientId]
GO
