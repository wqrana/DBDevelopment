USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomerBalanceData]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 10-Aug-2016
-- Description:	This function returns all customers along with their balances for Customer Balance Report.
-- =============================================
CREATE FUNCTION [dbo].[CustomerBalanceData]
    (
      @ClientID BIGINT ,
      @CustList VARCHAR(2048) = '' ,
      @SchList VARCHAR(2048) = '' ,
      @GRList VARCHAR(2048) = '' ,
      @HRList VARCHAR(2048) = '' ,
      @StartDate DATETIME = '1/1/1900' ,
      @EndDate DATETIME = '1/1/1900'
    )
RETURNS @CustBalances TABLE
    (
      ROWID INT ,
      UserID [varchar](16) ,
      LastName [varchar](24) ,
      FirstName [varchar](16) ,
      isActive [bit] ,
      isPrimary [bit],
      SchoolName [varchar](60) ,
      Grade [varchar](15) ,
      Homeroom [varchar](10),
      ABalance float ,
      MBalance float ,
      BonusBalance float ,
      SCHID [bigint] ,
      HRID  [bigint],
      GRID [bigint],
      ClientID [bigint] ,
      LunchType [int],
      CustomerID [bigint]
    )
AS
    BEGIN
	
        DECLARE @BalancesTable TABLE
            (
              Customer_id INT ,
              ABalance DECIMAL(20, 2) ,
              MBalance DECIMAL(20, 2) ,
              BonusBalance DECIMAL(20, 2) ,
              Balance DECIMAL(20, 2)
            )
	
        INSERT  INTO @BalancesTable
                SELECT  Customer_Id ,
                        ABalance ,
                        MBalance ,
                        BonusBalance ,
                        Balance
                FROM    dbo.CustomerBalances(@ClientID, @CustList, @SchList,
                                             @GRList, @HRList, DEFAULT, 1, 0,
                                             0, @StartDate, @EndDate, DEFAULT,
                                             @EndDate, 1)
	
        INSERT  INTO @CustBalances
                SELECT  ISNULL(ROW_NUMBER() OVER ( ORDER BY "Customers"."UserID" ),
                               999) AS ROWID ,
                        "Customers"."UserID" ,
                        "Customers"."LastName" ,
                        "Customers"."FirstName" ,
                        "Customers"."isActive" ,
                        "Customer_School"."isPrimary" ,
                        "Schools"."SchoolName" ,
                        "Grades"."Name" AS 'Grade' ,
                        "Homeroom"."Name" AS 'Homeroom' ,
                        ISNULL("AccountInfo"."ABalance", 0) AS "ABalance" ,
                        ISNULL("AccountInfo"."MBalance", 0) AS "MBalance" ,
                        ISNULL("AccountInfo"."BonusBalance", 0) AS "BonusBalance" ,
                        "Schools"."ID" AS SCHID ,
                        ISNULL("Homeroom"."ID", 0) AS HRID ,
                        ISNULL("Grades"."ID", 0) AS GRID ,
                        "Customers"."ClientID" ,
                        ISNULL("Customers"."LunchType", 4) AS "LunchType" ,
                        "Customers"."ID" AS "CustomerID"

                FROM    ( ( @BalancesTable "AccountInfo"
                            LEFT OUTER JOIN ( ( "dbo"."Customer_School" "Customer_School"
                                                 LEFT OUTER JOIN "dbo"."Customers" "Customers" ON ( "Customer_School"."Customer_Id" = "Customers"."ID" )
                                                              AND ( "Customer_School"."ClientID" = "Customers"."ClientID" )
                                                              AND ( "Customer_School"."IsPrimary" = 1 )
                                               )
                                               LEFT OUTER JOIN "dbo"."Schools" "Schools" ON ( "Customer_School"."School_Id" = "Schools"."ID" )
                                                              AND ( "Customer_School"."ClientID" = "Schools"."ClientID" )
                                             ) ON /*("AccountInfo"."ClientID"="Customers"."ClientID") AND*/ ( "AccountInfo"."Customer_Id" = "Customers"."ID" )
                          )
                          LEFT OUTER JOIN "dbo"."Grades" "Grades" ON ( "Customers"."Grade_Id" = "Grades"."ID" )
                                                              AND ( "Customers"."ClientID" = "Grades"."ClientID" )
                        )
                        LEFT OUTER JOIN "dbo"."Homeroom" "Homeroom" ON ( "Customers"."Homeroom_Id" = "Homeroom"."ID" )
                                                              AND ( "Customers"."ClientID" = "Homeroom"."ClientID" )
                WHERE   "Customers"."ID" NOT IN ( -3, -2 )

        RETURN
    END
GO
