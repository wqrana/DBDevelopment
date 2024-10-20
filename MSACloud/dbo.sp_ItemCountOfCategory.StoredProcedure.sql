USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_ItemCountOfCategory]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid H 
-- Create date: 03/08/2016
-- Revision: Farrukh M. on 05/05/16 to fix PA-514
-- =============================================
CREATE PROCEDURE [dbo].[sp_ItemCountOfCategory] 
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
and cat.id = @CategoryID
and it.ClientID = @ClientID
and m.ClientId = @ClientID
and ct.ClientId = @ClientID
and cat.ClientId = @ClientID*/

select @ITEMSCount = count(m.id) 
from  menu m, Category cat, CategoryTypes ct
where 
m.category_id = cat.id and
cat.categoryType_id = ct.id 
and cat.id = @CategoryID
and m.ClientId = @ClientID
and ct.ClientId = @ClientID
and cat.ClientId = @ClientID


Select @ITEMSCount as itemsCount

END
GO
