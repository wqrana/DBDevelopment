USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[OnlinePaymentstmp]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OnlinePaymentstmp](
	[schid] [bigint] NULL,
	[SchoolName] [varchar](60) NULL,
	[AuthorizedDate] [smalldatetime] NOT NULL,
	[UserID] [varchar](16) NULL,
	[FirstName] [varchar](16) NULL,
	[Middle] [varchar](1) NULL,
	[LastName] [varchar](24) NULL,
	[PaymentTotal] [float] NULL,
	[Comments] [varchar](56) NOT NULL,
	[fromdate] [datetime] NULL,
	[todate] [datetime] NULL
) ON [PRIMARY]
GO
