USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[BonusPayments]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[BonusPayments](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[Customer_Id] [bigint] NOT NULL,
	[BonusDate] [datetime2](7) NOT NULL,
	[MealPlan] [int] NULL,
	[BonusPaid] [float] NULL,
	[PriorBal] [float] NULL,
	[Order_Id] [bigint] NULL,
	[BonusDateLocal] [datetime2](7) NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_BonusPayments] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[BonusPayments] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[BonusPayments] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[BonusPayments] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
