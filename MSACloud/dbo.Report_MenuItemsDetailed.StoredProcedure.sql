USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_MenuItemsDetailed]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_MenuItemsDetailed]
(
    @categoryid int = null
	, @categorytypeid int = null
)
AS
BEGIN
    SELECT mi.MENUID
		, mi.CATID
		, mi.CTID
		, mi.ItemName
		, mi.UPC
		, mi.StudentFullPrice
		, mi.StudentRedPrice
		, mi.EmployeePrice
		, mi.GuestPrice
		, mi.CategoryName
		, mi.CategoryTypeName, 

		CASE mi.isTaxable 
			WHEN 1 THEN 'Taxable	' 
			ELSE '' 
		END + CASE mi.isScaleItem 
			WHEN 1 THEN 'Scale Item	' 
			ELSE '' 
		END + CASE mi.ItemType 
			WHEN 2 THEN 'Breakfast Item	' 
			WHEN 1 THEN 'Lunch Item	'  
			ELSE '' 
		END + CASE mi.isOnceDay 
			WHEN 1 THEN 'Once Per Day	' 
			ELSE '' 
		END + CASE mi.KitchenItem 
			WHEN 1 THEN 'Kitchen Item	' 
			ELSE '' 
		END + CASE mi.MealEquivItem 
			WHEN 1 THEN 'Meal Equivalency Item	' 
			ELSE '' 
		END + CASE mi.canFree 
			WHEN 1 THEN 'Can Be Free	' 
			ELSE '' 
		END + CASE mi.canReduce 
			WHEN 1 THEN 'Can Be Reduced	' 
			ELSE '' 
		END + CASE mi.isMealPlan 
			WHEN 1 THEN 'Can Be Meal Plan Item	' 
			ELSE '' 
		END as MenuDetails, 

		mi.PreOrderDesc
		, mi.ButtonCaption
		--, mi.LastUpdate LastUpdate_Old
		, CONCAT(convert(varchar(32), mi.LastUpdate, 103), ' ', convert(varchar, mi.LastUpdate, 108), ' ', right(convert(varchar(30), mi.lastupdate, 9), 2)) LastUpdate

		FROM MenuItems mi 

		WHERE (1 = 1)
		and mi.isDeleted = 0 
		AND (mi.CATID = isnull(@categoryid, mi.CATID))
		AND (mi.CTID = isnull(@categorytypeid, mi.CTID))
		ORDER BY mi.ItemName, mi.CategoryName, mi.CategoryTypeName
END
GO
