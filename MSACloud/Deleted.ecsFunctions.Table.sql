USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[ecsFunctions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[ecsFunctions](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Name] [varchar](32) NOT NULL,
	[Description] [varchar](max) NULL,
	[DLLName] [varchar](32) NULL,
	[ParametersNeeded] [text] NOT NULL,
	[isAllowed] [bit] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_ecsFunctions] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[ecsFunctions] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[ecsFunctions] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[ecsFunctions] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
