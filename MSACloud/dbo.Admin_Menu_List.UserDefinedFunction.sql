USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Menu_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Abid H
-- Create date: 08/12/2015
-- Description:	Returns the Menu List 
-- =============================================
/* 
	Revisions: by farrukh m (allshore) on 05/05/16
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_Menu_List]
(	
	@ClientID BIGINT
    
)
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT 
		m.ClientID as ClientID,
		m.Id as MenuID,
		m.ItemName as MenuName,
		m.isDeleted as isMenuDeleted,
		m.Category_Id as CategoryId,
		m.UPC as UPC,
		m.isTaxable as isTaxable,
		m.KitchenItem as KitchenItem,
		m.isScaleItem as isScaleItem,
		c.CategoryType_Id as CategoryTypeId,
		c.Color as CategoryColor,
		c.Name as CategoryName
		
	FROM dbo.Menu m, dbo.category c
 	WHERE m.ClientID = @ClientID and c.ClientID = @ClientID
	and m.ClientID = c.ClientID
	and m.Category_Id = c.id
	and m.isDeleted != 1 and c.isDeleted != 1 
	
)
GO
