USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AppraisalSkill]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalSkill](
	[AppraisalSkillId] [int] IDENTITY(1,1) NOT NULL,
	[SkillName] [nvarchar](max) NOT NULL,
	[SkillDescription] [nvarchar](max) NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalSkill] PRIMARY KEY CLUSTERED 
(
	[AppraisalSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalSkill_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalSkill] CHECK CONSTRAINT [FK_dbo.AppraisalSkill_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
