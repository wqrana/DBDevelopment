USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserSessionLogEvent]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSessionLogEvent](
	[UserSessionLogEventId] [int] IDENTITY(1,1) NOT NULL,
	[LogListing] [bit] NOT NULL,
	[LogView] [bit] NOT NULL,
	[LogAddOpen] [bit] NOT NULL,
	[LogAddSave] [bit] NOT NULL,
	[LogEditOpen] [bit] NOT NULL,
	[LogEditSave] [bit] NOT NULL,
	[LogDeleteOpen] [bit] NOT NULL,
	[LogDeleteSave] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserSessionLogEvent] PRIMARY KEY CLUSTERED 
(
	[UserSessionLogEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserSessionLogEvent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLogEvent_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserSessionLogEvent] CHECK CONSTRAINT [FK_dbo.UserSessionLogEvent_dbo.Company_CompanyId]
GO
