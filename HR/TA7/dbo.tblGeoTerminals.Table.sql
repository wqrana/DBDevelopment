USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGeoTerminals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGeoTerminals](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intGeoTerminalID] [int] NOT NULL,
	[strGeoTerminalName] [varchar](20) NOT NULL,
	[fltGeoTerminalLat] [float] NULL,
	[fltGeoTerminalLng] [float] NULL,
	[fltGeoTerminlaRadius] [float] NULL,
	[strGeoTerminalAddress] [varchar](50) NULL,
	[strGeoTerminalCity] [varchar](20) NULL,
	[strGeoTerminalState] [varchar](20) NULL,
	[strGeoTerminalCountry] [varchar](20) NULL,
	[strGeoTerminalZipCode] [varchar](5) NULL,
	[intGeoTerminalEnabled] [int] NOT NULL,
	[dtTimeStamp] [datetime] NULL,
 CONSTRAINT [PK_tblGeoTerminals] PRIMARY KEY CLUSTERED 
(
	[intGeoTerminalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeoTerminals] ADD  CONSTRAINT [DF_tblGeoTerminals_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
