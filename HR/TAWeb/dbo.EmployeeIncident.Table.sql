USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeIncident]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeIncident](
	[EmployeeIncidentId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentTypeId] [int] NULL,
	[LocationId] [int] NULL,
	[IncidentAreaId] [int] NULL,
	[OSHACaseClassificationId] [int] NULL,
	[OSHAInjuryClassificationId] [int] NULL,
	[IncidentBodyPartId] [int] NULL,
	[IncidentInjuryDescriptionId] [int] NULL,
	[IncidentInjurySourceId] [int] NULL,
	[IncidentTreatmentFacilityId] [int] NULL,
	[IsOSHARecordable] [bit] NOT NULL,
	[IncidentDate] [datetime] NULL,
	[IncidentTime] [datetime] NULL,
	[EmployeeBeganWorkTime] [datetime] NULL,
	[RestrictedFromWorkDays] [int] NULL,
	[AwayFromWorkDays] [int] NULL,
	[EmployeeDoingBeforeIncident] [nvarchar](max) NULL,
	[HowIncidentOccured] [nvarchar](max) NULL,
	[DateOfDeath] [datetime] NULL,
	[PhysicianName] [nvarchar](max) NULL,
	[IsTreatedInEmergencyRoom] [bit] NOT NULL,
	[IsHospitalizedOvernight] [bit] NOT NULL,
	[HospitalizedDays] [int] NULL,
	[CompletedById] [int] NULL,
	[CompletedDate] [datetime] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeIncident] PRIMARY KEY CLUSTERED 
(
	[EmployeeIncidentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentArea_IncidentAreaId] FOREIGN KEY([IncidentAreaId])
REFERENCES [dbo].[IncidentArea] ([IncidentAreaId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentArea_IncidentAreaId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentBodyPart_IncidentBodyPartId] FOREIGN KEY([IncidentBodyPartId])
REFERENCES [dbo].[IncidentBodyPart] ([IncidentBodyPartId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentBodyPart_IncidentBodyPartId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjuryDescription_IncidentInjuryDescriptionId] FOREIGN KEY([IncidentInjuryDescriptionId])
REFERENCES [dbo].[IncidentInjuryDescription] ([IncidentInjuryDescriptionId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjuryDescription_IncidentInjuryDescriptionId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjurySource_IncidentInjurySourceId] FOREIGN KEY([IncidentInjurySourceId])
REFERENCES [dbo].[IncidentInjurySource] ([IncidentInjurySourceId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjurySource_IncidentInjurySourceId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentTreatmentFacility_IncidentTreatmentFacilityId] FOREIGN KEY([IncidentTreatmentFacilityId])
REFERENCES [dbo].[IncidentTreatmentFacility] ([IncidentTreatmentFacilityId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentTreatmentFacility_IncidentTreatmentFacilityId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentType_IncidentTypeId] FOREIGN KEY([IncidentTypeId])
REFERENCES [dbo].[IncidentType] ([IncidentTypeId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentType_IncidentTypeId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHACaseClassification_OSHACaseClassificationId] FOREIGN KEY([OSHACaseClassificationId])
REFERENCES [dbo].[OSHACaseClassification] ([OSHACaseClassificationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHACaseClassification_OSHACaseClassificationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHAInjuryClassification_OSHAInjuryClassificationId] FOREIGN KEY([OSHAInjuryClassificationId])
REFERENCES [dbo].[OSHAInjuryClassification] ([OSHAInjuryClassificationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHAInjuryClassification_OSHAInjuryClassificationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.UserInformation_CompletedById] FOREIGN KEY([CompletedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.UserInformation_CompletedById]
GO
