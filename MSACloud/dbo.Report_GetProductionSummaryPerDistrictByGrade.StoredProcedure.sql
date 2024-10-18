USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetProductionSummaryPerDistrictByGrade]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the preorder production summary per district by grade report.
-- =============================================
CREATE PROC [dbo].[Report_GetProductionSummaryPerDistrictByGrade]
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
		   po.PreSaleTrans_Id AS Transaction_Id,
		   po.PurchasedDate AS PurchaseDate,
		   poi.ServingDate AS ServingDate,
		   po.TransferDate AS TransferDate,
		   poi.PaidPrice AS Amount,
		   po.TransType AS TransType,
		   poi.Menu_Id AS MSA_Menu_Id,
		   poi.Qty AS Quantity
	INTO #TempPreSaleTransactions
	FROM Preorders AS po
	INNER JOIN PreorderItems AS poi
	ON poi.Preorder_Id = po.Id
	WHERE poi.ServingDate >= @StartDate AND poi.ServingDate <= @EndDate
	AND po.ClientID = @ClientID
	ORDER BY po.PreSaleTrans_Id

	-------------------- Districts----------------------
	Select DISTINCT d.Id,
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
		  ,ISNULL(g.Name, 'None') AS Grade 
	INTO #TempCustomers
	FROM Customers c
	INNER JOIN #TempPreSaleTransactions temp
	ON c.Id = temp.Student_Id
	LEFT OUTER JOIN Grades AS g
	ON c.Grade_Id = g.Id
	WHERE c.ClientID = @ClientID
	AND c.Id IS NOT NULL

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
	ORDER BY m.ItemName

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
