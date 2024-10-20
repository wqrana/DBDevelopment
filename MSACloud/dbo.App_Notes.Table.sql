USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[App_Notes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[App_Notes](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[Comment] [varchar](1024) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_App_Notes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[App_Notes] ADD  CONSTRAINT [DF__App_Notes__LastU__26509D48]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[App_Notes] ADD  CONSTRAINT [DF__App_Notes__Updat__2744C181]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[App_Notes] ADD  CONSTRAINT [DF__App_Notes__Cloud__2838E5BA]  DEFAULT ((0)) FOR [CloudIDSync]
GO
