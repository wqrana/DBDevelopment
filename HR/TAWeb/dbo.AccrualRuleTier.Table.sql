USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AccrualRuleTier]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRuleTier](
	[AccrualRuleTierId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleId] [int] NOT NULL,
	[TierNo] [int] NOT NULL,
	[TierDescription] [nvarchar](max) NULL,
	[YearsWorkedFrom] [float] NULL,
	[YearsWorkedTo] [float] NULL,
	[WaitingPeriodType] [bit] NOT NULL,
	[WaitingPeriodLength] [int] NULL,
	[AllowedMaxHoursTypeId] [int] NULL,
	[AllowedMaxHours] [float] NULL,
	[AccrualTypeExcess] [nvarchar](max) NULL,
	[ResetAccruedHoursTypeId] [int] NULL,
	[ResetHours] [float] NULL,
	[ResetDate] [datetime] NULL,
	[MinWorkedHoursType] [bit] NOT NULL,
	[AccrualHours] [float] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRuleTier] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleTierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccrualRuleTier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRuleTier_dbo.AccrualRule_AccrualRuleId] FOREIGN KEY([AccrualRuleId])
REFERENCES [dbo].[AccrualRule] ([AccrualRuleId])
GO
ALTER TABLE [dbo].[AccrualRuleTier] CHECK CONSTRAINT [FK_dbo.AccrualRuleTier_dbo.AccrualRule_AccrualRuleId]
GO
