USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[OrderLogType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[OrderLogType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[EmployeeId] [int] NULL,
	[ChangedDate] [datetime2](7) NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[Notes] [varchar](255) NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
