USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AppraisalTemplateGoal]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalTemplateGoal](
	[AppraisalTemplateGoalId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalGoalId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalTemplateGoal] PRIMARY KEY CLUSTERED 
(
	[AppraisalTemplateGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalGoal_AppraisalGoalId] FOREIGN KEY([AppraisalGoalId])
REFERENCES [dbo].[AppraisalGoal] ([AppraisalGoalId])
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalGoal_AppraisalGoalId]
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
