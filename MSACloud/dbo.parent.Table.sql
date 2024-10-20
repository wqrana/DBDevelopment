USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[parent]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[parent](
	[ClientID] [bigint] NOT NULL,
	[HouseholdID] [varchar](15) NOT NULL,
	[LName] [varchar](20) NULL,
	[FName] [varchar](20) NULL,
	[MI] [varchar](1) NULL,
	[SSN] [varchar](11) NULL,
	[ParentalStatus] [varchar](15) NULL,
	[Income1] [float] NULL,
	[Income2] [float] NULL,
	[Income3] [float] NULL,
	[Income4] [float] NULL,
	[Income5] [float] NULL,
	[TotalIncome] [float] NULL,
	[Frequency1] [varchar](12) NULL,
	[Frequency2] [varchar](12) NULL,
	[Frequency3] [varchar](12) NULL,
	[Frequency4] [varchar](12) NULL,
	[Frequency5] [varchar](12) NULL,
	[District_Id] [int] NOT NULL,
	[Id] [int] NOT NULL,
 CONSTRAINT [PK_parent] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
