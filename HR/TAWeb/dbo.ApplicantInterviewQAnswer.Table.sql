USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantInterviewQAnswer]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterviewQAnswer](
	[ApplicantInterviewQAnswerId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewId] [int] NOT NULL,
	[ApplicantQAnswerOptionId] [int] NULL,
	[AnswerValue] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterviewQAnswer] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewQAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantInterviewQAnswer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterviewQAnswer_dbo.ApplicantInterview_ApplicantInterviewId] FOREIGN KEY([ApplicantInterviewId])
REFERENCES [dbo].[ApplicantInterview] ([ApplicantInterviewId])
GO
ALTER TABLE [dbo].[ApplicantInterviewQAnswer] CHECK CONSTRAINT [FK_dbo.ApplicantInterviewQAnswer_dbo.ApplicantInterview_ApplicantInterviewId]
GO
ALTER TABLE [dbo].[ApplicantInterviewQAnswer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterviewQAnswer_dbo.ApplicantQAnswerOption_ApplicantQAnswerOptionId] FOREIGN KEY([ApplicantQAnswerOptionId])
REFERENCES [dbo].[ApplicantQAnswerOption] ([ApplicantQAnswerOptionId])
GO
ALTER TABLE [dbo].[ApplicantInterviewQAnswer] CHECK CONSTRAINT [FK_dbo.ApplicantInterviewQAnswer_dbo.ApplicantQAnswerOption_ApplicantQAnswerOptionId]
GO
