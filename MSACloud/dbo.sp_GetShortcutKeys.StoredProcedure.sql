USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetShortcutKeys]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetShortcutKeys]
(	
	@ClientID bigint,
	@Menustring varchar(Max)
)
AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #TempList
	(
		MenuId int,
		orderno int
	)

	DECLARE @MenuId varchar(10), @Pos int
	DECLARE @Orderno int
	
	SET @Orderno = 1
	SET @Menustring = LTRIM(RTRIM(@Menustring)) + ','
	SET @Pos = CHARINDEX(',', @Menustring, 1)

	IF REPLACE(@Menustring, ',', '') <> ''
	BEGIN
		WHILE @Pos > 0
		BEGIN
			SET @MenuId = LTRIM(RTRIM(LEFT(@Menustring, @Pos - 1)))
			IF @MenuId <> ''
			BEGIN
				INSERT INTO #TempList (MenuID, orderno) VALUES (CAST(@MenuId AS int),@orderno) --Use Appropriate conversion
				set @Orderno = @Orderno + 1
			END
			SET @Menustring = RIGHT(@Menustring, LEN(@Menustring) - @Pos)
			SET @Pos = CHARINDEX(',', @Menustring, 1)
		END
	END	
 

	SELECT  
		tl.menuid as id, 
		itemname,
		studentfullprice,
		studentredprice,
		employeeprice,
		guestprice,
		category_id ,
		color , 
		case when (canfree = 1 or canreduce = 1) then 1 else 0 end as viewskulimit, 
		buttoncaption   
	FROM #TempList tl 
		LEFT JOIN menu m on m.id = tl.menuid
		LEFT JOIN category cat on cat.Id = m.Category_Id and cat.ClientID = m.ClientID
		LEFT JOIN categorytypes ct on ct.Id = cat.CategoryType_Id and ct.ClientID = cat.ClientID
	WHERE m.ClientID = @ClientID
	ORDER BY tl.orderno
	
END
GO
