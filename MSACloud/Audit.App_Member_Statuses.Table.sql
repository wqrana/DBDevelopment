USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Audit].[App_Member_Statuses]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Audit].[App_Member_Statuses](
	[Version] [int] NOT NULL,
	[Change_Date] [datetime2](7) NOT NULL,
	[Action] [char](1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[App_Member_Id] [bigint] NOT NULL,
	[Status_Type_Id] [int] NULL,
	[Direct_Cert_Id] [int] NULL,
	[Precertified] [bit] NULL,
 CONSTRAINT [PK_Audit_App_Member_Statuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
