USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[TransactionConfiguration]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionConfiguration](
	[TransactionConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[ConfigurationName] [nvarchar](max) NULL,
	[ConfigurationCode] [int] NOT NULL,
	[ConfigurationDescription] [nvarchar](max) NULL,
	[ProcessCodeId] [int] NOT NULL,
	[IsAbsent] [bit] NOT NULL,
	[AttendanceCategoryId] [int] NOT NULL,
	[PrimaryTransactionId] [int] NOT NULL,
	[AccrualTypeId] [int] NOT NULL,
	[AccrualImportName] [nvarchar](max) NULL,
	[AttendanceRevision] [bit] NOT NULL,
	[AttendanceRevisionLetter] [bit] NOT NULL,
	[TardinessRevision] [bit] NOT NULL,
	[TardinessRevisionLetter] [bit] NOT NULL,
	[PayRateMultiplierId] [int] NOT NULL,
	[VacationAccrualTypeId] [int] NOT NULL,
	[CompensationAccrualTypeId] [int] NULL,
	[SickAccrualTypeId] [int] NULL,
	[AdditionalPayAmount] [nvarchar](max) NULL,
	[IsMoneyTrans] [bit] NOT NULL,
	[IsMoneyAmountFixed] [bit] NOT NULL,
	[MoneyAmount] [decimal](18, 2) NOT NULL,
	[CompforCompensationAccrual] [nvarchar](max) NULL,
	[PayRateOffset] [decimal](18, 2) NOT NULL,
	[PayRateTransaction] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TransactionConfiguration] PRIMARY KEY CLUSTERED 
(
	[TransactionConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.AccrualType_AccrualTypeId] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.AccrualType_AccrualTypeId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.CompensationAccrualType_CompensationAccrualTypeId] FOREIGN KEY([CompensationAccrualTypeId])
REFERENCES [dbo].[CompensationAccrualType] ([CompensationAccrualTypeId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.CompensationAccrualType_CompensationAccrualTypeId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PayRateMultiplier_PayRateMultiplierId] FOREIGN KEY([PayRateMultiplierId])
REFERENCES [dbo].[PayRateMultiplier] ([PayRateMultiplierId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PayRateMultiplier_PayRateMultiplierId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PrimaryTransaction_PrimaryTransactionId] FOREIGN KEY([PrimaryTransactionId])
REFERENCES [dbo].[PrimaryTransaction] ([PrimaryTransactionId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PrimaryTransaction_PrimaryTransactionId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.ProcessCode_ProcessCodeId] FOREIGN KEY([ProcessCodeId])
REFERENCES [dbo].[ProcessCode] ([ProcessCodeId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.ProcessCode_ProcessCodeId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.SickAccrualType_SickAccrualTypeId] FOREIGN KEY([SickAccrualTypeId])
REFERENCES [dbo].[SickAccrualType] ([SickAccrualTypeId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.SickAccrualType_SickAccrualTypeId]
GO
ALTER TABLE [dbo].[TransactionConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.VacationAccrualType_VacationAccrualTypeId] FOREIGN KEY([VacationAccrualTypeId])
REFERENCES [dbo].[VacationAccrualType] ([VacationAccrualTypeId])
GO
ALTER TABLE [dbo].[TransactionConfiguration] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.VacationAccrualType_VacationAccrualTypeId]
GO
