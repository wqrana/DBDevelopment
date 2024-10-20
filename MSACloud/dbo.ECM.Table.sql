USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[ECM]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ECM](
	[ClientID] [bigint] NOT NULL,
	[ECM] [bigint] NOT NULL,
	[IPAddress] [varchar](16) NULL,
	[ECMName] [varchar](20) NULL,
	[ECMLocation] [varchar](20) NULL,
	[ECMNum] [int] NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK_ECM] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[ECM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ECM] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
