USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Employment]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employment](
	[EmploymentId] [int] IDENTITY(1,1) NOT NULL,
	[OriginalHireDate] [datetime] NOT NULL,
	[EffectiveHireDate] [datetime] NOT NULL,
	[ProbationStartDate] [datetime] NULL,
	[ProbationEndDate] [datetime] NULL,
	[EmploymentStatusId] [int] NULL,
	[TerminationDate] [datetime] NULL,
	[TerminationTypeId] [int] NULL,
	[TerminationReasonId] [int] NULL,
	[DocumentName] [nvarchar](500) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[TerminationEligibilityId] [int] NULL,
	[UseHireDateforYearsInService] [bit] NOT NULL,
	[TerminationNotes] [nvarchar](500) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsExitInterview] [bit] NULL,
	[ExitInterviewDocName] [nvarchar](500) NULL,
	[ExitInterviewDocPath] [nvarchar](500) NULL,
 CONSTRAINT [PK_dbo.Employment] PRIMARY KEY CLUSTERED 
(
	[EmploymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_OriginalHireDate] UNIQUE NONCLUSTERED 
(
	[UserInformationId] ASC,
	[OriginalHireDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.EmploymentStatus_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([EmploymentStatusId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.EmploymentStatus_EmploymentStatusId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationEligibility_TerminationEligibilityId] FOREIGN KEY([TerminationEligibilityId])
REFERENCES [dbo].[TerminationEligibility] ([TerminationEligibilityId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationEligibility_TerminationEligibilityId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationReason_TerminationReasonId] FOREIGN KEY([TerminationReasonId])
REFERENCES [dbo].[TerminationReason] ([TerminationReasonId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationReason_TerminationReasonId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationType_TerminationTypeId] FOREIGN KEY([TerminationTypeId])
REFERENCES [dbo].[TerminationType] ([TerminationTypeId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationType_TerminationTypeId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.UserInformation_UserInformationId]
GO
