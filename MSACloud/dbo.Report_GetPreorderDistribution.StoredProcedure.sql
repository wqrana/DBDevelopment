USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_GetPreorderDistribution]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Inayat H
-- Create date: 20-Nov-2017
-- Description:	Gets data for the preorder distribution report.
-- =============================================
CREATE PROC [dbo].[Report_GetPreorderDistribution]
--@StartDate Datetime2,
@fromdate datetime = null,
@todate datetime = null,
@ClientID BigINT
AS
BEGIN
IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
DROP TABLE #TempPreSaleTransactions

	-------------------- PreSaleTransactions----------------------
	SELECT poi.Id AS Id,
		   po.Customer_Id AS Student_Id,
		   po.PurchasedDate AS PurchaseDate,
		   poi.ServingDate AS ServingDate,
		   po.TransferDate AS TransferDate,
		   poi.PaidPrice AS Amount,
		   po.TransType AS TransType,
		   poi.Menu_Id AS MSA_Menu_Id,
		   poi.Qty AS Quantity,
		   poi.IsVoid
	INTO #TempPreSaleTransactions
	FROM Preorders po
	INNER JOIN PreorderItems poi
	ON poi.Preorder_Id = po.Id
	--WHERE poi.ServingDate = @StartDate
	WHERE (1 = 1)
	and ((dbo.dateonly(poi.ServingDate) >= dbo.dateonly(isnull(@fromdate, poi.ServingDate))) 
		and (dbo.dateonly(poi.ServingDate) <= dbo.dateonly(isnull(@todate, poi.ServingDate))))
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
	--WHERE d.ClientID = 9

	-------------------- Students----------------------
	SELECT DISTINCT c.Id
		  ,c.District_Id
		  ,c.LastName
		  ,c.FirstName
		  ,c.UserID
		  ,s.SchoolName
		  ,s.id as School_Id -- added by waqarQ 18032019 for filtering on school 
		  ,h.Name AS Homeroom
		  ,ISNULL(g.Name, 'None') AS Grade
	FROM Customers AS c
	INNER JOIN #TempPreSaleTransactions AS temp
	ON c.Id = temp.Student_Id
	LEFT OUTER JOIN Customer_School AS cs
	ON temp.Student_Id = cs.Customer_Id
	LEFT OUTER JOIN Schools AS s
	ON cs.School_Id = s.Id
	LEFT OUTER JOIN Homeroom AS h 
	ON c.Homeroom_Id = h.Id
	LEFT OUTER JOIN Grades AS g
	ON c.Grade_Id = g.Id
	WHERE c.ClientID = @ClientID
	AND c.Id IS NOT NULL
	AND cs.IsPrimary = 1
	ORDER BY s.SchoolName

	-------------------- Menu----------------------
	SELECT DISTINCT m.Id
		  ,m.ClientID AS DistrictID
		  ,m.Category_Id
		  ,m.ItemName
		  ,m.StudentFullPrice
	FROM Menu m
	INNER JOIN #TempPreSaleTransactions temp
	ON m.Id = temp.MSA_Menu_Id
	WHERE m.ClientID = @ClientID

	SELECT * FROM #TempPreSaleTransactions
	ORDER BY SERVINGDATE

	IF OBJECT_ID('tempdb.dbo.#TempPreSaleTransactions', 'U') IS NOT NULL
	DROP TABLE #TempPreSaleTransactions

END
GO
