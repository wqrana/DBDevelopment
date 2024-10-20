USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[SystemOptions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemOptions](
	[ClientID] [bigint] NOT NULL,
	[PackageType] [int] NULL,
	[Discount] [bit] NULL,
	[AllowCreditCard] [bit] NULL,
	[AllowVending] [bit] NULL,
	[UsingPreOrder] [bit] NULL,
	[MSADistrictID] [int] NULL,
	[PreOrderUserName] [varchar](50) NULL,
	[PreOrderPassword] [varchar](50) NULL,
	[POPickupMode] [int] NULL,
	[AutoReCalc] [int] NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_SystemOptions] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [PackageType]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [AllowCreditCard]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [AllowVending]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [UsingPreOrder]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [POPickupMode]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [AutoReCalc]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[SystemOptions] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
