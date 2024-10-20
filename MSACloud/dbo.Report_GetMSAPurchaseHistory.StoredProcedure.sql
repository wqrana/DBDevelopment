USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetMSAPurchaseHistory]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the MSA Orders purchase history report.
-- =============================================
CREATE PROC [dbo].[Report_GetMSAPurchaseHistory]
@CustomerId INT,
@StartDate Datetime2,
@EndDate Datetime2,
@ClientID BigINT
AS
BEGIN

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
		DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempMenuData', 'U') IS NOT NULL
	DROP TABLE #TempMenuData


	SELECT Id
		  ,District_Id
		  ,LastName
		  ,FirstName
		  ,UserID
	FROM Customers 
	WHERE Id = @CustomerId
	AND ClientID = @ClientID
	ORDER BY UserID

	Select d.Id,
		   d.DistrictName AS Name
    from District d
	INNER JOIN Customers c
	ON c.District_Id = d.Id
	where c.Id = @CustomerId
	AND c.ClientID = @ClientID

	SELECT poi.Id AS Id,
		   po.Customer_Id AS Student_Id,
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
	WHERE po.PurchasedDate >= @StartDate AND po.PurchasedDate <= @EndDate
	AND po.Customer_Id = @CustomerId
	AND po.ClientID = @ClientID
	ORDER BY po.PurchasedDate, poi.ServingDate

	SELECT DISTINCT m.Id
		  ,ClientID AS DistrictID
		  ,m.Category_Id
		  ,m.ItemName
		  ,m.StudentFullPrice
	INTO #TempMenuData
	FROM Menu m
	INNER JOIN #TempPreSaleTransactions temp
	ON m.Id = temp.MSA_Menu_Id
	WHERE m.ClientID = @ClientID
	ORDER BY m.ItemName

	SELECT DISTINCT cat.Id
		   ,cat.Id AS Dist_Category_Id
		   ,cat.ClientID AS DistrictID
		   ,cat.Name
	FROM
	Category cat
	INNER JOIN #TempMenuData temp
	ON temp.Category_Id = cat.Id
	WHERE cat.ClientID = @ClientID
	ORDER BY cat.Name

	SELECT * FROM #TempMenuData

	SELECT * FROM #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
		DROP TABLE #TempPreSaleTransactions

	IF OBJECT_ID('tempdb.dbo.#TempMenuData', 'U') IS NOT NULL
		DROP TABLE #TempMenuData
END
GO
