USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [DeletedMSA].[Schools]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DeletedMSA].[Schools](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] NOT NULL,
	[District_Id] [int] NOT NULL,
	[Emp_Director_Id] [int] NULL,
	[Emp_Administrator_Id] [int] NULL,
	[SchoolID] [varchar](30) NULL,
	[SchoolName] [varchar](60) NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone1] [varchar](14) NULL,
	[Phone2] [varchar](14) NULL,
	[Comment] [varchar](1000) NULL,
	[isSevereNeed] [bit] NULL,
	[isDeleted] [bit] NULL,
	[UseDistDirAdmin] [bit] NULL,
	[Forms_Director_Id] [int] NULL,
	[Forms_Admin_Id] [int] NULL,
	[UseDistFormsDirAdmin] [bit] NULL,
	[UseDistNameDirector] [bit] NULL,
	[UseDistNameAdmin] [bit] NULL,
	[Forms_Admin_Title] [varchar](60) NULL,
	[Forms_Admin_Phone] [varchar](15) NULL,
	[Forms_Dir_Title] [varchar](60) NULL,
	[Forms_Dir_Phone] [varchar](15) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Schools] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__isSev__67BF3949]  DEFAULT ((0)) FOR [isSevereNeed]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__isDel__68B35D82]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__UseDi__69A781BB]  DEFAULT ((1)) FOR [UseDistDirAdmin]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__UseDi__6A9BA5F4]  DEFAULT ((1)) FOR [UseDistFormsDirAdmin]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__UseDi__6B8FCA2D]  DEFAULT ((0)) FOR [UseDistNameDirector]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__UseDi__6C83EE66]  DEFAULT ((0)) FOR [UseDistNameAdmin]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__LastU__6D78129F]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__Updat__6E6C36D8]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [DeletedMSA].[Schools] ADD  CONSTRAINT [DF__tmp_ms_xx__Cloud__6F605B11]  DEFAULT ((0)) FOR [CloudIDSync]
GO
