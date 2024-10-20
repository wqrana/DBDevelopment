USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_MultiBuySellItemRules]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Adeel Siddiqui      
-- Create date: 19-JUL-2018    
-- Description: Check wether item can be bought in Multibuy by specific customer or not.      
-- =============================================      
-- =============================================

CREATE PROCEDURE [dbo].[Admin_MultiBuySellItemRules] (
	--DECLARE -- NH - Parameters to Pass
	@pCustomerId BIGINT -- Customer ID
	,@pDate VARCHAR(50) -- Date of Order
	,@pMenuId BIGINT -- NH (Menu Id of item being bought)
	,@pCount INT OUTPUT
	,@errMsg NVARCHAR(4000) OUTPUT
	)
AS
BEGIN
	DECLARE @errorMsg NVARCHAR(600)
		,@count INT
		,@IsStudent BIT
		,@CategoryTypeId INT

	/* Test Data
----case 1
--SET @pCategoryTypeId=1
--SET @pCustomerId=1391

----case 2
--SET @pItemId = 77 --or 79
--SET @pCategoryId = 8 --or 3
--SET @pCategoryTypeId = 3 --or 1
--SET @pCustomerId = 612 --or 593
--SET @pPOSId = 32
--SET @pDate = '2016-03-15'

--select * from Category
--select * from CategoryTypes
--select * from Menu where IsOnceDay=1
--select * from Customers
--select top 100 * from Orders
--select top 100 * from Items
*/
	--	,@categoryTypeId INT
	--SET @errMsg = ''
	--SET @pCount = 0
	SET @CategoryTypeId = 0

	SELECT @CategoryTypeId = c.CategoryType_Id
	FROM Menu M
	INNER JOIN Category C ON M.Category_Id = C.Id
	WHERE M.Id = @pMenuId

	SELECT @pCount = count(ID)
	FROM CategoryTypes
	WHERE ID = @CategoryTypeId
		AND (
			canFree = 1
			OR canReduce = 1
			)

	SELECT @IsStudent = IsStudent
	FROM Customers
	WHERE ID = @pCustomerId

	--SELECT @IsStudent
	--	,@pCount
	IF (
			@IsStudent = 0
			AND @pCount > 0
			)
	BEGIN
		SET @errMsg = 'Qualified items only being sold to students'
		RETURN
	END

	/*
Apply Taxes??
*/
	/*
case 2
Checking to ensure Student has not previously purchased an item from a Qualified Category already
Previously Purchased -> Make sure that this customer does not have any orders with a Qualified Item in the same category per day
                                   -> (ex. Customer bought a breakfast today.  Customer cannot buy another Breakfast today, but can buy a Lunch)
*/
	/*
case 3
Adhering to Once per Day Rules
Once per Day Rules -> If menu item is marked in menu table with isOncePerDay, then a customer can only buy the item once a day.
*/

--select @CategoryTypeId

	SET @count=0
	SELECT @count = count(O.ID)
	FROM Orders O
	INNER JOIN Items I ON O.Id = I.Order_Id
	INNER JOIN Menu M ON M.Id = I.Menu_Id
		AND M.Id = @pMenuId
	INNER JOIN Category C ON C.ID = M.Category_Id
	INNER JOIN CategoryTypes CT ON CT.Id = C.CategoryType_Id
	WHERE CAST(O.OrderDate AS DATE) = CAST(@pDate AS DATE)
		AND O.Customer_Id = @pCustomerId 
		 AND  CT.ID=@CategoryTypeId
		--AND O.POS_Id = @pPOSId
		--AND C.Id = @pCategoryId
		--AND CT.Id = @pCategoryTypeId
		AND (
			CT.canFree = 1
			OR CT.canReduce = 1
			--OR M.IsOnceDay = 1
			)
		
--select @count

	SELECT @pCount = count(O.ID)
	FROM Orders O
	INNER JOIN Items I ON O.Id = I.Order_Id
	INNER JOIN Menu M ON M.Id = I.Menu_Id
		--AND M.Id = @pMenuId
	INNER JOIN Category C ON C.ID = M.Category_Id
	INNER JOIN CategoryTypes CT ON CT.Id = C.CategoryType_Id and CT.ID=@CategoryTypeId
	WHERE CAST(O.OrderDate AS DATE) = CAST(@pDate AS DATE)
		AND O.Customer_Id = @pCustomerId
		--AND O.POS_Id = @pPOSId
		--AND C.Id = @pCategoryId
		--AND CT.Id = @pCategoryTypeId
		AND (
			CT.canFree = 1
			OR CT.canReduce = 1
			OR M.IsOnceDay = 1
			)

--select @pCount

	IF (@pCount > 0 or @count > 0)
	BEGIN
		SET @errMsg = 'Item can only be bought once for a day'

		RETURN
	END
			--SELECT @errorMsg AS Message  -- NH (Do not need to return result set, use the output variables for status)
END
GO
