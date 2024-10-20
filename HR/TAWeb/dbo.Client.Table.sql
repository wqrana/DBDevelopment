USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[ClientId] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NULL,
	[CityId] [int] NULL,
	[ZipCode] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[WebSite] [nvarchar](50) NULL,
	[ContactName] [nvarchar](50) NULL,
	[PayrollName] [nvarchar](50) NULL,
	[PayrollAddress1] [nvarchar](50) NULL,
	[PayrollAddress2] [nvarchar](50) NULL,
	[PayrollCountryId] [int] NULL,
	[PayrollStateId] [int] NULL,
	[PayrollCityId] [int] NULL,
	[PayrollZipCode] [nvarchar](50) NULL,
	[EIN] [nvarchar](50) NULL,
	[PayrollFax] [nvarchar](50) NULL,
	[PayrollContactName] [nvarchar](50) NULL,
	[PayrollContactTitle] [nvarchar](50) NULL,
	[PayrollContactPhone] [nvarchar](50) NULL,
	[PayrollEmail] [nvarchar](50) NULL,
	[CompanyStartDate] [date] NULL,
	[SICCode] [nvarchar](50) NULL,
	[NAICSCode] [nvarchar](50) NULL,
	[SeguroChoferilAccount] [nvarchar](50) NULL,
	[DepartamentoDelTrabajoAccount] [nvarchar](50) NULL,
	[DepartamentoDelTrabajoRate] [decimal](18, 5) NULL,
	[IsTimeAideWindow] [bit] NOT NULL,
	[DBServerName] [nvarchar](max) NULL,
	[DBName] [nvarchar](max) NULL,
	[DBUser] [nvarchar](max) NULL,
	[DBPassword] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Client] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.City_CityId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.City_PayrollCityId] FOREIGN KEY([PayrollCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.City_PayrollCityId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.Country_PayrollCountryId] FOREIGN KEY([PayrollCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.Country_PayrollCountryId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.State_PayrollStateId] FOREIGN KEY([PayrollStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.State_PayrollStateId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.State_StateId]
GO
