USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ApplicantQAnswerOption]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantQAnswerOption](
	[ApplicantQAnswerOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewQuestionId] [int] NOT NULL,
	[AnswerOptionName] [nvarchar](200) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantQAnswerOption] PRIMARY KEY CLUSTERED 
(
	[ApplicantQAnswerOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ApplicantQAnswerOption]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantQAnswerOption_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId] FOREIGN KEY([ApplicantInterviewQuestionId])
REFERENCES [dbo].[ApplicantInterviewQuestion] ([ApplicantInterviewQuestionId])
GO
ALTER TABLE [dbo].[ApplicantQAnswerOption] CHECK CONSTRAINT [FK_dbo.ApplicantQAnswerOption_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId]
GO
