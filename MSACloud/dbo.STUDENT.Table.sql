USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[STUDENT]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STUDENT](
	[ClientID] [bigint] NOT NULL,
	[UserID] [varchar](17) NULL,
	[Race] [varchar](50) NULL,
	[AppDate] [smalldatetime] NULL,
	[FosterChild] [bit] NULL,
	[FosterIncome] [float] NULL,
	[ApprovalStatus] [varchar](30) NULL,
	[DateEntered] [smalldatetime] NULL,
	[DateChanged] [smalldatetime] NULL,
	[HouseholdID] [varchar](15) NOT NULL,
	[District_Id] [int] NOT NULL,
	[Customer_Id] [int] NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AppLetterSent] [bit] NULL,
	[AppStatStudent] [varchar](30) NULL,
	[STUD_RS_ID] [int] NULL,
	[RS_MOD_DATE] [smalldatetime] NULL,
	[STATUS_EFFECTIVE_DATE] [smalldatetime] NULL,
	[STATUS_UPDATED] [bit] NULL,
 CONSTRAINT [PK_STUDENT] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[STUDENT] ADD  DEFAULT ((0)) FOR [AppLetterSent]
GO
ALTER TABLE [dbo].[STUDENT] ADD  DEFAULT ('(None)') FOR [AppStatStudent]
GO
ALTER TABLE [dbo].[STUDENT] ADD  DEFAULT ((0)) FOR [STATUS_UPDATED]
GO
