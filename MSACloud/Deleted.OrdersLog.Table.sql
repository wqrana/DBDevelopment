USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[OrdersLog]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[OrdersLog](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Employee_Id] [int] NULL,
	[ChangedDate] [datetime2](7) NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[Notes] [varchar](255) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_OrdersLog] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[OrdersLog] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[OrdersLog] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[OrdersLog] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
