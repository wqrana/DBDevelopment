USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[District_Id] [int] NOT NULL,
	[Parent_Id] [int] NOT NULL,
	[Household_Size] [int] NULL,
	[Homeless_On_App] [bit] NULL,
	[Migrant_On_App] [bit] NULL,
	[Runaway_On_App] [bit] NULL,
	[Beneficiary_Name] [varchar](75) NULL,
	[Case_Number] [varchar](50) NULL,
	[Total_Income] [float] NULL,
	[Total_Frequency_Id] [int] NULL,
	[Fee_Waiver] [bit] NULL,
	[Language_Id] [int] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
	[Entered] [bit] NOT NULL,
	[Updated] [bit] NULL,
	[DateEntered] [datetime2](7) NULL,
	[Printed] [bit] NULL,
	[PrintedDate] [datetime2](7) NULL,
 CONSTRAINT [PK_Applications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Applications] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[Applications] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[Applications] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
ALTER TABLE [dbo].[Applications] ADD  DEFAULT ((0)) FOR [Entered]
GO
