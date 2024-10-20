USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Categories_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid
-- Create date: 01/16/2017
-- Description:	Returns categories list
-- Modification History
-- Updated @PageSize value, if ALL option as -1 in paramenter , bug 2357, 22/6/2018
-- select * from Admin_Categories_List(44,-999, -999, 4, 3,'catName', 'ASC')
-- =============================================
 
CREATE FUNCTION [dbo].[Admin_Categories_List]
(
	@ClientID bigint,
	@CategoryID bigint,
	@categoryTypeID bigint,

	/*– Pagination Parameters */
	@PageNo INT = 1,
	@PageSize INT = 10,
	
	/*– Sorting Parameters */
	@SortColumn varchar(50) = 'catName',
	@SortOrder varchar(50) = 'ASC'

)
RETURNS @MyCatList TABLE(
	
	totalCount int,
	catID bigint,
	catName varchar(50), 
	catTypeName varchar(50), 
	catColor varchar(50), 
	ItemCount int
	)
AS
BEGIN

DECLARE

	@lPageNbr INT,
    @lPageSize INT,
    @lSortCol NVARCHAR(20),
	@SkipRows INT

	IF (@PageSize = -1 )	SET @PageSize = 650000
	SET @lPageNbr = @PageNo
    SET @lPageSize = @PageSize
    SET @lSortCol = LTRIM(RTRIM(@SortColumn))

	SET @SkipRows = (@lPageNbr - 1) * @lPageSize 

	
	INSERT INTO @MyCatList
	select 
	totalCount,
	catID, 
	catName,
	catTypeName,
	catColor,
	ItemCount from 
	(
	select 
	COUNT(1) OVER() as totalCount,
	isNULL(cat.ID,0) as catID, 
	cat.name as catName, 
	catType.name catTypeName, 
	cat.Color as catColor, 
	(select count(id) from menu where ClientID = @ClientID and IsDeleted=0 and category_id=cat.ID)  as ItemCount
	from 
	category cat
	left join menu m on m.category_id = cat.id  
	inner join CategoryTypes catType on  cat.CategoryType_id = catType.ID
	where cat.ClientID = @ClientID and isnull(cat.isDeleted,0) = 0 and cat.IsActive= (case when @categoryTypeID = -999 then cat.IsActive else 1 end) --due to bug 1620 , case added for bug 2696
	and ( cat.ID = @CategoryID OR @CategoryID = -999) --due to bug 1620 
	and ( cat.CategoryType_Id = @categoryTypeID OR @categoryTypeID = -999)
	--and m.IsDeleted=0
	group by cat.ID, cat.name, catType.name, cat.Color
	) as subQuery

	ORDER BY 
		CASE WHEN (@lSortCol = 'catName' AND @SortOrder='ASC') THEN catName
        END ASC,
        CASE WHEN (@lSortCol = 'catName' AND @SortOrder='DESC') THEN catName
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'catTypeName' AND @SortOrder='ASC') THEN catTypeName
        END ASC,
        CASE WHEN (@lSortCol = 'catTypeName' AND @SortOrder='DESC') THEN catTypeName
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'ItemCount' AND @SortOrder='ASC') THEN ItemCount
        END ASC,
        CASE WHEN (@lSortCol = 'ItemCount' AND @SortOrder='DESC') THEN ItemCount
        END DESC
		----------

		OFFSET @SkipRows ROWS
		FETCH NEXT @lPageSize ROWS ONLY

	RETURN
END
GO
