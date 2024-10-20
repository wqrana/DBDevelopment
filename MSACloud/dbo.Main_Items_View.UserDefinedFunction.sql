USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Main_Items_View]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 05/09/2014
-- Description:	Returns the list of items given the order id and type
-- added id column  Abid - 5/16/2014
-- =============================================
CREATE FUNCTION [dbo].[Main_Items_View]
(
	-- Add the parameters for the function here
	@ClientID bigint,
	@OrderID int,
	@OrderType int
)
RETURNS 
@MyItems TABLE 
(
	-- Add the column definitions for the TABLE variable here
	id int,
	Qty int,
	ItemName varchar(75),
	PaidPrice decimal(15,2),
	Void bit,
	ServingDate datetime2(7),
	PickedupDate datetime2(7)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	IF (@OrderType = 0) BEGIN
		INSERT INTO @MyItems
		SELECT
			it.id,
			it.Qty,
			CASE 
				WHEN it.Menu_id < -1 THEN 'Misc. Item (' + RTRIM(STR(it.PaidPrice,10,2)) + ')'
				ELSE ISNULL(m.ItemName, 'Missing Item')
			END as ItemName,
			it.PaidPrice,
			it.isVoid,
			NULL as ServingDate,
			NULL as PickedupDate
		FROM Items it
			LEFT OUTER JOIN Menu m on m.ClientID = it.ClientID and m.id = it.Menu_Id
		WHERE it.ClientID = @ClientID and it.Order_Id = @OrderID
	END

	IF (@OrderType = 1) BEGIN
		INSERT INTO @MyItems
		SELECT
			poi.id,
			poi.Qty,
			CASE 
				WHEN poi.Menu_id < -1 THEN 'Misc. Item (' + RTRIM(STR(poi.PaidPrice,10,2)) + ')'
				ELSE ISNULL(m.ItemName, 'Missing Item')
			END as ItemName,
			poi.PaidPrice,
			poi.isVoid,
			poi.ServingDate,
			poi.PickupDate
		FROM PreOrderItems poi
			LEFT OUTER JOIN Menu m ON m.ClientID = poi.ClientID and m.Id = poi.Menu_Id
		WHERE poi.ClientID = @ClientID and poi.Preorder_Id = @OrderID
	END

	RETURN 
END
GO
