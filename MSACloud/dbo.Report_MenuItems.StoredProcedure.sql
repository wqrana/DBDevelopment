USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_MenuItems]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_MenuItems]
(
    @categoryid int = null
	, @categorytypeid int = null
)
AS
BEGIN
    SELECT 
		mi.MENUID, 
		mi.CATID, 
		mi.CTID, 
		mi.ItemName, 
		mi.UPC, 
		mi.StudentFullPrice, 
		mi.StudentRedPrice, 
		mi.EmployeePrice, 
		mi.GuestPrice, 
		mi.CategoryName, 
		mi.CategoryTypeName, 
		CASE mi.isTaxable 
			WHEN 1 THEN '*' 
			ELSE '' 
		END as Taxable, 
		CASE mi.isScaleItem 
			WHEN 1 THEN '*' 
			ELSE '' 
		END as ScaleItem, 
		CASE mi.ItemType 
			WHEN 2 THEN 'Breakfast Item' 
			WHEN 1 THEN 'Lunch Item' 
			ELSE 'N/A' 
		END as ItemType, 
		CASE mi.isOnceDay 
			WHEN 1 THEN '*' 
			ELSE '' 
		END as OncePerDay, 
		CASE mi.KitchenItem 
			WHEN 1 THEN '*' 
			ELSE '' 
		END as KitchenItem, 
		CASE mi.MealEquivItem 
			WHEN 1 THEN '*' 
			ELSE '' 
		END as MealEquivItem, 
		mi.PreOrderDesc, 
		mi.ButtonCaption, 
		mi.LastUpdate, 
		mi.FreeStatus, 
		mi.RedStatus, 
		mi.MealStatus 
	FROM MenuItems mi 
	WHERE (1 = 1)
	AND (mi.isDeleted = 0)
	AND (mi.CATID = isnull(@categoryid, mi.CATID))
	AND (mi.CTID = isnull(@categorytypeid, mi.CTID))
	ORDER BY mi.ItemName, mi.CategoryName, mi.CategoryTypeName
END
GO
