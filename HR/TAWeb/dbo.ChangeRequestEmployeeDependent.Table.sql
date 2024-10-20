USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChangeRequestEmployeeDependent]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmployeeDependent](
	[ChangeRequestEmployeeDependentId] [int] IDENTITY(1,1) NOT NULL,
	[NewFirstName] [nvarchar](max) NULL,
	[NewLastName] [nvarchar](max) NULL,
	[NewBirthDate] [datetime] NULL,
	[NewSSN] [nvarchar](max) NULL,
	[NewDependentStatusId] [int] NULL,
	[NewGenderId] [int] NULL,
	[NewRelationshipId] [int] NULL,
	[NewExpiryDate] [datetime] NULL,
	[NewIsHealthInsurance] [bit] NULL,
	[NewIsDentalInsurance] [bit] NULL,
	[NewIsTaxPurposes] [bit] NULL,
	[NewIsFullTimeStudent] [bit] NULL,
	[NewSchoolAttending] [nvarchar](max) NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[BirthDate] [datetime] NULL,
	[SSN] [nvarchar](max) NULL,
	[DependentStatusId] [int] NULL,
	[GenderId] [int] NULL,
	[RelationshipId] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[IsHealthInsurance] [bit] NOT NULL,
	[IsDentalInsurance] [bit] NOT NULL,
	[IsTaxPurposes] [bit] NOT NULL,
	[IsFullTimeStudent] [bit] NOT NULL,
	[SchoolAttending] [nvarchar](max) NULL,
	[EmployeeDependentId] [int] NULL,
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
	[ChangeRequestRemarks] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmployeeDependent] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmployeeDependentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_DependentStatusId] FOREIGN KEY([DependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_DependentStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_NewDependentStatusId] FOREIGN KEY([NewDependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_NewDependentStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.EmployeeDependent_EmployeeDependentId] FOREIGN KEY([EmployeeDependentId])
REFERENCES [dbo].[EmployeeDependent] ([EmployeeDependentId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.EmployeeDependent_EmployeeDependentId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_NewGenderId] FOREIGN KEY([NewGenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_NewGenderId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_NewRelationshipId] FOREIGN KEY([NewRelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_NewRelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.UserInformation_UserInformationId]
GO
