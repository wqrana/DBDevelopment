USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Stage].[TempItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stage].[TempItems](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[Order_Id] [int] NOT NULL,
	[Menu_Id] [int] NOT NULL,
	[Qty] [int] NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NULL,
	[SoldType] [int] NULL,
	[PreOrderItem_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
