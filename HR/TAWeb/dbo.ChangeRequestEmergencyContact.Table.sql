USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChangeRequestEmergencyContact]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmergencyContact](
	[ChangeRequestEmergencyContactId] [int] IDENTITY(1,1) NOT NULL,
	[EmergencyContactId] [int] NULL,
	[RelationshipId] [int] NULL,
	[ContactPersonName] [nvarchar](50) NULL,
	[IsDefault] [bit] NOT NULL,
	[MainNumber] [nvarchar](20) NULL,
	[AlternateNumber] [nvarchar](20) NULL,
	[NewRelationshipId] [int] NULL,
	[NewContactPersonName] [nvarchar](50) NULL,
	[NewIsDefault] [bit] NOT NULL,
	[NewMainNumber] [nvarchar](20) NULL,
	[NewAlternateNumber] [nvarchar](20) NULL,
	[RequestTypeId] [int] NOT NULL,
	[ReasonForDelete] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmergencyContact] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmergencyContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.EmergencyContact_EmergencyContactId] FOREIGN KEY([EmergencyContactId])
REFERENCES [dbo].[EmergencyContact] ([EmergencyContactId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.EmergencyContact_EmergencyContactId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_NewRelationshipId] FOREIGN KEY([NewRelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_NewRelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.UserInformation_UserInformationId]
GO
