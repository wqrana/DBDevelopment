USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_MenuItem_List]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-11-09
-- Description:	used to retreive the menu items for filtering the  preorder list for detail

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_MenuItem_List]
	-- Add the parameters for the stored procedure here
	
	@categoryTypeID AS INT = NULL,
	@categoryID		AS INT = NULL

		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	

SELECT *
FROM(
	SELECT m.ID,m.ItemName
	FROM	dbo.Menu m
	INNER JOIN dbo.Category c ON m.Category_Id = c.ID
	INNER JOIN dbo.CategoryTypes ct ON c.CategoryType_Id = ct.ID
	WHERE  c.ID = ISNULL(@categoryID, c.ID)
	AND ct.ID = ISNULL(@categoryTypeID, ct.ID)
	AND m.isDeleted  = 0
	
	UNION
	
	SELECT m.ID,m.ItemName
	FROM	dbo.Menu m
	INNER JOIN dbo.Category c ON m.Category_Id = c.ID
	INNER JOIN dbo.CategoryTypes ct ON c.CategoryType_Id = ct.ID
	WHERE c.ID = ISNULL(@categoryID, c.ID)
	AND ct.ID = ISNULL(@categoryTypeID, ct.ID)
	AND m.isDeleted  = 1
	AND m.ID IN (   SELECT DISTINCT PreOrderItems.Menu_Id
					FROM PreOrderItems 
					INNER JOIN PreOrders on PreOrderItems.PreOrder_Id = Preorders.Id
					
				)

) AS MenuList
ORDER BY MenuList.ItemName

   

END
GO
