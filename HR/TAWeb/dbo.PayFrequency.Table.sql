USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[PayFrequency]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayFrequency](
	[PayFrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[PayFrequencyName] [nvarchar](50) NOT NULL,
	[PayFrequencyDescription] [nvarchar](200) NULL,
	[HourlyMultiplier] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayFrequency] PRIMARY KEY CLUSTERED 
(
	[PayFrequencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
