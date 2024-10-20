USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeAppraisalGoal]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisalGoal](
	[EmployeeAppraisalGoalId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeAppraisalId] [int] NOT NULL,
	[AppraisalGoalId] [int] NOT NULL,
	[AppraisalRatingScaleDetailId] [int] NOT NULL,
	[GoalRatingName] [nvarchar](max) NULL,
	[GoalRatingValue] [decimal](18, 2) NOT NULL,
	[GoalScaleMaxValue] [decimal](18, 2) NOT NULL,
	[ReviewerComments] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisalGoal] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.AppraisalGoal_AppraisalGoalId] FOREIGN KEY([AppraisalGoalId])
REFERENCES [dbo].[AppraisalGoal] ([AppraisalGoalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.AppraisalGoal_AppraisalGoalId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.EmployeeAppraisal_EmployeeAppraisalId] FOREIGN KEY([EmployeeAppraisalId])
REFERENCES [dbo].[EmployeeAppraisal] ([EmployeeAppraisalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.EmployeeAppraisal_EmployeeAppraisalId]
GO
