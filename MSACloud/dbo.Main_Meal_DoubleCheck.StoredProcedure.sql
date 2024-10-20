USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Meal_DoubleCheck]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[Main_Meal_DoubleCheck]
( 
	@ClientID bigint,
	@Customer_Id int,
	@Category_Id int,
	@OrderDate datetime
)
AS 
BEGIN
	DECLARE 
		@Valid int, 
		@Canfree bit, 
		@CanReduce bit
	
	SET @Valid = 1
	
	SELECT 
		@Canfree = ISNULL(canfree,0), 
		@CanReduce = ISNULL(canreduce,0) 
	from Category cat
		left outer join CategoryTypes ct on ct.ClientID = cat.ClientID and ct.id = cat.CategoryType_Id
	WHERE cat.ClientID = @ClientID and cat.id = @Category_id
	
	IF (@Canfree = 1 or @CanReduce = 1) BEGIN
		IF exists (SELECT it.menu_id from items it
						left outer join Orders o on o.id = it.Order_Id and o.ClientID = it.ClientID
						left outer join menu m on m.id = it.Menu_Id and m.ClientID = it.ClientID
						left outer join Category cat on cat.id = m.Category_Id and cat.ClientID = m.ClientID
					WHERE it.ClientID = @ClientID 
						and cat.id = @Category_Id
						and o.Customer_Id = @Customer_Id
						and CONVERT(VARCHAR(10),orderdate,101) = CONVERT(VARCHAR(10),cast(@orderdate as datetime),101)) 
		BEGIN
			SET @Valid = 0
		END
		ELSE BEGIN
			SET @Valid = 1
		END
	END
	ELSE BEGIN
		-- Set to 999 for infinite items (AlaCarte Items)
		SET @Valid = 999
	END	

	SELECT @Valid as Valid
END
GO
