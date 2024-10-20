USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ClientID] [bigint] NOT NULL,
	[ErrorLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorDate] [datetime2](7) NOT NULL,
	[Number] [int] NOT NULL,
	[Object] [varchar](255) NULL,
	[Message] [varchar](1024) NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY NONCLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
