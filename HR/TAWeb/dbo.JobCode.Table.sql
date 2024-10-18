USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[JobCode]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobCode](
	[JobCodeId] [int] IDENTITY(1,1) NOT NULL,
	[JobCodeName] [nvarchar](50) NOT NULL,
	[JobCodeDescription] [nvarchar](200) NULL,
	[Enabled] [bit] NOT NULL,
	[ProjectId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobCode] PRIMARY KEY CLUSTERED 
(
	[JobCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobCode]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobCode_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[JobCode] CHECK CONSTRAINT [FK_dbo.JobCode_dbo.Client_ClientId]
GO
