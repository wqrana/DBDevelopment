USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[App_Member_Incomes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[App_Member_Incomes](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[App_Member_Id] [bigint] NOT NULL,
	[Income_Type_Id] [int] NOT NULL,
	[Income] [float] NULL,
	[Frequency_Id] [int] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_App_Member_Incomes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[App_Member_Incomes] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[App_Member_Incomes] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[App_Member_Incomes] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
