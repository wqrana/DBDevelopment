USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[FilterList]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[FilterList] AS TABLE(
	[FilterID] [int] NOT NULL,
	[FilterString] [varchar](256) NOT NULL DEFAULT (''),
	PRIMARY KEY CLUSTERED 
(
	[FilterID] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
