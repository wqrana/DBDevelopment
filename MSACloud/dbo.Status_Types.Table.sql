USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Status_Types]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status_Types](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status_Type] [varchar](50) NULL,
	[Admin_Status] [int] NULL,
 CONSTRAINT [PK_Status_Types] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
