USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_VoidGroup_Detail]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Neil Heverly
-- Create date: 04/30/2014
-- Description:	Details for the Group Selected
-- =============================================
-- Revisions
-- 05/06/2016 - Added Cashier Name "ONLINE"
-- 21/06/2018 - Added IsNull for middle for Name field
-- =============================================
CREATE FUNCTION [dbo].[Admin_VoidGroup_Detail]
(
	@ClientID bigint,
	@GroupID int,
	@DateStart datetime,
	@DateEnd datetime,
	-- 0 - CASHIER, 1 - POS, 2 - CUSTOMER, 3 - SCHOOL
	@SearchBy int = 0
)
RETURNS 
@GroupDetails TABLE 
(
	OrderID int,
	OrderLogID int,
	OrderType int,
	Name varchar(max),
	OrderDate datetime,
	OrderDateLocal datetime,
	Item float,
	SalesTax float,
	Total float,
	Payment float,
	[Type] varchar(max),
	isVoid bit,
	[Check] varchar(max),
	--TransType int,
	POS varchar(max)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @GroupDetails
	SELECT
		ca.Id as OrderID,
		ca.OrdersLog_Id,
		ca.OrderType,
		CASE
			WHEN @SearchBy = 2 THEN 
				(
					CASE ca.Emp_Cashier_Id 
						WHEN -2 THEN 'Administrator' 
						WHEN -9 THEN 'ONLINE'
						ELSE ISNULL(ca.CashierName,'') 
					END)
			ELSE  (c.LastName + ', ' + c.FirstName + ISNULL(+' '+c.Middle,' ') ) 

			
		END as Name,
		ca.OrderDate,
		ca.OrderDateLocal,
		ca.Items,
		ca.SalesTax,
		ca.Credit as Total,
		ca.Debit as Payment,
		CASE
			WHEN ca.TransType = 1500 THEN 'ADJ' --Order of execution of code changed Zubair M: 3-3-2015
			WHEN ca.isVoid = 1 THEN 'VOID'
			WHEN ca.Debit < 0.0 THEN 'REF'
			ELSE ''
		END as Type,
		ca.isVoid as isVoid,
		ISNULL(CAST(ca.CheckNumber as varchar), '') as CheckNumber,
		--ca.Transtype,
		CASE ca.POS_Id WHEN -3 THEN 'ADMIN' ELSE ISNULL(p.Name, '') END as POS
	FROM CustomerActivity ca
		LEFT OUTER JOIN Customers c ON (c.ClientID = ca.ClientID AND c.Id = ca.Customer_Id)
		LEFT OUTER JOIN POS p ON (p.ClientID = ca.ClientID AND p.Id = ca.POS_Id)
		LEFT OUTER JOIN Customers e ON (e.ClientID = ca.ClientID AND e.Id = ca.Emp_Cashier_Id)
		LEFT OUTER JOIN Schools s ON (s.ClientID = ca.ClientID AND s.Id = ca.School_Id)
		
	WHERE ca.OrderDate between @DateStart AND @DateEnd 
	AND ca.ClientID = @ClientID
		and 
		(
			((@SearchBy = 0) AND (ca.Emp_Cashier_Id = @GroupID))
			OR
			((@SearchBy = 1) AND (ca.POS_Id = @GroupID))
			OR
			((@SearchBy = 2) AND (ca.Customer_Id = @GroupID))
			OR
			((@SearchBy = 3) AND (ca.School_Id = @GroupID))
		)
	ORDER BY ca.OrderDate desc

	RETURN 
END
GO
