USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WitholdingComputationType]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WitholdingComputationType](
	[WitholdingComputationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WitholdingComputationTypeName] [nvarchar](max) NOT NULL,
	[WitholdingComputationTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WitholdingComputationType] PRIMARY KEY CLUSTERED 
(
	[WitholdingComputationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
