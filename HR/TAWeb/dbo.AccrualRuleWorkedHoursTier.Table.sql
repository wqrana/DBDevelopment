USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AccrualRuleWorkedHoursTier]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRuleWorkedHoursTier](
	[AccrualRuleWorkedHoursTierId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleId] [int] NOT NULL,
	[AccrualRuleTierId] [int] NOT NULL,
	[TierNo] [int] NOT NULL,
	[TierDescription] [nvarchar](max) NULL,
	[TierWorkedHoursMin] [float] NOT NULL,
	[TierWorkedHoursMax] [float] NULL,
	[AccrualHours] [float] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRuleWorkedHoursTier] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleWorkedHoursTierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccrualRuleWorkedHoursTier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRuleWorkedHoursTier_dbo.AccrualRuleTier_AccrualRuleTierId] FOREIGN KEY([AccrualRuleTierId])
REFERENCES [dbo].[AccrualRuleTier] ([AccrualRuleTierId])
GO
ALTER TABLE [dbo].[AccrualRuleWorkedHoursTier] CHECK CONSTRAINT [FK_dbo.AccrualRuleWorkedHoursTier_dbo.AccrualRuleTier_AccrualRuleTierId]
GO
