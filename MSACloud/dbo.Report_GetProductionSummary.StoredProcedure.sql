USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetProductionSummary]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the preorder production summary report.
-- =============================================
CREATE PROC [dbo].[Report_GetProductionSummary]
@StartDate Datetime2,
@EndDate Datetime2,
@ClientID BigINT
AS
BEGIN

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
	DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempMenu', 'U') IS NOT NULL
	DROP TABLE #TempMenu

	IF OBJECT_ID('tempdb.dbo.#TempCustomers', 'U') IS NOT NULL
	DROP TABLE #TempCustomers

	-------------------- PreSaleTransactions----------------------
	SELECT poi.Id AS Id,
		   po.Customer_Id AS Student_Id,
		   po.PurchasedDate AS PurchaseDate,
		   poi.ServingDate AS ServingDate,
		   po.TransferDate AS TransferDate,
		   poi.PaidPrice AS Amount,
		   po.TransType AS TransType,
		   poi.Menu_Id AS MSA_Menu_Id,
		   poi.Qty AS Quantity
	INTO #TempPreSaleTransactions
	FROM Preorders po
	INNER JOIN PreorderItems poi
	ON poi.Preorder_Id = po.Id
	WHERE poi.ServingDate >= @StartDate AND poi.ServingDate <= @EndDate
	AND po.ClientID = @ClientID

	-------------------- Districts----------------------
	Select TOP 1 d.ClientId AS Id,
		   d.DistrictName AS Name
    from District d
	INNER JOIN Customers c
	ON c.District_Id = d.Id
	INNER JOIN #TempPreSaleTransactions temp
	ON c.Id = temp.Student_Id
	WHERE d.ClientID = @ClientID

	-------------------- Students----------------------
	SELECT DISTINCT c.Id
		  ,c.District_Id
		  ,c.LastName
		  ,c.FirstName
		  ,c.UserID
		  ,cs.School_Id
	INTO #TempCustomers
	FROM Customers c
	INNER JOIN #TempPreSaleTransactions temp
	ON c.Id = temp.Student_Id
	INNER JOIN Customer_School cs
	ON temp.Student_Id = cs.Customer_Id
	WHERE c.ClientID = @ClientID
	AND cs.IsPrimary = 1

	-------------------- Schools----------------------

	SELECT DISTINCT s.Id
		  ,s.SchoolID
		  ,s.SchoolName
	FROM Schools AS s
	INNER JOIN Customer_School AS cs
	ON s.Id = cs.School_Id
	INNER JOIN #TempCustomers AS c
	ON cs.Customer_Id = c.Id
	WHERE s.ClientID = @ClientID

	-------------------- Menu----------------------
	SELECT DISTINCT m.Id
		  ,m.ClientID AS DistrictID
		  ,m.Category_Id
		  ,m.ItemName
		  ,m.StudentFullPrice
	INTO #TempMenu
	FROM Menu m
	INNER JOIN #TempPreSaleTransactions temp
	ON m.Id = temp.MSA_Menu_Id
	WHERE m.ClientID = @ClientID

	-------------------- Category----------------------
	SELECT DISTINCT cat.Id
		   ,cat.Id AS Dist_Category_Id
		   ,cat.ClientID AS DistrictID
		   ,cat.Name
	FROM
	Category cat
	INNER JOIN #TempMenu temp
	ON cat.Id = temp.Category_Id
	WHERE cat.ClientID = @ClientID

	------------------------------------------

	SELECT * FROM #TempMenu

	SELECT * FROM #TempCustomers

	SELECT * FROM #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
	DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempMenu', 'U') IS NOT NULL
	DROP TABLE #TempMenu

	IF OBJECT_ID('tempdb.dbo.#TempCustomers', 'U') IS NOT NULL
	DROP TABLE #TempCustomers
END
GO
