USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AppraisalGoal]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalGoal](
	[AppraisalGoalId] [int] IDENTITY(1,1) NOT NULL,
	[GoalName] [nvarchar](max) NOT NULL,
	[GoalDescription] [nvarchar](max) NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalGoal] PRIMARY KEY CLUSTERED 
(
	[AppraisalGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalGoal_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalGoal] CHECK CONSTRAINT [FK_dbo.AppraisalGoal_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
