USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeTimeOffRequest]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeOffRequest](
	[EmployeeTimeOffRequestId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualType] [nvarchar](max) NULL,
	[TransType] [nvarchar](max) NULL,
	[IsSingleDay] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DayHours] [decimal](18, 2) NULL,
	[WorkingDays] [decimal](18, 2) NULL,
	[RequestNote] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeTimeOffRequest] PRIMARY KEY CLUSTERED 
(
	[EmployeeTimeOffRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest] CHECK CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest] CHECK CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.UserInformation_UserInformationId]
GO
