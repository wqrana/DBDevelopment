USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmploymentStatus]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentStatus](
	[EmploymentStatusId] [int] IDENTITY(1,1) NOT NULL,
	[EmploymentStatusName] [nvarchar](50) NOT NULL,
	[EmploymentStatusDescription] [nvarchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentStatus] PRIMARY KEY CLUSTERED 
(
	[EmploymentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmploymentStatus]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentStatus_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[EmploymentStatus] CHECK CONSTRAINT [FK_dbo.EmploymentStatus_dbo.Client_ClientId]
GO
