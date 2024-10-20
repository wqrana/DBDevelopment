USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PayScaleLevel]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayScaleLevel](
	[PayScaleLevelId] [int] IDENTITY(1,1) NOT NULL,
	[PayScaleId] [int] NOT NULL,
	[PayScaleLevelRate] [decimal](18, 2) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayScaleLevel] PRIMARY KEY CLUSTERED 
(
	[PayScaleLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayScaleLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayScaleLevel_dbo.PayScale_PayScaleId] FOREIGN KEY([PayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[PayScaleLevel] CHECK CONSTRAINT [FK_dbo.PayScaleLevel_dbo.PayScale_PayScaleId]
GO
