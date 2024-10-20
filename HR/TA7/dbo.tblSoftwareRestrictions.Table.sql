USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblSoftwareRestrictions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSoftwareRestrictions](
	[intRestrictionsID] [int] NOT NULL,
	[strRestrictionsName] [nvarchar](50) NOT NULL,
	[strRestrictionDescription] [nvarchar](100) NOT NULL,
	[boolPermitsView] [bit] NOT NULL,
	[boolPermitsEdit] [bit] NOT NULL,
	[intModuleID] [int] NOT NULL,
 CONSTRAINT [PK_tblSoftwarerestrictions] PRIMARY KEY CLUSTERED 
(
	[intRestrictionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
