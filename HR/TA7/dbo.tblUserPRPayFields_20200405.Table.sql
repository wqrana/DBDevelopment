USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserPRPayFields_20200405]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserPRPayFields_20200405](
	[intUserID] [int] NOT NULL,
	[strDriversLicense] [nvarchar](50) NOT NULL,
	[strCarLicensePlate] [nvarchar](50) NOT NULL,
	[strMarbete] [nvarchar](50) NOT NULL,
	[dtMarbeteDate] [date] NULL,
	[boolShareholder] [bit] NOT NULL,
	[boolChauffeur] [bit] NOT NULL,
	[boolChauffeurSelfEmployed] [bit] NOT NULL,
	[boolAgriculturalEmployee] [bit] NOT NULL,
	[boolHouseholdEmployee] [bit] NOT NULL,
	[boolResidenteBonaFide] [bit] NOT NULL
) ON [PRIMARY]
GO
