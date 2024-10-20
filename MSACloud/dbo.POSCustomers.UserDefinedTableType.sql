USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[POSCustomers]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[POSCustomers] AS TABLE(
	[Cloud_Cust_Id] [int] NULL,
	[Local_Id] [int] NULL,
	[Cloud_School_Id] [int] NULL,
	[Cloud_District_Id] [int] NULL,
	[Cloud_MealPlan_Id] [int] NULL,
	[UserID] [varchar](16) NULL,
	[PIN] [varchar](16) NULL,
	[LastName] [varchar](30) NULL,
	[FirstName] [varchar](30) NULL,
	[Middle] [varchar](1) NULL,
	[Lunchtype] [int] NULL,
	[DOB] [datetime] NULL,
	[AllowAlaCarte] [bit] NULL,
	[CashOnly] [bit] NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[Grade] [varchar](15) NULL,
	[Homeroom] [varchar](15) NULL,
	[SchoolName] [varchar](60) NULL,
	[DistrictName] [varchar](30) NULL,
	[MealsLeft] [int] NULL,
	[ABalance] [smallmoney] NULL,
	[MBalance] [smallmoney] NULL,
	[BonusBalance] [smallmoney] NULL,
	[TotalBalance] [smallmoney] NULL
)
GO
