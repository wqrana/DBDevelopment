USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tGroupLeaderSupervisor]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tGroupLeaderSupervisor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nSupervisorID] [int] NULL,
	[sSupervisorName] [nvarchar](50) NULL,
	[nGroupLeaderID] [int] NULL,
	[sGroupLeaderName] [nvarchar](50) NULL,
	[nJobTitleID] [int] NULL,
	[sJobTitleName] [nvarchar](50) NULL,
 CONSTRAINT [PK_tGroupLeaderSupervisor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
