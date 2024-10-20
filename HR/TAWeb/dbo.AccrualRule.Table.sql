USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AccrualRule]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRule](
	[AccrualRuleId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleName] [nvarchar](max) NULL,
	[AccrualRuleDescription] [nvarchar](max) NULL,
	[ReferenceTypeId] [int] NULL,
	[BeginningOfYearDate] [datetime] NULL,
	[AccrualTypeId] [int] NULL,
	[AccrualTypeUnavailable] [nvarchar](max) NULL,
	[AccrualPeriodTypeId] [int] NULL,
	[AccumulationTypeId] [int] NULL,
	[AccumulationMultiplier] [float] NULL,
	[UseYearsWorked] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRule] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccrualRule]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRule_dbo.AccrualType_AccrualTypeId] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[AccrualRule] CHECK CONSTRAINT [FK_dbo.AccrualRule_dbo.AccrualType_AccrualTypeId]
GO
