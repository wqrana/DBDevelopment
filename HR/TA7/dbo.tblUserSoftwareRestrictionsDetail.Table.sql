USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserSoftwareRestrictionsDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserSoftwareRestrictionsDetail](
	[intUserID] [int] NOT NULL,
	[intRestrictionsID] [int] NOT NULL,
	[boolView] [bit] NOT NULL,
	[boolEdit] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserSoftwareRestrictionsDetail_1] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[intRestrictionsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
