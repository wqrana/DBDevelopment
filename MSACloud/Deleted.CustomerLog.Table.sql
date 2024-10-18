USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[CustomerLog]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[CustomerLog](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Emp_Changed_Id] [int] NULL,
	[ChangedDate] [datetime2](7) NOT NULL,
	[Notes] [varchar](4097) NULL,
	[Comment] [varchar](255) NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
	[Log_Note_Id] [int] NULL,
	[ModifiedDate] [datetime2](7) NULL,
 CONSTRAINT [PK_CustomerLog] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[CustomerLog] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[CustomerLog] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[CustomerLog] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
