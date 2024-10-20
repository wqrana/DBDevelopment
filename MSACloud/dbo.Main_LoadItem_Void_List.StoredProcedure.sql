USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_LoadItem_Void_List]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-04-15
-- Description:	used to retreive the Ordered Item list for processing the Void Status

-- Modification History
/*
-- Author:		Waqar Q.
-- Create date: 2019-03-29
-- Description:	duplication issue in retrieving preorder items records
-- incase of pick then void then re-pick

*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_LoadItem_Void_List]
	-- Add the parameters for the stored procedure here
	@Preorder				AS varchar(4000)	= ''
	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
		    
	SELECT *
	FROM (
			SELECT  
               
                 preI.id													AS Id,  
                 p.id														AS PreorderId,  
                 c.LastName + ', ' + c.FirstName							AS CustomerName,  
                 c.id														AS customerId,  
                 c.UserID													AS UserID,  
                 g.Name														AS Grade,  
                 p.PreSaleTrans_Id											AS PreSaleTrans_Id,  
                 NULL														AS orderId,  
                 m.ItemName													AS ItemName,  
                 PurchasedDate												AS purchasedDate,  
                 preI.ServingDate											AS ServingDate,  
                 preI.Qty													AS Qty,  
                 CASE WHEN (i.Id IS NOT NULL AND i.isVoid = 0) 
				 THEN 'No' 
				 ELSE 'Yes' 
				 END														AS CanVoid,  
                 CASE WHEN (p.isVoid = 1 or preI.isVoid = 1) 
				 THEN 'VOID' 
				 ELSE NULL 
				 END														AS isVoid,
				 CASE 
				 WHEN preI.soldType = 10  
				 THEN 1 
				 ELSE 0 
				 END														AS isReimbursableItem,
				 preI.id													AS PreOrderItem_Id				
             FROM PreOrderItems preI    
             INNER JOIN PreOrders p ON preI.PreOrder_Id = p.Id    
             LEFT JOIN	items i		ON i.PreOrderItem_Id = preI.Id
									AND i.isVoid = 0	  
			 LEFT JOIN	Customers c ON p.Customer_Id = c.Id    
             LEFT JOIN	Grades g	ON c.Grade_Id = g.Id    
             LEFT JOIN	Menu m		ON preI.Menu_Id = m.Id    
             WHERE		p.Id IN   (SELECT * FROM  dbo.Report_fn_Split_Int(@Preorder,','))

             UNION  
			  
             SELECT   
                   
                 i.Id								AS Id,   
                 null								AS PreorderId,   
                 c.LastName + ', ' + c.FirstName	AS CustomerName,   
                 c.id								AS CustomerId,   
                 c.UserID							AS UserID,   
                 g.Name								AS Grade,   
                 NULL								AS PreSaleTrans_Id,   
                 o.id								AS OrderId,   
                 m.ItemName							AS ItemName,   
                 o.GDate							AS purchasedDate,   
                 NULL								AS ServingDate,   
                 i.Qty								AS Qty,   
                 'Yes'								AS canVoid,   
                 CASE 
				 WHEN (o.isVoid = 1 OR i.isVoid = 1) 
				 THEN 'VOID' 
				 ELSE NULL 
				 END								AS isVoid,
				 CASE
				 WHEN i.soldType = 10  
				 THEN 1 
				 ELSE 0 
				 END								AS isReimbursableItem,
				 i.PreOrderItem_Id   
             FROM Items i   
             INNER JOIN Orders o			ON i.Order_Id = o.Id   
             INNER JOIN PreOrderItems preI	ON preI.Id = i.PreOrderItem_Id  
             INNER JOIN PreOrders p			ON p.Id = preI.PreOrder_Id  
             LEFT JOIN	Customers c			ON o.Customer_Id = c.Id   
             LEFT JOIN	Grades g			ON c.Grade_Id = g.Id   
             LEFT JOIN	Menu m				ON i.Menu_Id = m.Id   
             WHERE		p.Id IN  (SELECT * FROM  dbo.Report_fn_Split_Int(@Preorder,','))

	)ItemForVoidList
	ORDER BY Id



END
GO
