USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeNotificationType]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeNotificationType](
	[EmployeeNotificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNotificationTypeName] [nvarchar](150) NOT NULL,
	[EmployeeNotificationTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeNotificationType] PRIMARY KEY CLUSTERED 
(
	[EmployeeNotificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
