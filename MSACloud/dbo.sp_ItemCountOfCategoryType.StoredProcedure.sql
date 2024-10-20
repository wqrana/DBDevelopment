USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_ItemCountOfCategoryType]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Abid H 
-- Create date: 03/08/2016

-- =============================================
CREATE PROCEDURE [dbo].[sp_ItemCountOfCategoryType] 
	@ClientID bigint,
	@CategoryID bigint
	
AS
BEGIN

DEClare @ITEMSCount int = 0 

	/*select @ITEMSCount = count(it.id) 
from items it, menu m, Category cat, CategoryTypes ct
where 
it.menu_id = m.id and 
m.category_id = cat.id and
cat.categoryType_id = ct.id 
and ct.id = @CategoryID
and it.ClientID = @ClientID
and m.ClientId = @ClientID
and ct.ClientId = @ClientID
and cat.ClientId = @ClientID*/

select @ITEMSCount = count(m.id) 
from menu m, Category cat, CategoryTypes ct
where
m.category_id = cat.id and
cat.categoryType_id = ct.id 
and ct.id = @CategoryID
and m.ClientId = @ClientID
and ct.ClientId = @ClientID
and cat.ClientId = @ClientID
and isnull(cat.isDeleted,0) = 0 and cat.IsActive=1 and  m.IsDeleted=0

Select @ITEMSCount as itemsCount

END
GO
