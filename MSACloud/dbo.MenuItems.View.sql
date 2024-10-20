USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[MenuItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MenuItems]
AS
SELECT 
	m.Id as MENUID,
	cat.Id as CATID,
	ct.Id as CTID,
	m.ItemName,
	m.UPC,
	m.StudentFullPrice,
	m.StudentRedPrice,
	m.EmployeePrice,
	m.GuestPrice,
	cat.Name as CategoryName,
	ct.Name as CategoryTypeName,
	m.isTaxable,
	m.isDeleted,
	m.isScaleItem,
	m.ItemType,
	m.isOnceDay,
	CAST(CASE
		WHEN m.KitchenItem > 0 THEN 1
		ELSE 0
	END as BIT) as KitchenItem,
	m.MealEquivItem,
	m.PreOrderDesc,
	m.ButtonCaption,
	m.LastUpdate,
	ct.canFree,
	ct.canReduce,
	ct.isMealPlan,
	ct.isMealEquiv,
	CASE
		WHEN ct.canFree = 1 THEN '*'
		ELSE ' '
	END as FreeStatus,
	CASE
		WHEN ct.canReduce = 1 THEN '*'
		ELSE ' '
	END as RedStatus,
	CASE
		WHEN ct.isMealPlan = 1 THEN '*'
		ELSE ' '
	END as MealStatus
FROM Menu m
	LEFT OUTER JOIN Category cat ON cat.Id = m.Category_Id
	LEFT OUTER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
GO
