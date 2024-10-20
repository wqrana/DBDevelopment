USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[SalesTaxType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[SalesTaxType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[OrderId] [bigint] NOT NULL,
	[TaxEntityId] [int] NULL,
	[TaxEntityName] [varchar](50) NULL,
	[TaxRate] [float] NULL,
	[SalesTax] [float] NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
