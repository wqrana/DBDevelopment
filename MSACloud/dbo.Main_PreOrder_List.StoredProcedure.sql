USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_List]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-04-04
-- Description:	used to retreive the preorder list for process

-- Modification History
-- Modification date: 2018-02-08
-- Description:	Reimbursable item logic is added

-- Modification History
-- Modification date: 2019-04-03
-- Description:	remove the extra parameters & Logic, for retrieving the preorder for pickup
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_List]
	-- Add the parameters for the stored procedure here
	@Location				AS varchar(4000)	= '',
	@DateRangeTypes			AS varchar(50)		= '',
	@FromDate				AS varchar(50)			,
	@ToDate					AS varchar(50)			,
	@homeRoom				AS varchar(4000)	= '',
	@CustomersSelectionType AS varchar(1)		= 'A',
	@CustomersList			AS varchar(4000)	= '',
	@Grade					AS varchar(4000)	= '',
	@ItemSelectionType		AS varchar(1)			,
	@ItemStatus				AS varchar(1)			,	
	@SelectedTypeList		AS varchar(4000)	= '',
	@PageNo					AS Int				= 1,
	@PageSize				AS Int				= 10000,
	@SortColumn				varchar(50)			= 'transactionId',
	@SortOrder				varchar(50)			= 'ASC'
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	DECLARE	@SkipRows	Int
	
	SET @SkipRows = (@PageNo - 1) * @PageSize 

	SET @SortColumn = LTRIM(RTRIM(@SortColumn))

	DECLARE @DateTypes AS TABLE ( TypeID BigInt)

	IF @DateRangeTypes <> ''
	BEGIN
		INSERT 
		INTO @DateTypes
		SELECT * FROM dbo.Report_fn_split_int(@DateRangeTypes,',')

	END


SELECT *

FROM
(

	 SELECT   Distinct
            	PreOrderItems.Id 			AS PreOrderItemId, 
                PreOrders.Id				AS preOrderId, 
            	PreOrders.PreSaleTrans_Id	AS transactionId, 
            	Grades.Name					AS Grade, 
            	Customers.LastName + ', ' + Customers.FirstName AS customerName, 
            	Customers.UserID 			AS userId,
				Category.CategoryType_Id,	 
				Category.Id AS Category_Id, 
            	Menu.ItemName 				AS	itemName, 
            	PreOrders.PurchasedDate		AS	datePurchased, 
            	PreOrderItems.ServingDate	AS	dateToServe, 
            	PreOrderItems.PickupDate	AS datePickedUp, 
            	CASE WHEN (PreOrderItems.PickupCount >= 0) THEN
					  PreOrderItems.PickupCount 
					 ELSE 
						0 
				END received, 
            	Preorderitems.isVoid AS itemVoid, 
                PreorderItems.qty, 
            	PreOrders.isVoid	AS orderVoid, 
                CASE WHEN (PreorderItems.isVoid = 1 or PreOrders.isVoid = 1) THEN 'VOID' END void,
				CASE WHEN PreorderItems.soldType = 10  THEN 1 ELSE 0 END isReimbursableItem
				 
     FROM PreOrderItems 
     INNER JOIN PreOrders on PreOrderItems.PreOrder_Id = Preorders.Id 
     INNER JOIN Customers on Preorders.Customer_Id = Customers.Id 
     LEFT JOIN (SELECT * 
				FROM Customer_School 
				WHERE Customer_School.isPrimary = 1
				) Customer_School ON Customers.Id = Customer_school.Customer_Id 
     LEFT JOIN	Schools ON Customer_school.School_Id = Schools.Id 
     INNER JOIN Menu on PreOrderItems.Menu_Id = Menu.Id 
     INNER JOIN Category on Menu.Category_Id = Category.Id 
     LEFT JOIN	Grades on Customers.Grade_Id = Grades.Id 

     WHERE    
	 	 
	  ( ( @Location = '' AND  1=1 ) --Location Condition
		OR 
		( @Location <> '' AND Schools.Id IN (SELECT value FROM dbo.Reporting_fn_Split(@Location,',')) )	
	  )	

	
			  -- Serve Date 		
	 AND	  ( (NOT EXISTS (SELECT * FROM @DateTypes WHERE TypeID='1') AND 1=1 )
				OR 
				(EXISTS (SELECT * FROM @DateTypes WHERE TypeID='1') 
				 AND COALESCE(PreOrderItems.ServingDate,'01/01/1900') BETWEEN @FromDate AND @ToDate)
			   )
	
			-- Pickup Date			
	AND		( (NOT EXISTS (SELECT * FROM @DateTypes WHERE TypeID='2') AND 1=1 )
				OR 
			 (EXISTS (SELECT * FROM @DateTypes WHERE TypeID='2') 
			  AND COALESCE(PreOrderItems.PickupDate,'01/01/1900') BETWEEN @FromDate AND @ToDate)
			) 
	
	
			-- Purchase Date	
	AND	  ( (NOT EXISTS (SELECT * FROM @DateTypes WHERE TypeID='3') AND 1=1)
			OR 
			(EXISTS (SELECT * FROM @DateTypes WHERE TypeID='3') 
			AND COALESCE(PreOrders.PurchasedDate,'01/01/1900') BETWEEN @FromDate AND @ToDate)
		   ) 
	
		   -- HomeRoom
	AND  (
			( @homeRoom = '' AND  1=1)
			OR 
			( @homeRoom <> '' AND Customers.HomeRoom_Id IN (SELECT * FROM dbo.Report_fn_Split_Int(@homeRoom,',')))
					
		 )
	
		 -- Customer			
	AND  (
			( @CustomersSelectionType = 'A' AND 1=1)
			OR 
			( @CustomersSelectionType = 'S' AND Customers.Id IN (SELECT * FROM dbo.Report_fn_Split_Int(@CustomersList,'|')))
					
		 )
	
		 -- Grade
	AND  (
			( @Grade = '' AND 1=1 )
			OR 
			( @Grade <> '' AND Customers.Grade_Id IN (SELECT * FROM dbo.Report_fn_Split_Int(@Grade,',')))
					
		 )
	-- Item Filter

	 -- Item Status
	AND  COALESCE(PreOrderItems.isVoid, -1) = CASE WHEN @ItemStatus = '1' THEN 0
													WHEN @ItemStatus = '2' THEN 1
													ELSE COALESCE(PreOrderItems.isVoid, -1)
												END	 
	

	-- Category Type
	AND  (
			( @ItemSelectionType <> '1' AND 1=1)
			OR 
			( @ItemSelectionType = '1' AND Category.CategoryType_Id IN (SELECT * FROM dbo.Report_fn_Split_Int(@SelectedTypeList,',')))
					
		 )
   -- Category
   AND  (
			( @ItemSelectionType <> '2' AND 1=1)
			OR 
			( @ItemSelectionType = '2' AND Category.Id IN (SELECT * FROM dbo.Report_fn_Split_Int(@SelectedTypeList,',')))
					
		 )
	-- Item
   AND  (
			( @ItemSelectionType <> '3' AND 1=1)
			OR 
			( @ItemSelectionType = '3' AND Menu.Id  IN (SELECT * FROM dbo.Report_fn_Split_Int(@SelectedTypeList,',')))
					
		 )
) PreOrderData

