USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[IdsList]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[IdsList] AS TABLE(
	[Id] [varchar](max) NULL,
	[Value] [varchar](max) NULL,
	[Description] [varchar](max) NULL
)
GO
