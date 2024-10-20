USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AppraisalTemplateSkill]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalTemplateSkill](
	[AppraisalTemplateSkillId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalSkillId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalTemplateSkill] PRIMARY KEY CLUSTERED 
(
	[AppraisalTemplateSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalSkill_AppraisalSkillId] FOREIGN KEY([AppraisalSkillId])
REFERENCES [dbo].[AppraisalSkill] ([AppraisalSkillId])
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalSkill_AppraisalSkillId]
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
