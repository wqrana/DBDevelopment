USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeWebTimeSheet]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWebTimeSheet](
	[EmployeeWebTimeSheetId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[PayWeekNumber] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RegularHours] [float] NULL,
	[MealHours] [float] NULL,
	[SingleOTHours] [float] NULL,
	[DoubleOTHours] [float] NULL,
	[OtherHours] [float] NULL,
	[HoursSummary] [nvarchar](250) NULL,
	[PayFrequencyId] [int] NULL,
	[ReviewStatusId] [int] NULL,
	[ReviewSupervisorId] [int] NULL,
	[IsLocked] [bit] NULL,
	[BaseScheduleId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeWebTimeSheet] PRIMARY KEY CLUSTERED 
(
	[EmployeeWebTimeSheetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
