USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [varchar](50) NOT NULL,
	[LocationDescription] [varchar](200) NULL,
	[Address] [nvarchar](max) NULL,
	[Address2] [nvarchar](100) NULL,
	[LocationCityId] [int] NULL,
	[LocationStateId] [int] NULL,
	[LocationCountryId] [int] NULL,
	[ZipCode] [nvarchar](max) NULL,
	[PhysicalAddress1] [nvarchar](max) NULL,
	[PhysicalAddress2] [nvarchar](100) NULL,
	[PhysicalCityId] [int] NULL,
	[PhysicalStateId] [int] NULL,
	[PhysicalZipCode] [nvarchar](9) NULL,
	[PhoneNumber1] [nvarchar](10) NULL,
	[ExtensionNumber1] [nvarchar](10) NULL,
	[PhoneNumber2] [nvarchar](10) NULL,
	[ExtensionNumber2] [nvarchar](10) NULL,
	[PhoneNumber3] [nvarchar](10) NULL,
	[ExtensionNumber3] [nvarchar](10) NULL,
	[FaxNumber] [nvarchar](10) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Location] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.City_CityId] FOREIGN KEY([LocationCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.City_CityId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.Country_CountryId] FOREIGN KEY([LocationCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.State_StateId] FOREIGN KEY([LocationStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.State_StateId]
GO
