USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_Report]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-05-15
-- Description:	used to retreive the preorder Report Data

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_Report]
	-- Add the parameters for the stored procedure here
	@PreorderIdsStr				AS varchar(4000)	= ''
	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	


	 SELECT   
            	PreOrderItems.Id,
				PreOrders.PreSaleTrans_Id	AS transactionId, 
            	Grades.Name					AS Grade, 
            	Customers.LastName + ', ' + Customers.FirstName AS customerName, 
            	Customers.UserID 			AS userId,
			
            	Menu.ItemName 				AS	itemName, 
            	PreOrders.PurchasedDate		AS	datePurchased, 
            	PreOrderItems.PickupDate	AS	datePickedUp, 
            
            	CASE WHEN (PreOrderItems.PickupCount >= 0) THEN
					  PreOrderItems.PickupCount 
					 ELSE 0 
				END						AS received, 
            	PreorderItems.qty		AS Ordered, 
            	
                CASE WHEN (PreorderItems.isVoid = 1 or PreOrders.isVoid = 1) THEN 'VOID' END void,
				PreorderItems.SoldType
				 
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

     WHERE     PreOrderItems.Id   IN (SELECT * FROM dbo.Report_fn_Split_Int(@PreorderIdsStr,','))

	 ORDER BY PreOrders.PreSaleTrans_Id
	
   

END
GO
