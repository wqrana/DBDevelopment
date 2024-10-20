USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeDependent]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDependent](
	[EmployeeDependentId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NOT NULL,
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
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeDependent] PRIMARY KEY CLUSTERED 
(
	[EmployeeDependentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.DependentStatus_DependentStatusId] FOREIGN KEY([DependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.DependentStatus_DependentStatusId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.UserInformation_UserInformationId]
GO
