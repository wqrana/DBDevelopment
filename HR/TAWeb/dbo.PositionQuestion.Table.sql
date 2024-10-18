USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PositionQuestion]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionQuestion](
	[PositionQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[ApplicantInterviewQuestionId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PositionQuestion] PRIMARY KEY CLUSTERED 
(
	[PositionQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PositionQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionQuestion_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId] FOREIGN KEY([ApplicantInterviewQuestionId])
REFERENCES [dbo].[ApplicantInterviewQuestion] ([ApplicantInterviewQuestionId])
GO
ALTER TABLE [dbo].[PositionQuestion] CHECK CONSTRAINT [FK_dbo.PositionQuestion_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId]
GO
ALTER TABLE [dbo].[PositionQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionQuestion_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionQuestion] CHECK CONSTRAINT [FK_dbo.PositionQuestion_dbo.Position_PositionId]
GO
