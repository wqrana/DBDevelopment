USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmailBlastDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailBlastDetail](
	[EmailBlastDetailId] [int] IDENTITY(1,1) NOT NULL,
	[EmailBlastId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[SentDate] [datetime] NULL,
	[ClientId] [int] NULL,
	[CompanyId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_EmailBlastDetail] PRIMARY KEY CLUSTERED 
(
	[EmailBlastDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
