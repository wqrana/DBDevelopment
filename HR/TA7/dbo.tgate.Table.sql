USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tgate]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tgate](
	[id] [int] NOT NULL,
	[name] [varchar](30) NULL,
	[reg_date] [varchar](12) NULL,
	[floor] [int] NULL,
	[place] [varchar](30) NULL,
	[block] [varchar](1) NULL,
	[userctrl] [varchar](1) NULL,
	[passtime] [varchar](8) NULL,
	[version] [varchar](4) NULL,
	[admin] [image] NULL,
	[lastup] [varchar](14) NULL,
	[remark] [varchar](50) NULL,
	[antipass] [int] NULL,
	[antipass_level] [int] NULL,
	[antipass_mode] [int] NULL,
	[nCompanyID] [int] NULL,
	[nPunchClock] [int] NULL,
	[nJobCodeID] [int] NULL,
	[intTerminalType] [int] NULL,
 CONSTRAINT [PK_tgate] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tgate] ADD  CONSTRAINT [DF_tgate_intTerminalType]  DEFAULT ((0)) FOR [intTerminalType]
GO
