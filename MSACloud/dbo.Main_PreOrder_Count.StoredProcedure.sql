USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_Count]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-04-11
-- Description:	used to count the preorder list records

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_Count]
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
	@SelectedTypeList		AS varchar(4000)	= ''

		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	DECLARE @DateTypes AS TABLE ( TypeID BigInt)
	DECLARE @PreorderItemList AS TABLE ( Id BigInt)

	IF @DateRangeTypes <> ''
	BEGIN
		INSERT 
		INTO @DateTypes
		SELECT * FROM dbo.Report_fn_split_int(@DateRangeTypes,',')

	END
	declare	
		@selecteditems as table(id int)
	if(len(ltrim(rtrim(isnull(@SelectedTypeList, '')))) > 0)
	begin
		insert into @selecteditems
		SELECT * FROM dbo.Report_fn_Split_Int(@SelectedTypeList,',')
	end
	else
	begin
		insert into @selecteditems
		select id from menu where (isnull(isdeleted, 0) = 0)
	end
	-- recordCount
INSERT INTO @PreorderItemList

SELECT *

FROM
(
	SELECT poi.Id	          					 
     FROM PreOrderItems poi
     INNER JOIN PreOrders on poi.PreOrder_Id = Preorders.Id 
     INNER JOIN Customers on Preorders.Customer_Id = Customers.Id 
     LEFT JOIN (SELECT * 
				FROM Customer_School 
				WHERE Customer_School.isPrimary = 1
				) Customer_School ON Customers.Id = Customer_school.Customer_Id 
     LEFT JOIN	Schools ON Customer_school.School_Id = Schools.Id 
     INNER JOIN Menu on poi.Menu_Id = Menu.Id 
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
				 AND COALESCE(poi.ServingDate,'01/01/1900') BETWEEN @FromDate AND @ToDate)
			   )
	
			-- Pickup Date			
	AND		( (NOT EXISTS (SELECT * FROM @DateTypes WHERE TypeID='2') AND 1=1 )
				OR 
			 (EXISTS (SELECT * FROM @DateTypes WHERE TypeID='2') 
			  AND COALESCE(poi.PickupDate,'01/01/1900') BETWEEN @FromDate AND @ToDate)
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
	AND  COALESCE(poi.isVoid, -1) = CASE WHEN @ItemStatus = '1' THEN 0
													WHEN @ItemStatus = '2' THEN 1
													ELSE COALESCE(poi.isVoid, -1)
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
			--( @ItemSelectionType = '3' AND Menu.Id  IN (SELECT * FROM dbo.Report_fn_Split_Int(@SelectedTypeList,',')))
			( @ItemSelectionType = '3' AND Menu.Id  IN (SELECT * FROM @selecteditems))
					
		 )
) PreOrderData

-- Return count and id string
 SELECT  (SELECT COUNT(*) 
		  FROM @PreorderItemList		
		  )	AS recordCount
		  , 
			
			CAST (STUFF((
					SELECT		',' + convert(nvarchar(12),Id)
					FROM @PreorderItemList
					
					FOR XML PATH('')), 1, 1, ''
				) AS nvarchar(Max)) AS recordIdStr  


END
GO
