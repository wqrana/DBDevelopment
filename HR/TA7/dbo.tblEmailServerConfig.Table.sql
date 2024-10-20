USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblEmailServerConfig]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmailServerConfig](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[strServerIP] [varchar](50) NOT NULL,
	[intPort] [int] NOT NULL,
	[bUseSSL] [int] NOT NULL,
	[strTAEMail] [varchar](100) NOT NULL,
	[intFixedFromAddress] [int] NULL,
	[bUseDefaultCredentials] [int] NULL,
	[strUserName] [varchar](50) NULL,
	[strPassword] [varchar](50) NULL,
	[intAttKeepLengthDays] [int] NULL,
	[intMinBetweenPull] [int] NULL,
	[strEncryptPWD] [nvarchar](max) NULL,
	[strProviderEmailAccount] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblEmailServerConfig] PRIMARY KEY CLUSTERED 
(
	[intID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_intPort]  DEFAULT ((25)) FOR [intPort]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_bUseSSL]  DEFAULT ((0)) FOR [bUseSSL]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_intFixedFromAddress]  DEFAULT ((1)) FOR [intFixedFromAddress]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_intUseDefaultCredentials]  DEFAULT ((1)) FOR [bUseDefaultCredentials]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_intAttKeepLengthDays]  DEFAULT ((7)) FOR [intAttKeepLengthDays]
GO
ALTER TABLE [dbo].[tblEmailServerConfig] ADD  CONSTRAINT [DF_tblEmailServerConfig_intMinBetweenPull]  DEFAULT ((15)) FOR [intMinBetweenPull]
GO
