USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantApplication]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantApplication](
	[ApplicantApplicationId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[ApplicantReferenceTypeId] [int] NULL,
	[ApplicantReferenceSourceId] [int] NULL,
	[DateApplied] [datetime] NOT NULL,
	[DateAvailable] [datetime] NULL,
	[Rate] [decimal](18, 2) NULL,
	[RateFrequencyId] [int] NULL,
	[IsMondayShift] [bit] NULL,
	[MondayStartShift] [datetime] NULL,
	[MondayEndShift] [datetime] NULL,
	[IsTuesdayShift] [bit] NULL,
	[TuesdayStartShift] [datetime] NULL,
	[TuesdayEndShift] [datetime] NULL,
	[IsWednesdayShift] [bit] NULL,
	[WednesdayStartShift] [datetime] NULL,
	[WednesdayEndShift] [datetime] NULL,
	[IsThursdayShift] [bit] NULL,
	[ThursdayStartShift] [datetime] NULL,
	[ThursdayEndShift] [datetime] NULL,
	[IsFridayShift] [bit] NULL,
	[FridayStartShift] [datetime] NULL,
	[FridayEndShift] [datetime] NULL,
	[IsSaturdayShift] [bit] NULL,
	[SaturdayStartShift] [datetime] NULL,
	[SaturdayEndShift] [datetime] NULL,
	[IsSundayShift] [bit] NULL,
	[SundayStartShift] [datetime] NULL,
	[SundayEndShift] [datetime] NULL,
	[IsOvertime] [bit] NULL,
	[IsWorkedBefore] [bit] NULL,
	[WorkedBeforeDate] [datetime] NULL,
	[IsRelativeInCompany] [bit] NULL,
	[RelativeName] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantApplication] PRIMARY KEY CLUSTERED 
(
	[ApplicantApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceSource_ApplicantReferenceSourceId] FOREIGN KEY([ApplicantReferenceSourceId])
REFERENCES [dbo].[ApplicantReferenceSource] ([ApplicantReferenceSourceId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceSource_ApplicantReferenceSourceId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceType_ApplicantReferenceTypeId] FOREIGN KEY([ApplicantReferenceTypeId])
REFERENCES [dbo].[ApplicantReferenceType] ([ApplicantReferenceTypeId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceType_ApplicantReferenceTypeId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.RateFrequency_RateFrequencyId]
GO
