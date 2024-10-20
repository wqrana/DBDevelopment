USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeBenefitEnlisted]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeBenefitEnlisted](
	[EmployeeBenefitEnlistedId] [int] IDENTITY(1,1) NOT NULL,
	[BenefitId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeBenefitEnlisted] PRIMARY KEY CLUSTERED 
(
	[EmployeeBenefitEnlistedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeBenefitEnlisted]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitEnlisted_dbo.Benefit_BenefitId] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[Benefit] ([BenefitId])
GO
ALTER TABLE [dbo].[EmployeeBenefitEnlisted] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitEnlisted_dbo.Benefit_BenefitId]
GO
