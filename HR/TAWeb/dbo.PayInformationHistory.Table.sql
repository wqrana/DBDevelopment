USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PayInformationHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayInformationHistory](
	[PayInformationHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[EEOCategoryId] [int] NULL,
	[PayTypeId] [int] NOT NULL,
	[RateAmount] [decimal](18, 5) NOT NULL,
	[RateFrequencyId] [int] NOT NULL,
	[CommRateAmount] [decimal](18, 5) NULL,
	[CommRateFrequencyId] [int] NULL,
	[PayFrequencyId] [int] NOT NULL,
	[PeriodHours] [decimal](18, 2) NULL,
	[PeriodGrossPay] [decimal](18, 5) NOT NULL,
	[YearlyGrossPay] [decimal](18, 5) NOT NULL,
	[YearlyCommBasePay] [decimal](18, 5) NULL,
	[YearlyBaseNCommPay] [decimal](18, 5) NULL,
	[ChangeReason] [nvarchar](200) NULL,
	[ApprovedDate] [datetime] NULL,
	[docName] [nvarchar](50) NULL,
	[docExtension] [nvarchar](10) NULL,
	[docFile] [image] NULL,
	[WCClassCodeId] [int] NULL,
	[PayScaleId] [int] NULL,
	[EmploymentId] [int] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayInformationHistory] PRIMARY KEY CLUSTERED 
(
	[PayInformationHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.EEOCategory_EEOCategoryId] FOREIGN KEY([EEOCategoryId])
REFERENCES [dbo].[EEOCategory] ([EEOCategoryId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.EEOCategory_EEOCategoryId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.Employment_EmploymentId] FOREIGN KEY([EmploymentId])
REFERENCES [dbo].[Employment] ([EmploymentId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.Employment_EmploymentId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayFrequency_PayFrequencyId] FOREIGN KEY([PayFrequencyId])
REFERENCES [dbo].[PayFrequency] ([PayFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayFrequency_PayFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayScale_PayScaleId] FOREIGN KEY([PayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayScale_PayScaleId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayType_PayTypeId] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PayType] ([PayTypeId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayType_PayTypeId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_CommRateFrequencyId] FOREIGN KEY([CommRateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_CommRateFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_RateFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.WCClassCode_WCClassCodeId] FOREIGN KEY([WCClassCodeId])
REFERENCES [dbo].[WCClassCode] ([WCClassCodeId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.WCClassCode_WCClassCodeId]
GO
