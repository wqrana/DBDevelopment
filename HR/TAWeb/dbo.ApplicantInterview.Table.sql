USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantInterview]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterview](
	[ApplicantInterviewId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewQuestionId] [int] NOT NULL,
	[ApplicantAnswer] [nvarchar](max) NULL,
	[ApplicantInterviewAnswerId] [int] NULL,
	[InterviewAnswerValue] [float] NULL,
	[InterviewAnswerMaxValue] [float] NULL,
	[Note] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterview] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantInterview]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewAnswer_ApplicantInterviewAnswerId] FOREIGN KEY([ApplicantInterviewAnswerId])
REFERENCES [dbo].[ApplicantInterviewAnswer] ([ApplicantInterviewAnswerId])
GO
ALTER TABLE [dbo].[ApplicantInterview] CHECK CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewAnswer_ApplicantInterviewAnswerId]
GO
ALTER TABLE [dbo].[ApplicantInterview]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId] FOREIGN KEY([ApplicantInterviewQuestionId])
REFERENCES [dbo].[ApplicantInterviewQuestion] ([ApplicantInterviewQuestionId])
GO
ALTER TABLE [dbo].[ApplicantInterview] CHECK CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId]
GO
