USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[SupervisorCompany]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorCompany](
	[SupervisorCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorCompany] PRIMARY KEY CLUSTERED 
(
	[SupervisorCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupervisorCompany]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorCompany_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[SupervisorCompany] CHECK CONSTRAINT [FK_dbo.SupervisorCompany_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[SupervisorCompany]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorCompany_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorCompany] CHECK CONSTRAINT [FK_dbo.SupervisorCompany_dbo.UserInformation_UserInformationId]
GO
