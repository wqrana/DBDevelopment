USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeCompensationPreviousHistory]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompensationPreviousHistory](
	[EmployeeCompensationPreviousHistoryId] [int] NOT NULL,
	[PayDate] [datetime] NOT NULL,
	[PeriodWages] [decimal](18, 5) NOT NULL,
	[PeriodComissions] [decimal](18, 5) NOT NULL,
	[PeriodHours] [decimal](18, 2) NOT NULL,
	[UserInformationId] [int] NULL,
 CONSTRAINT [PK_tblUserCompensationsHistor] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompensationPreviousHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
