USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[RecalculationLog]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecalculationLog](
	[ClientID] [bigint] NOT NULL,
	[RecalcLog_ID] [int] NULL,
	[ArchiveDate] [datetime2](7) NOT NULL,
	[Customer_Id] [bigint] NOT NULL,
	[PrevABal] [float] NULL,
	[PrevMBal] [float] NULL,
	[PrevBBal] [float] NULL,
	[NewABal] [float] NULL,
	[NewMBal] [float] NULL,
	[NewBBal] [float] NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Notes] [varchar](1024) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_RecalculationLog] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT ((0.0)) FOR [NewABal]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT ((0.0)) FOR [NewMBal]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT ((0.0)) FOR [NewBBal]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[RecalculationLog] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
