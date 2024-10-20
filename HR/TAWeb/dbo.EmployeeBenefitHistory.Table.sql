USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeBenefitHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeBenefitHistory](
	[EmployeeBenefitHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[Amount] [decimal](18, 2) NULL,
	[BenefitId] [int] NULL,
	[PayFrequencyId] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
	[EmployeeContribution] [decimal](18, 2) NULL,
	[CompanyContribution] [decimal](18, 2) NULL,
	[OtherContribution] [decimal](18, 2) NULL,
	[TotalContribution] [decimal](18, 2) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeBenefitHistory] PRIMARY KEY CLUSTERED 
(
	[EmployeeBenefitHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.Benefit_BenefitId] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[Benefit] ([BenefitId])
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.Benefit_BenefitId]
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.PayFrequency_PayFrequencyId] FOREIGN KEY([PayFrequencyId])
REFERENCES [dbo].[PayFrequency] ([PayFrequencyId])
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.PayFrequency_PayFrequencyId]
GO
