USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmailTemplate]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailTemplate](
	[EmailTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[EmailSubject] [nvarchar](50) NOT NULL,
	[EmailBody] [nvarchar](max) NULL,
	[EmailTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmailTemplate] PRIMARY KEY CLUSTERED 
(
	[EmailTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmailTemplate_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmailTemplate] CHECK CONSTRAINT [FK_dbo.EmailTemplate_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmailTemplate_dbo.EmailType_EmailTypeId] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[EmailTemplate] CHECK CONSTRAINT [FK_dbo.EmailTemplate_dbo.EmailType_EmailTypeId]
GO
