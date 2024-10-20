USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantEmployment]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantEmployment](
	[ApplicantEmploymentId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantCompanyId] [int] NULL,
	[ApplicantPositionId] [int] NULL,
	[ApplicantExitTypeId] [int] NULL,
	[CompanyTelephone] [nvarchar](max) NULL,
	[CompanyAddress] [nvarchar](max) NULL,
	[EmploymentStartDate] [datetime] NULL,
	[EmploymentEndDate] [datetime] NULL,
	[Rate] [decimal](18, 2) NULL,
	[RateFrequencyId] [int] NULL,
	[SuperviorName] [nvarchar](max) NULL,
	[ExitReason] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsCurrentEmployment] [bit] NULL,
 CONSTRAINT [PK_dbo.ApplicantEmployment] PRIMARY KEY CLUSTERED 
(
	[ApplicantEmploymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantCompany_ApplicantCompanyId] FOREIGN KEY([ApplicantCompanyId])
REFERENCES [dbo].[ApplicantCompany] ([ApplicantCompanyId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantCompany_ApplicantCompanyId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantExitType_ApplicantExitTypeId] FOREIGN KEY([ApplicantExitTypeId])
REFERENCES [dbo].[ApplicantExitType] ([ApplicantExitTypeId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantExitType_ApplicantExitTypeId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantPosition_ApplicantPositionId] FOREIGN KEY([ApplicantPositionId])
REFERENCES [dbo].[ApplicantPosition] ([ApplicantPositionId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantPosition_ApplicantPositionId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.RateFrequency_RateFrequencyId]
GO
