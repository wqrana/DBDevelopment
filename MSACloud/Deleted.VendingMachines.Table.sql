USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[VendingMachines]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[VendingMachines](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[MachineName] [varchar](50) NOT NULL,
	[MachineID] [int] NOT NULL,
	[isDeleted] [bit] NOT NULL,
	[School_Id] [int] NOT NULL,
	[SerialNumber] [varchar](16) NULL,
	[Version] [varchar](8) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_VendingMachines] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[VendingMachines] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[VendingMachines] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[VendingMachines] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
