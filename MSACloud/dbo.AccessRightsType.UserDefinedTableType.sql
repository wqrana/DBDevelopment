USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[AccessRightsType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[AccessRightsType] AS TABLE(
	[ObjectID] [int] NULL,
	[CanView] [bit] NULL,
	[CanInsert] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanDelete] [bit] NULL
)
GO
