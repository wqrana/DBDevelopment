USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblTAESignature]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTAESignature](
	[intTAESignID] [varchar](50) NOT NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[intMonth] [int] NOT NULL,
	[intYear] [int] NOT NULL,
	[dtEmployeeDateTime] [datetime] NULL,
	[strEmployeeEntry] [nvarchar](200) NULL,
	[bitEmployeeSigned] [bit] NULL,
	[dtSupervisorDateTime] [datetime] NULL,
	[strSupervisorEntry] [nvarchar](200) NULL,
	[bitSupervisorSigned] [bit] NULL,
	[intSupervisorID] [int] NULL,
 CONSTRAINT [PK_tblTAESignature] PRIMARY KEY CLUSTERED 
(
	[intTAESignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
