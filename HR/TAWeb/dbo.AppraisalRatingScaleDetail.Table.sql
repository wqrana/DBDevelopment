USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AppraisalRatingScaleDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalRatingScaleDetail](
	[AppraisalRatingScaleDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[RatingLevelId] [int] NOT NULL,
	[RatingValue] [decimal](18, 2) NOT NULL,
	[RatingName] [nvarchar](max) NOT NULL,
	[RatingDescription] [nvarchar](max) NULL,
	[RatingAbbreviation] [nvarchar](max) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalRatingScaleDetail] PRIMARY KEY CLUSTERED 
(
	[AppraisalRatingScaleDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail] CHECK CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.RatingLevel_RatingLevelId] FOREIGN KEY([RatingLevelId])
REFERENCES [dbo].[RatingLevel] ([RatingLevelId])
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail] CHECK CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.RatingLevel_RatingLevelId]
GO
