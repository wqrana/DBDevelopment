USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[History_verfication]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[History_verfication](
	[ClientID] [bigint] NOT NULL,
	[HouseholdID] [varchar](15) NULL,
	[HHSize] [int] NULL,
	[FSNum] [varchar](30) NULL,
	[TANF] [varchar](30) NULL,
	[MonthlyIncome] [float] NULL,
	[AprvStatus] [int] NULL,
	[IncomeHigh] [bit] NULL,
	[Incomplete] [bit] NULL,
	[Other] [varchar](100) NULL,
	[StatChgReason] [varchar](100) NULL,
	[StatChgDate] [smalldatetime] NULL,
	[DateWithdrawn] [smalldatetime] NULL,
	[DeterOfficial] [varchar](60) NULL,
	[DODate] [smalldatetime] NULL,
	[NoticeSent1] [smalldatetime] NULL,
	[ResponseDue] [smalldatetime] NULL,
	[NoticeSent2] [smalldatetime] NULL,
	[VerfiyResult] [int] NULL,
	[ReasonChange] [int] NULL,
	[ReasonChangeOther] [varchar](100) NULL,
	[DateChangeSent] [smalldatetime] NULL,
	[VerifyOfficial] [varchar](60) NULL,
	[VODate] [smalldatetime] NULL,
	[Id] [int] NOT NULL,
	[District_Id] [int] NOT NULL,
	[FORM_Date] [smalldatetime] NULL,
 CONSTRAINT [PK_History_verfication] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[District_Id] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
