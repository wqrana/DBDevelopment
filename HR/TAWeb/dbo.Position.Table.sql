USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionId] [int] IDENTITY(1,1) NOT NULL,
	[PositionName] [varchar](50) NOT NULL,
	[PositionDescription] [varchar](200) NULL,
	[PositionCode] [varchar](50) NULL,
	[DefaultPayScaleId] [int] NULL,
	[DefaultEEOCategoryId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Position] PRIMARY KEY CLUSTERED 
(
	[PositionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.EEOCategory_DefaultEEOCategoryId] FOREIGN KEY([DefaultEEOCategoryId])
REFERENCES [dbo].[EEOCategory] ([EEOCategoryId])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.EEOCategory_DefaultEEOCategoryId]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.PayScale_DefaultPayScaleId] FOREIGN KEY([DefaultPayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.PayScale_DefaultPayScaleId]
GO
