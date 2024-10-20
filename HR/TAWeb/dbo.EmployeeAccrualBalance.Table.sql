USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeAccrualBalance]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAccrualBalance](
	[EmployeeAccrualBalanceId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualTypeId] [int] NOT NULL,
	[AccruedHours] [decimal](18, 2) NULL,
	[BalanceStartDate] [datetime] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAccrualBalance] PRIMARY KEY CLUSTERED 
(
	[EmployeeAccrualBalanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeAccrualBalance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAccrualBalance_dbo.AccrualType_AccrualTypeId] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[EmployeeAccrualBalance] CHECK CONSTRAINT [FK_dbo.EmployeeAccrualBalance_dbo.AccrualType_AccrualTypeId]
GO
