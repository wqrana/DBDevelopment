USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Withholding401KType]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withholding401KType](
	[Withholding401KTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Withholding401KTypeName] [nvarchar](150) NOT NULL,
	[Withholding401KTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Withholding401KType] PRIMARY KEY CLUSTERED 
(
	[Withholding401KTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
