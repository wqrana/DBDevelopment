USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[MSARecordsHavingCloudPOSIDIsNull]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[MSARecordsHavingCloudPOSIDIsNull] AS TABLE(
	[MSA_Dist_Id] [int] NOT NULL
)
GO
