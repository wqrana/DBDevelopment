USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserContactInformation]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserContactInformation](
	[UserContactInformationId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[LoginEmail] [nvarchar](50) NULL,
	[HomeAddress1] [nvarchar](50) NULL,
	[HomeAddress2] [nvarchar](50) NULL,
	[HomeCityId] [int] NULL,
	[HomeStateId] [int] NULL,
	[HomeCountryId] [int] NULL,
	[HomeZipCode] [nvarchar](10) NULL,
	[MailingAddress1] [nvarchar](50) NULL,
	[MailingAddress2] [nvarchar](50) NULL,
	[MailingCityId] [int] NULL,
	[MailingStateId] [int] NULL,
	[MailingCountryId] [int] NULL,
	[MailingZipCode] [nvarchar](10) NULL,
	[HomeNumber] [nvarchar](20) NULL,
	[CelNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[OtherNumber] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](50) NULL,
	[PersonalEmail] [nvarchar](50) NULL,
	[OtherEmail] [nvarchar](50) NULL,
	[WorkNumber] [nvarchar](20) NULL,
	[WorkExtension] [nvarchar](10) NULL,
	[IsSameHomeAddress] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[NotificationEmail] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.UserContactInformation] PRIMARY KEY CLUSTERED 
(
	[UserContactInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_HomeCityId] FOREIGN KEY([HomeCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_HomeCityId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_MailingCityId] FOREIGN KEY([MailingCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_MailingCityId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_HomeCountryId] FOREIGN KEY([HomeCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_HomeCountryId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_MailingCountryId] FOREIGN KEY([MailingCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_MailingCountryId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_HomeStateId] FOREIGN KEY([HomeStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_HomeStateId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_MailingStateId] FOREIGN KEY([MailingStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_MailingStateId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.UserInformation_UserInformationId]
GO
