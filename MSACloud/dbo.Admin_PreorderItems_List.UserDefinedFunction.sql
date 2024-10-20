USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_PreorderItems_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Admin_PreorderItems_List]
(
	@ClientID BIGINT ,
      @PreorderItemsIds VARCHAR(MAX) = '' ,
      @PageNo INT = 1 ,
      @PageSize INT = 10 ,
	
	/*– Sorting Parameters */
      @SortColumn VARCHAR(50) = 'CustomerName' ,
      @SortOrder VARCHAR(50) = 'ASC'
)
RETURNS @returntable TABLE
(
	AllRecordsCount int,
	Id BIGINT,
	PreOrderId BIGINT,
	PickupCountValid INT,
	Selected INT,
	TransactionId INT,
	Grade VARCHAR(15),
	CustomerName VARCHAR(50),
	UserId VARCHAR(16),
	CustomerId BIGINT,
	MealPlan_Id BIGINT NULL,
	ItemName VARCHAR(75),
	MenuId BIGINT,
	StudentFullPrice float NULL,
	Category_Id BIGINT,
	KitchenItem INT NULL,
	DatePurchased DATETIME2(7),
	DateToServe DATETIME2(7) NULL,
	DatePickedUp DATETIME2(7) NULL,
	Received INT NULL,
	ItemVoid BIT,
	Qty INT,
	OrderVoid BIT,
	Void VARCHAR(10),
	SchoolId BIGINT NULL,
	PickupQty INT NULL,
	isReimbursableItem INT NULL
)
AS
BEGIN
	DECLARE

	@lPageNbr INT,
    @lPageSize INT,
    @lSortCol NVARCHAR(50),
	@SkipRows INT

	
	SET @lPageNbr = @PageNo
    SET @lPageSize = @PageSize
    SET @lSortCol = LTRIM(RTRIM(@SortColumn))

	SET @SkipRows = (@lPageNbr - 1) * @lPageSize

	INSERT INTO @returntable
    SELECT    
				COUNT(1) OVER() as AllRecordsCount,
				PreOrderItems.Id Id ,
                PreOrders.Id PreOrderId ,
                1 PickupCountValid ,
                1 Selected ,
                PreOrders.PreSaleTrans_Id TransactionId ,
                Grades.Name Grade ,
                ISNULL(Customers.LastName, '') + ', '
                + ISNULL(Customers.FirstName, '') CustomerName ,
                Customers.UserID UserId ,
                Customers.Id CustomerId ,
                Customers.MealPlan_Id ,
                Menu.ItemName ItemName ,
                Menu.id MenuId ,
                Menu.StudentFullPrice ,
                Menu.Category_Id ,
                Menu.KitchenItem ,
                PreOrders.PurchasedDate DatePurchased ,
                PreOrderItems.ServingDate DateToServe ,
                PreOrderItems.PickupDate DatePickedUp ,
                CASE WHEN ( PreOrderItems.PickupCount >= 0 )
                     THEN ( SELECT  PreOrderItems.PickupCount
                          )
                     ELSE ( SELECT  0
                          )
                END Received ,
                Preorderitems.isVoid ItemVoid ,
                PreorderItems.qty Qty ,
                PreOrders.isVoid OrderVoid ,
                CASE WHEN ( PreorderItems.isVoid = 1
                            OR PreOrders.isVoid = 1
                          ) THEN ( SELECT   'VOID'
                                 )
                END Void ,
                Schools.id SchoolId ,
                PreorderItems.qty - PreorderItems.PickupCount PickupQty,
				CASE WHEN PreorderItems.soldType = 10  THEN 1 ELSE 0 END isReimbursableItem
      FROM      PreOrderItems
                INNER JOIN PreOrders ON PreOrderItems.PreOrder_Id = Preorders.Id
                INNER JOIN Customers ON Preorders.Customer_Id = Customers.Id
                LEFT JOIN ( SELECT  *
                            FROM    Customer_School
                            WHERE   Customer_School.isPrimary = 1
                          ) Customer_School ON Customers.Id = Customer_school.Customer_Id
                LEFT JOIN Schools ON Customer_school.School_Id = Schools.Id
                INNER JOIN Menu ON PreOrderItems.Menu_Id = Menu.Id
                INNER JOIN Category ON Menu.Category_Id = Category.Id
                LEFT JOIN Grades ON Customers.Grade_Id = Grades.Id
      WHERE     PreOrderItems.ClientID = @ClientID
                AND PreOrderItems.Id IN (
                SELECT  Value
                FROM    Reporting_fn_Split(@PreorderItemsIds, ',') )
				ORDER BY
				CASE WHEN (@lSortCol = 'TransactionId' AND @SortOrder = 'ASC') THEN PreSaleTrans_Id
				END ASC,
				CASE WHEN (@lSortCol = 'TransactionId' AND @SortOrder = 'DESC') THEN PreSaleTrans_Id
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'Grade' AND @SortOrder = 'ASC') THEN Grades.Name
				END ASC,
				CASE WHEN (@lSortCol = 'Grade' AND @SortOrder = 'DESC') THEN Grades.Name
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'CustomerName' AND @SortOrder = 'ASC') THEN Customers.LastName
				END ASC,
				CASE WHEN (@lSortCol = 'CustomerName' AND @SortOrder = 'DESC') THEN Customers.LastName
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'UserId' AND @SortOrder = 'ASC') THEN UserId
				END ASC,
				CASE WHEN (@lSortCol = 'UserId' AND @SortOrder = 'DESC') THEN UserId
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'ItemName' AND @SortOrder = 'ASC') THEN ItemName
				END ASC,
				CASE WHEN (@lSortCol = 'ItemName' AND @SortOrder = 'DESC') THEN ItemName
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'DatePurchased' AND @SortOrder = 'ASC') THEN PreOrders.PurchasedDate
				END ASC,
				CASE WHEN (@lSortCol = 'DatePurchased' AND @SortOrder = 'DESC') THEN PreOrders.PurchasedDate
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'DateToServe' AND @SortOrder = 'ASC') THEN PreOrderItems.ServingDate
				END ASC,
				CASE WHEN (@lSortCol = 'DateToServe' AND @SortOrder = 'DESC') THEN PreOrderItems.ServingDate
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'DatePickedUp' AND @SortOrder = 'ASC') THEN PreOrderItems.PickupDate
				END ASC,
				CASE WHEN (@lSortCol = 'DatePickedUp' AND @SortOrder = 'DESC') THEN PreOrderItems.PickupDate
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'Qty' AND @SortOrder = 'ASC') THEN PreorderItems.qty
				END ASC,
				CASE WHEN (@lSortCol = 'Qty' AND @SortOrder = 'DESC') THEN PreorderItems.qty
				END DESC,
				--------------------------------------------------------
				CASE WHEN (@lSortCol = 'Received' AND @SortOrder = 'ASC') THEN PreOrderItems.PickupCount
				END ASC,
				CASE WHEN (@lSortCol = 'Received' AND @SortOrder = 'DESC') THEN PreOrderItems.PickupCount
				END DESC,

				CASE WHEN (@lSortCol = 'isReimbursableItem' AND @SortOrder='ASC') THEN PreOrderItems.soldType
				END ASC,
				CASE WHEN (@lSortCol = 'isReimbursableItem' AND @SortOrder='DESC') THEN PreOrderItems.soldType
				END DESC


		OFFSET @SkipRows ROWS
		FETCH NEXT @lPageSize ROWS ONLY

		RETURN
END
GO
