USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetMSADistributionCoupons]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the MSA Distribution Coupons report.
-- =============================================
CREATE PROC [dbo].[Report_GetMSADistributionCoupons]
@CustomerId INT,
@StartDate Datetime2,
@EndDate Datetime2,
@ClientID BigINT
AS
BEGIN

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
	DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempCustomers', 'U') IS NOT NULL
	DROP TABLE #TempCustomers

	------------- PresaleTransactions----------

	SELECT poi.Id AS Id,
		   po.Customer_Id AS Student_Id,
		   po.PreSaleTrans_Id AS Transaction_Id,
		   po.PurchasedDate AS PurchaseDate,
		   poi.ServingDate AS ServingDate,
		   po.TransferDate AS TransferDate,
		   po.TransType AS TransType,
		   poi.Menu_Id AS MSA_Menu_Id,
		   poi.Qty AS Quantity,
		   poi.IsVoid
	INTO #TempPreSaleTransactions
	FROM Preorders po
	INNER JOIN PreorderItems poi
	ON poi.Preorder_Id = po.Id
	INNER JOIN Customer_School AS cs
	ON po.Customer_Id = cs.Customer_Id
	WHERE poi.ServingDate >= @StartDate AND poi.ServingDate <= @EndDate
	AND po.Customer_Id = @CustomerId
	AND po.ClientID = @ClientID
	AND cs.IsPrimary = 1
	ORDER BY po.PreSaleTrans_Id

	------------------- Students ----------------

	SELECT c.Id
		  ,c.District_Id
		  ,c.LastName
		  ,c.FirstName
		  ,c.UserID
		  ,ISNULL(g.Name, 'None') AS Grade
		  ,cs.School_Id
	INTO #TempCustomers
	FROM Customers c
	INNER JOIN Customer_School AS cs
	ON c.Id = cs.Customer_Id
	LEFT OUTER JOIN Grades AS g
	ON c.Grade_Id = g.Id
	WHERE c.Id = @CustomerId
	AND c.ClientID = @ClientID
	AND c.Id IS NOT NULL
	AND cs.IsPrimary = 1
	ORDER BY c.Id

	-------------------- Schools ----------------------

	SELECT DISTINCT s.Id
		  ,s.SchoolID
		  ,s.SchoolName
	FROM Schools AS s
	INNER JOIN Customer_School AS cs
	ON s.Id = cs.School_Id
	INNER JOIN #TempCustomers AS c
	ON cs.Customer_Id = c.Id
	WHERE cs.IsPrimary = 1
	AND s.ClientID = @ClientID

	------------------- Districts ---------------

	Select d.Id,
		   d.DistrictName AS Name
    from District d
	INNER JOIN Customers c
	ON c.District_Id = d.Id
	where c.Id = @CustomerId
	AND c.ClientID = @ClientID

	--------------------Menu-----------------

	SELECT DISTINCT m.Id
		  ,ClientID AS DistrictID
		  ,m.Category_Id
		  ,m.ItemName
		  ,m.StudentFullPrice
	FROM Menu m
	INNER JOIN #TempPreSaleTransactions temp
	ON m.Id = temp.MSA_Menu_Id
	WHERE m.ClientID = @ClientID
	ORDER BY m.ItemName

	----------------------------------------
	SELECT * FROM #TempCustomers

	SELECT * FROM #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
	DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempCustomers', 'U') IS NOT NULL
	DROP TABLE #TempCustomers

END
GO
