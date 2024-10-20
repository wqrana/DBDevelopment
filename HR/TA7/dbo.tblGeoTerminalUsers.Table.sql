USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGeoTerminalUsers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGeoTerminalUsers](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intUserID] [int] NOT NULL,
	[bUserPwd_1] [varbinary](256) NOT NULL,
	[bUserPwd_2] [varbinary](256) NOT NULL,
	[intEnabled] [int] NULL,
	[intGeoTerminalID] [int] NOT NULL,
	[intRestrictionGroup] [int] NULL,
	[intRestrictionType] [int] NULL,
	[dtTimeStamp] [datetime] NULL,
	[sUserPwd] [varchar](512) NULL,
 CONSTRAINT [PK_tblGeoTerminalUsers] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeoTerminalUsers] ADD  CONSTRAINT [DF_tblGeoTerminalUsers_intEnabled]  DEFAULT ((0)) FOR [intEnabled]
GO
ALTER TABLE [dbo].[tblGeoTerminalUsers] ADD  CONSTRAINT [DF_tblGeoTerminalUsers_intRestrictionType]  DEFAULT ((0)) FOR [intRestrictionType]
GO
ALTER TABLE [dbo].[tblGeoTerminalUsers] ADD  CONSTRAINT [DF_tblGeoTerminalUsers_dtTimeStamp]  DEFAULT (getdate()) FOR [dtTimeStamp]
GO
