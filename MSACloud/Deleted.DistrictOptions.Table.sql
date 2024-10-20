USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[DistrictOptions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[DistrictOptions](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] NOT NULL,
	[District_Id] [int] NOT NULL,
	[ChangedDate] [datetime2](7) NULL,
	[LetterWarning1] [int] NULL,
	[LetterWarning2] [int] NULL,
	[LetterWarning3] [int] NULL,
	[TaxPercent] [float] NULL,
	[isEmployeeTaxable] [bit] NULL,
	[isStudentFreeTaxable] [bit] NULL,
	[isStudentPaidTaxable] [bit] NULL,
	[isStudentRedTaxable] [bit] NULL,
	[StartSchoolYear] [smalldatetime] NULL,
	[EndSchoolYear] [smalldatetime] NULL,
	[StartForms] [smalldatetime] NULL,
	[EndForms] [smalldatetime] NULL,
	[isMealPlanTaxable] [bit] NULL,
	[UsingMealPlan] [bit] NULL,
	[UsingMealEqual] [bit] NULL,
	[UsingBonus] [bit] NULL,
	[BlindCashOut] [bit] NULL,
	[isGuestTaxable] [bit] NULL,
	[isStudCashTaxable] [bit] NULL,
	[LetterWarning4] [int] NULL,
	[LetterWarning5] [int] NULL,
	[LetterWarning6] [int] NULL,
	[MaxLetter] [int] NULL,
	[LetterResetLimit] [float] NULL,
	[LetterResetRule] [int] NULL,
	[ReqSecondAuth] [bit] NOT NULL,
	[SecondAuthType] [int] NOT NULL,
	[CCProcessor_Id] [int] NULL,
	[EnableGlobalVeriFoneUser] [bit] NULL,
	[LicenseModel] [varchar](1) NULL,
	[MerchantId] [varchar](12) NULL,
	[VeriFoneIP] [varchar](16) NULL,
	[VeriFonePort] [int] NULL,
	[VeriFoneUserId] [varchar](20) NULL,
	[VeriFonePassword] [varchar](20) NULL,
	[IncomePercentage] [float] NULL,
	[FSTANFPercentage] [float] NULL,
	[AnnualAmountToQualify] [float] NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_DistrictOptions] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [isMealPlanTaxable]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [UsingMealPlan]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [UsingMealEqual]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [UsingBonus]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [BlindCashOut]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [isGuestTaxable]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [isStudCashTaxable]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [LetterWarning4]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [LetterWarning5]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [LetterWarning6]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [MaxLetter]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0.00)) FOR [LetterResetLimit]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [LetterResetRule]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [ReqSecondAuth]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [SecondAuthType]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [CCProcessor_Id]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [EnableGlobalVeriFoneUser]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ('M') FOR [LicenseModel]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0.00)) FOR [IncomePercentage]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0.00)) FOR [FSTANFPercentage]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0.00)) FOR [AnnualAmountToQualify]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[DistrictOptions] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
