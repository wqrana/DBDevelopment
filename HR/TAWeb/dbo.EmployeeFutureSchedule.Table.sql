USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeFutureSchedule]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeFutureSchedule](
	[EmployeeFutureScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[StartDate] [datetime] NULL,
	[BaseScheduleId] [int] NULL,
	[Note] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeFutureSchedule] PRIMARY KEY CLUSTERED 
(
	[EmployeeFutureScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
