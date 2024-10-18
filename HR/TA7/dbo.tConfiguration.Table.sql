USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tConfiguration]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tConfiguration](
	[nConfigID] [int] NOT NULL,
	[nConfigParam] [int] NULL,
	[sConfigDesc] [nvarchar](50) NULL,
	[nConfigType] [int] NULL
) ON [PRIMARY]
GO
