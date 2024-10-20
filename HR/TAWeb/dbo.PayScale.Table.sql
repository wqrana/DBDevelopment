USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PayScale]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayScale](
	[PayScaleId] [int] IDENTITY(1,1) NOT NULL,
	[PayScaleName] [nvarchar](50) NOT NULL,
	[RateFrequencyId] [int] NOT NULL,
	[LevelCount] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayScale] PRIMARY KEY CLUSTERED 
(
	[PayScaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayScale]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayScale_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayScale] CHECK CONSTRAINT [FK_dbo.PayScale_dbo.RateFrequency_RateFrequencyId]
GO
