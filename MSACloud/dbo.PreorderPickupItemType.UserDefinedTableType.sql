USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[PreorderPickupItemType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[PreorderPickupItemType] AS TABLE(
	[Id] [int] NULL,
	[Qty] [int] NULL,
	[isReimbursableItem] [bit] NULL
)
GO
