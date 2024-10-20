USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Category_Id] [bigint] NOT NULL,
	[ItemName] [varchar](75) NOT NULL,
	[M_F6_Code] [varchar](15) NULL,
	[StudentFullPrice] [float] NULL,
	[StudentRedPrice] [float] NULL,
	[EmployeePrice] [float] NULL,
	[GuestPrice] [float] NULL,
	[isTaxable] [bit] NULL,
	[isDeleted] [bit] NOT NULL,
	[isScaleItem] [bit] NULL,
	[ItemType] [int] NULL,
	[isOnceDay] [bit] NULL,
	[KitchenItem] [int] NULL,
	[MealEquivItem] [bit] NULL,
	[UPC] [varchar](25) NULL,
	[PreOrderDesc] [varchar](256) NULL,
	[ButtonCaption] [varchar](30) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateLocal] [datetime2](7) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [isScaleItem]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [ItemType]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [isOnceDay]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [KitchenItem]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [MealEquivItem]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[Menu] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
