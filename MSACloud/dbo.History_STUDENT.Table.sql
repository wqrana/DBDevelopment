USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[History_STUDENT]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[History_STUDENT](
	[ClientID] [bigint] NOT NULL,
	[UserID] [varchar](17) NULL,
	[Race] [varchar](50) NULL,
	[AppDate] [smalldatetime] NULL,
	[FosterChild] [bit] NULL,
	[FosterIncome] [float] NULL,
	[ApprovalStatus] [varchar](30) NULL,
	[DateEntered] [smalldatetime] NULL,
	[DateChanged] [smalldatetime] NULL,
	[HouseholdID] [varchar](15) NULL,
	[District_Name] [varchar](30) NULL,
	[Customer_Id] [int] NOT NULL,
	[Id] [int] NOT NULL,
	[LastName] [varchar](24) NULL,
	[FirstName] [varchar](16) NULL,
	[Middle] [varchar](1) NULL,
	[FORM_Date] [smalldatetime] NULL,
 CONSTRAINT [PK_History_Student] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
