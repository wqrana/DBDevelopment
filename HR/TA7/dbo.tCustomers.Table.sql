USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCustomers]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCustomers](
	[nCustomerID] [int] NOT NULL,
	[sCustomerName] [nvarchar](50) NULL,
	[sFirstName] [nvarchar](30) NULL,
	[sLastName] [nvarchar](50) NULL,
	[sBillingAddress1] [nvarchar](100) NULL,
	[sBillingAddress2] [nvarchar](100) NULL,
	[sCity] [nvarchar](50) NULL,
	[sStateOrProvince] [nvarchar](20) NULL,
	[sZIPCode] [nvarchar](20) NULL,
	[sEmail] [nvarchar](75) NULL,
	[sCompanyWebsite] [nvarchar](100) NULL,
	[sPhoneNumber] [nvarchar](30) NULL,
	[sFaxNumber] [nvarchar](30) NULL,
	[sShipAddress1] [nvarchar](100) NULL,
	[sShipAddress2] [nvarchar](100) NULL,
	[sShipCity] [nvarchar](50) NULL,
	[sShipStateOrProvince] [nvarchar](50) NULL,
	[sShipZIPCode] [nvarchar](20) NULL,
	[sShipPhoneNumber] [nvarchar](30) NULL,
	[sNotes] [nvarchar](100) NULL,
	[sCustomerPayCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Customers1] PRIMARY KEY CLUSTERED 
(
	[nCustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
