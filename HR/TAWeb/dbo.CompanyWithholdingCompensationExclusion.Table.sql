USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyWithholdingCompensationExclusion]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingCompensationExclusion](
	[CompanyWithholdingCompensationExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[CompanyCompensationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingCompensationExclusion] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingCompensationExclusionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyWithholdingCompensationExclusion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholdingCompensationExclusion_dbo.CompanyCompensation_CompanyCompensationId] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompanyWithholdingCompensationExclusion] CHECK CONSTRAINT [FK_dbo.CompanyWithholdingCompensationExclusion_dbo.CompanyCompensation_CompanyCompensationId]
GO
