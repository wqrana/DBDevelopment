USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblEvertecFTP]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEvertecFTP](
	[ID] [int] NOT NULL,
	[Protocol] [int] NOT NULL,
	[HostName] [nvarchar](100) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[SSHHostKey] [nvarchar](100) NOT NULL,
	[FileExtension] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblEvertecFTP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
