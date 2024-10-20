USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[StudentHistory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentHistory](
	[ClientID] [bigint] NOT NULL,
	[OldStatChange] [varchar](60) NULL,
	[NewStatChange] [varchar](60) NULL,
	[PostDate] [smalldatetime] NOT NULL,
	[ChangeDate] [smalldatetime] NULL,
	[SignerDate] [smalldatetime] NULL,
	[HHIDNumber] [varchar](15) NOT NULL,
	[Cust_ID_Num] [bigint] NOT NULL,
	[StudentName] [varchar](60) NULL,
	[StudentSSN] [varchar](11) NULL,
	[SignerName] [varchar](60) NULL,
	[School] [varchar](60) NULL,
	[Reason] [varchar](60) NULL,
	[ApprovedDate] [smalldatetime] NULL,
	[DeniedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_StudentHistory] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[PostDate] ASC,
	[Cust_ID_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
