USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[App_Member_Statuses]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[App_Member_Statuses](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[App_Member_Id] [bigint] NOT NULL,
	[Status_Type_Id] [int] NULL,
	[Direct_Cert_Id] [int] NULL,
	[Precertified] [bit] NULL,
 CONSTRAINT [PK_App_Member_Statuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
