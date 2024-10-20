USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompensationTransaction]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationTransaction](
	[CompensationTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyCompensationId] [int] NULL,
	[TransactionConfigurationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationTransaction] PRIMARY KEY CLUSTERED 
(
	[CompensationTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompensationTransaction_dbo.CompanyCompensation_CompanyCompensationId] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_dbo.CompensationTransaction_dbo.CompanyCompensation_CompanyCompensationId]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompensationTransaction_dbo.TransactionConfiguration_TransactionConfigurationId] FOREIGN KEY([TransactionConfigurationId])
REFERENCES [dbo].[TransactionConfiguration] ([TransactionConfigurationId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_dbo.CompensationTransaction_dbo.TransactionConfiguration_TransactionConfigurationId]
GO
