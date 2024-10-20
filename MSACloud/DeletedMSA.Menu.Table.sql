USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [DeletedMSA].[Menu]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DeletedMSA].[Menu](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[Category_Id] [int] NOT NULL,
	[ItemName] [varchar](75) NOT NULL,
	[M_F6_Code] [varchar](15) NULL,
	[StudentFullPrice] [float] NULL,
	[StudentRedPrice] [float] NULL,
	[EmployeePrice] [float] NULL,
	[GuestPrice] [float] NULL,
	[isTaxable] [bit] NULL,
	[isDeleted] [bit] NULL,
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
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DeletedMSA].[Menu] ADD  CONSTRAINT [Menu_DefaultUpdateDate]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [DeletedMSA].[Menu] ADD  CONSTRAINT [DF__tmp_ms_xx__Updat__5E00C4E5]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [DeletedMSA].[Menu] ADD  CONSTRAINT [DF__tmp_ms_xx__Cloud__5EF4E91E]  DEFAULT ((0)) FOR [CloudIDSync]
GO
