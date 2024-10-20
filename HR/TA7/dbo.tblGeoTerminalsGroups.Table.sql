USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGeoTerminalsGroups]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGeoTerminalsGroups](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intGeoTerminalGroupID] [int] NOT NULL,
	[strGeoTerminalGroupName] [varchar](20) NULL,
	[strGeoTerminalGroupDesc] [varchar](50) NULL,
	[dtTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblGeoTerminalsGroups] PRIMARY KEY CLUSTERED 
(
	[intGeoTerminalGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeoTerminalsGroups] ADD  CONSTRAINT [DF_tblGeoTerminalsGroupse_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
