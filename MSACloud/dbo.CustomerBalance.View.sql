USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CustomerBalance]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 CREATE view [dbo].[CustomerBalance] 
 
 as 

 SELECT 
		ISNULL(ROW_NUMBER() OVER (order by "Customers"."UserID"),999)  as ROWID 
		,"Customers"."UserID"
		, "Customers"."LastName"
		, "Customers"."FirstName"
		, "Customers"."isActive"
		, "Customer_School"."isPrimary"
		, "Schools"."SchoolName"
		, "Grades"."Name" as 'Grade'
		, "Homeroom"."Name" as 'Homeroom'
		, ISNULL("AccountInfo"."ABalance",0) AS "ABalance"
		, ISNULL("AccountInfo"."MBalance",0) AS "MBalance"
		, ISNULL("AccountInfo"."BonusBalance",0) AS "BonusBalance"
		, "Schools"."ID" as  SCHID
		, ISNULL("Homeroom"."ID",0) as HRID
		, ISNULL("Grades"."ID",0) as GRID
		, "Customers"."ClientID"
		, ISNULL("Customers"."LunchType",4) as "LunchType"
		, "Customers"."ID" AS "CustomerID"
		

 FROM   (
			("dbo"."AccountInfo" "AccountInfo" RIGHT OUTER JOIN 
				(
					("dbo"."Customer_School" "Customer_School" LEFT OUTER JOIN "dbo"."Customers" "Customers" ON ("Customer_School"."Customer_Id"="Customers"."ID") AND ("Customer_School"."ClientID"="Customers"."ClientID") AND ("Customer_School"."IsPrimary" = 1)
				) 
				LEFT OUTER JOIN "dbo"."Schools" "Schools" ON ("Customer_School"."School_Id"="Schools"."ID") AND ("Customer_School"."ClientID"="Schools"."ClientID")
			) 
				ON ("AccountInfo"."ClientID"="Customers"."ClientID") AND ("AccountInfo"."Customer_Id"="Customers"."ID")
			) 
			LEFT OUTER JOIN "dbo"."Grades" "Grades" ON ("Customers"."Grade_Id"="Grades"."ID") AND ("Customers"."ClientID"="Grades"."ClientID")
		) LEFT OUTER JOIN "dbo"."Homeroom" "Homeroom" ON ("Customers"."Homeroom_Id"="Homeroom"."ID") AND ("Customers"."ClientID"="Homeroom"."ClientID")
 WHERE  "Customers"."ID" NOT IN (-3,-2)
GO
