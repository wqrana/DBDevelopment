USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[AHouseHoldID]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AHouseHoldID](
	[ClientID] [bigint] NOT NULL,
	[AvailHHID] [varchar](15) NULL,
	[Id] [int] NOT NULL,
	[District_Id] [int] NOT NULL,
 CONSTRAINT [PK_AHouseHoldID] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[District_Id] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
