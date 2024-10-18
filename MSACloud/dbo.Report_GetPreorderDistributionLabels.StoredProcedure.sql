USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetPreorderDistributionLabels]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the preorder distribution labels report.
-- Report_GetPreorderDistributionLabels '20181010', '20190220', 9
-- =============================================
CREATE PROC [dbo].[Report_GetPreorderDistributionLabels]
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
		  ,h.Name AS Homeroom
	INTO #TempCustomers
	FROM Customers c
	INNER JOIN #TempPreSaleTransactions temp
	ON c.Id = temp.Student_Id
	LEFT OUTER JOIN Grades AS g
	ON c.Grade_Id = g.Id
	LEFT OUTER JOIN Homeroom AS h 
	ON c.Homeroom_Id = h.Id
	WHERE c.ClientID = @ClientID
	AND c.Id IS NOT NULL

	-------------------- Schools----------------------

	SELECT DISTINCT s.Id
		  ,s.SchoolID
		  ,s.SchoolName
		  ,s.ClientID AS District_Id
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
