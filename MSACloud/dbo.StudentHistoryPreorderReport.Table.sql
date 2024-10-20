USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[StudentHistoryPreorderReport]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentHistoryPreorderReport](
	[clientid] [bigint] NOT NULL,
	[cstid] [bigint] NOT NULL,
	[locationid] [bigint] NULL,
	[UserID] [varchar](16) NOT NULL,
	[CustomerName] [varchar](41) NULL,
	[FirstName] [varchar](16) NULL,
	[MiddleName] [varchar](1) NOT NULL,
	[LastName] [varchar](24) NULL,
	[Grade] [varchar](15) NOT NULL,
	[Homeroom] [varchar](10) NOT NULL,
	[Qty] [int] NOT NULL,
	[ItemName] [varchar](75) NULL,
	[SchoolName] [varchar](60) NOT NULL,
	[HistoryDate] [datetime] NULL,
	[HistoryDateType] [varchar](32) NOT NULL,
	[creationdate] [datetime2](7) NULL,
	[lunchtype] [int] NOT NULL
) ON [PRIMARY]
GO
