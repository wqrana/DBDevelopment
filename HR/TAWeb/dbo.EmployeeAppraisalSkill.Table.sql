USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeAppraisalSkill]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisalSkill](
	[EmployeeAppraisalSkillId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeAppraisalId] [int] NOT NULL,
	[AppraisalSkillId] [int] NOT NULL,
	[AppraisalRatingScaleDetailId] [int] NOT NULL,
	[SkillRatingName] [nvarchar](max) NULL,
	[SkillRatingValue] [decimal](18, 2) NOT NULL,
	[SkillScaleMaxValue] [decimal](18, 2) NOT NULL,
	[ReviewerComments] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisalSkill] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalRatingScaleDetail_AppraisalRatingScaleDetailId] FOREIGN KEY([AppraisalRatingScaleDetailId])
REFERENCES [dbo].[AppraisalRatingScaleDetail] ([AppraisalRatingScaleDetailId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalRatingScaleDetail_AppraisalRatingScaleDetailId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalSkill_AppraisalSkillId] FOREIGN KEY([AppraisalSkillId])
REFERENCES [dbo].[AppraisalSkill] ([AppraisalSkillId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalSkill_AppraisalSkillId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.EmployeeAppraisal_EmployeeAppraisalId] FOREIGN KEY([EmployeeAppraisalId])
REFERENCES [dbo].[EmployeeAppraisal] ([EmployeeAppraisalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.EmployeeAppraisal_EmployeeAppraisalId]
GO
