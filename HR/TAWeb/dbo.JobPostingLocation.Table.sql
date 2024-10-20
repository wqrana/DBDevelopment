USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[JobPostingLocation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingLocation](
	[JobPostingLocationId] [int] IDENTITY(1,1) NOT NULL,
	[JobPostingDetailId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobPostingLocation] PRIMARY KEY CLUSTERED 
(
	[JobPostingLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobPostingLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingLocation_dbo.JobPostingDetail] FOREIGN KEY([JobPostingDetailId])
REFERENCES [dbo].[JobPostingDetail] ([JobPostingDetailId])
GO
ALTER TABLE [dbo].[JobPostingLocation] CHECK CONSTRAINT [FK_dbo.JobPostingLocation_dbo.JobPostingDetail]
GO
ALTER TABLE [dbo].[JobPostingLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingLocation_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[JobPostingLocation] CHECK CONSTRAINT [FK_dbo.JobPostingLocation_dbo.Location_LocationId]
GO
