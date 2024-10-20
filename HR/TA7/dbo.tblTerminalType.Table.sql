USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblTerminalType]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTerminalType](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intTerminalTypeID] [int] NOT NULL,
	[strTerminalTypeDesc] [varchar](40) NOT NULL,
	[strTerminalSuffix] [varchar](10) NULL,
 CONSTRAINT [PK_tblTerminalType] PRIMARY KEY CLUSTERED 
(
	[intTerminalTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblTerminalType] ADD  CONSTRAINT [DF_tblTerminalType_strTerminalSuffix]  DEFAULT ('') FOR [strTerminalSuffix]
GO
