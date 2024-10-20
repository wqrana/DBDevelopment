USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGeoTerminals_tEnter]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGeoTerminals_tEnter](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[strDate] [varchar](8) NOT NULL,
	[strTime] [varchar](12) NOT NULL,
	[intEmpoyeeID] [int] NOT NULL,
	[intGeoTerminalID] [int] NOT NULL,
	[intResult] [int] NOT NULL,
	[bProcessed] [int] NULL,
	[dtTimeStamp] [datetime] NULL,
	[strPhoneModel] [varchar](20) NULL,
	[strPhoneOSVersion] [varchar](20) NULL,
	[strPhoneUID] [varchar](50) NULL,
	[fltClientLon] [float] NULL,
	[fltClientLat] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeoTerminals_tEnter] ADD  CONSTRAINT [DF_tblGeoTerminals_tEnter_bProcessed]  DEFAULT ((0)) FOR [bProcessed]
GO
ALTER TABLE [dbo].[tblGeoTerminals_tEnter] ADD  CONSTRAINT [DF_tblGeoTerminals_tEnter_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
