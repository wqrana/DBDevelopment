USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPunchPair_OverRide]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPunchPair_OverRide](
	[e_id] [int] NOT NULL,
	[DTPunchDate] [smalldatetime] NOT NULL,
	[DTimeIn] [smalldatetime] NOT NULL,
	[DTimeOut] [smalldatetime] NOT NULL,
	[sType] [nvarchar](30) NOT NULL,
	[nWeekID] [bigint] NULL,
	[nJobCodeID] [int] NULL,
	[New_DTimeIn] [smalldatetime] NULL,
	[New_DTimeOut] [smalldatetime] NULL,
	[New_nJobCodeID] [int] NULL,
	[New_HoursWorked] [float] NULL,
	[nEditType] [int] NULL,
	[nAdminID] [int] NULL,
 CONSTRAINT [PK_tPunchPair_OverRide] PRIMARY KEY CLUSTERED 
(
	[e_id] ASC,
	[DTPunchDate] ASC,
	[DTimeIn] ASC,
	[DTimeOut] ASC,
	[sType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
