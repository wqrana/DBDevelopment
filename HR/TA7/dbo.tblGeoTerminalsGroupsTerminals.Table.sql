USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGeoTerminalsGroupsTerminals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGeoTerminalsGroupsTerminals](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intGroupID] [int] NOT NULL,
	[intGeoTerminalID] [int] NOT NULL,
	[strDescription] [varchar](50) NULL,
	[dtTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblGeoTerminalsGroupsTerminals] PRIMARY KEY CLUSTERED 
(
	[intGroupID] ASC,
	[intGeoTerminalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeoTerminalsGroupsTerminals] ADD  CONSTRAINT [DF_tblGeoTerminalsGroupsTerminals_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