ORDER BY
		CASE WHEN (@SortColumn = 'transactionId' AND @SortOrder='ASC') THEN transactionId
        END ASC,
		CASE WHEN (@SortColumn = 'transactionId' AND @SortOrder='DESC') THEN transactionId
        END DESC,

		CASE WHEN (@SortColumn = 'Grade' AND @SortOrder='ASC') THEN Grade
        END ASC,
		CASE WHEN (@SortColumn = 'Grade' AND @SortOrder='DESC') THEN Grade
        END DESC,

		CASE WHEN (@SortColumn = 'customerName' AND @SortOrder='ASC') THEN customerName
        END ASC,
		CASE WHEN (@SortColumn = 'customerName' AND @SortOrder='DESC') THEN customerName
        END DESC,


		CASE WHEN (@SortColumn = 'userId' AND @SortOrder='ASC') THEN userId
        END ASC,
		CASE WHEN (@SortColumn = 'userId' AND @SortOrder='DESC') THEN userId
        END DESC,

		CASE WHEN (@SortColumn = 'itemName' AND @SortOrder='ASC') THEN itemName
        END ASC,
		CASE WHEN (@SortColumn = 'itemName' AND @SortOrder='DESC') THEN itemName
        END DESC,

		CASE WHEN (@SortColumn = 'datePurchased' AND @SortOrder='ASC') THEN datePurchased
        END ASC,
		CASE WHEN (@SortColumn = 'datePurchased' AND @SortOrder='DESC') THEN datePurchased
        END DESC,

		CASE WHEN (@SortColumn = 'dateToServe' AND @SortOrder='ASC') THEN dateToServe
        END ASC,
		CASE WHEN (@SortColumn = 'dateToServe' AND @SortOrder='DESC') THEN dateToServe
        END DESC,

		CASE WHEN (@SortColumn = 'datePickedUp' AND @SortOrder='ASC') THEN datePickedUp
        END ASC,
		CASE WHEN (@SortColumn = 'datePickedUp' AND @SortOrder='DESC') THEN datePickedUp
        END DESC,

		CASE WHEN (@SortColumn = 'received' AND @SortOrder='ASC') THEN received
        END ASC,
		CASE WHEN (@SortColumn = 'received' AND @SortOrder='DESC') THEN received
        END DESC,

		CASE WHEN (@SortColumn = 'qty' AND @SortOrder='ASC') THEN qty
        END ASC,
		CASE WHEN (@SortColumn = 'qty' AND @SortOrder='DESC') THEN qty
        END DESC,


		CASE WHEN (@SortColumn = 'void' AND @SortOrder='ASC') THEN void
        END ASC,
		CASE WHEN (@SortColumn = 'void' AND @SortOrder='DESC') THEN void
        END DESC,

		CASE WHEN (@SortColumn = 'isReimbursableItem' AND @SortOrder='ASC') THEN isReimbursableItem
        END ASC,
		CASE WHEN (@SortColumn = 'isReimbursableItem' AND @SortOrder='DESC') THEN isReimbursableItem
        END DESC

	

	OFFSET @SkipRows ROWS
	FETCH NEXT @PageSize ROWS ONLY
   

END
GO
