USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[CustomerSchoolAssignments]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[CustomerSchoolAssignments] AS TABLE(
	[School_Id] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[School_Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
