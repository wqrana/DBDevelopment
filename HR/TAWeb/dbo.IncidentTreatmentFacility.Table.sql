USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[IncidentTreatmentFacility]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentTreatmentFacility](
	[IncidentTreatmentFacilityId] [int] IDENTITY(1,1) NOT NULL,
	[TreatmentFacilityName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[TreatmentFacilityAddress] [nvarchar](max) NULL,
	[StateId] [int] NULL,
	[CityId] [int] NULL,
	[ZipCode] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentTreatmentFacility] PRIMARY KEY CLUSTERED 
(
	[IncidentTreatmentFacilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility]  WITH CHECK ADD  CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility] CHECK CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.City_CityId]
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility]  WITH CHECK ADD  CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility] CHECK CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.State_StateId]
GO
