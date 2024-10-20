USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[LogonHistory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogonHistory](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[POS_Id] [bigint] NULL,
	[Employee_Id] [bigint] NULL,
	[LoginDate] [datetime2](7) NOT NULL,
	[LogoffDate] [datetime2](7) NULL,
 CONSTRAINT [PK_LogonHistory] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
