USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[HOUSEHOLD]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOUSEHOLD](
	[ClientID] [bigint] NOT NULL,
	[HouseholdID] [varchar](15) NOT NULL,
	[HHSize] [int] NULL,
	[AdditionalMembers] [int] NULL,
	[DateSigned] [smalldatetime] NULL,
	[FSNum] [varchar](30) NULL,
	[Addr1] [varchar](30) NULL,
	[Addr2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone1] [varchar](14) NULL,
	[Phone2] [varchar](14) NULL,
	[Language] [varchar](1) NULL,
	[Cert] [varchar](1) NULL,
	[MilkOnly] [varchar](1) NULL,
	[HealthDept] [varchar](1) NULL,
	[TempCode] [varchar](30) NULL,
	[TempCodeExpDate] [smalldatetime] NULL,
	[Comment] [varchar](100) NULL,
	[Signed_SSN] [varchar](11) NULL,
	[SignedLName] [varchar](30) NULL,
	[SignedFName] [varchar](30) NULL,
	[SignedMI] [varchar](1) NULL,
	[HHAreaCode] [varchar](3) NULL,
	[District_Id] [int] NULL,
	[Id] [int] NOT NULL,
	[TANF] [varchar](30) NULL,
	[TempStatus] [int] NULL,
	[AppLetterSent] [bit] NULL,
	[NoIncome] [bit] NULL,
	[Migrant] [varchar](1) NULL,
	[AppStatHousehold] [varchar](30) NULL,
	[RS_ID] [int] NULL,
	[RS_ImagePath] [varchar](255) NULL,
	[FeeWaiver] [bit] NULL,
 CONSTRAINT [PK_HOUSEHOLD] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC,
	[HouseholdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HOUSEHOLD] ADD  CONSTRAINT [DF__HOUSEHOLD__NoInc__597B3B93]  DEFAULT ((0)) FOR [NoIncome]
GO
ALTER TABLE [dbo].[HOUSEHOLD] ADD  CONSTRAINT [DF__HOUSEHOLD__Migra__5A6F5FCC]  DEFAULT ('N') FOR [Migrant]
GO
ALTER TABLE [dbo].[HOUSEHOLD] ADD  CONSTRAINT [DF__HOUSEHOLD__AppSt__5B638405]  DEFAULT ('(None)') FOR [AppStatHousehold]
GO
ALTER TABLE [dbo].[HOUSEHOLD] ADD  CONSTRAINT [DF__HOUSEHOLD__RS_ID__5C57A83E]  DEFAULT ((0)) FOR [RS_ID]
GO
ALTER TABLE [dbo].[HOUSEHOLD] ADD  CONSTRAINT [DF__HOUSEHOLD__FeeWa__5D4BCC77]  DEFAULT ((0)) FOR [FeeWaiver]
GO
