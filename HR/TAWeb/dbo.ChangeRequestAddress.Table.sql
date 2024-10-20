USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChangeRequestAddress]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestAddress](
	[ChangeRequestAddressId] [int] IDENTITY(1,1) NOT NULL,
	[UserContactInformationId] [int] NOT NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[CityId] [int] NULL,
	[StateId] [int] NULL,
	[CountryId] [int] NULL,
	[ZipCode] [nvarchar](10) NULL,
	[NewAddress1] [nvarchar](50) NULL,
	[NewAddress2] [nvarchar](50) NULL,
	[NewCityId] [int] NULL,
	[NewStateId] [int] NULL,
	[NewCountryId] [int] NULL,
	[NewZipCode] [nvarchar](10) NULL,
	[AddressType] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChangeRequestAddress] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_CityId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_NewCityId] FOREIGN KEY([NewCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_NewCityId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_NewCountryId] FOREIGN KEY([NewCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_NewCountryId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_NewStateId] FOREIGN KEY([NewStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_NewStateId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_StateId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserContactInformation_UserContactInformationId] FOREIGN KEY([UserContactInformationId])
REFERENCES [dbo].[UserContactInformation] ([UserContactInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserContactInformation_UserContactInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserInformation_UserInformationId]
GO
