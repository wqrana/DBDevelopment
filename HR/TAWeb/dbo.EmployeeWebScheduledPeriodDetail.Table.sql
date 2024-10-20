USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeWebScheduledPeriodDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWebScheduledPeriodDetail](
	[EmployeeWebScheduledPeriodDetailId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeWebScheduledPeriodId] [int] NULL,
	[UserInformationId] [int] NULL,
	[Note] [nvarchar](200) NULL,
	[NoOfPunch] [int] NULL,
	[PunchDate] [datetime] NULL,
	[TimeIn1] [datetime] NULL,
	[TimeOut1] [datetime] NULL,
	[TimeIn2] [datetime] NULL,
	[TimeOut2] [datetime] NULL,
	[WorkDayTypeId] [int] NULL,
	[DayHours] [float] NULL,
	[PayWeekNumber] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeWebScheduledPeriodDetail] PRIMARY KEY CLUSTERED 
(
	[EmployeeWebScheduledPeriodDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
