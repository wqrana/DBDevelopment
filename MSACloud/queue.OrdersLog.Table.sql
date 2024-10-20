USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [queue].[OrdersLog]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [queue].[OrdersLog](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[EmployeeId] [int] NULL,
	[ChangedDate] [datetime2](7) NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[Notes] [varchar](255) NULL,
	[IsPosted] [bit] NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL,
 CONSTRAINT [PK_Queue_OrdersLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
