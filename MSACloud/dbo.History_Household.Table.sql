USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[History_Household]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[History_Household](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
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
	[District_Name] [varchar](30) NULL,
	[TANF] [varchar](30) NULL,
	[TempStatus] [int] NULL,
	[AppLetterSent] [bit] NULL,
	[FORM_Date] [smalldatetime] NULL,
	[NoIncome] [bit] NULL,
	[Migrant] [varchar](1) NULL,
 CONSTRAINT [PK_History_Household] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
