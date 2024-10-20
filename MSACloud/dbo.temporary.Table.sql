USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[temporary]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temporary](
	[ClientID] [bigint] NOT NULL,
	[HouseholdID] [varchar](15) NOT NULL,
	[Until] [smalldatetime] NULL,
	[Id] [int] NOT NULL,
	[District_Id] [int] NOT NULL,
 CONSTRAINT [PK_temporary] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
