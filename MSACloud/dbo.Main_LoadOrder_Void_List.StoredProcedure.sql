USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_LoadOrder_Void_List]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-04-14
-- Description:	used to retreive the Order list for processing the Void Status

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_LoadOrder_Void_List]
	-- Add the parameters for the stored procedure here
	@Preorder				AS varchar(4000)	= ''
	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
		  SELECT * 
		  FROM(
	
				SELECT  
                
                  po.Id														AS Id,  
                  po.PreSaleTrans_Id										AS PreSaleTrans_Id,  
                  NULL														AS OrderId,  
                  g.Name													AS Grade,  
                  c.LastName + ', ' + c.FirstName							AS CustomerName,  
                  c.UserID													AS UserID,  
                  CAST(CONVERT(VARCHAR, po.purchasedDate, 101) AS DATETIME) AS PurchasedDate,  
                  CASE po.isVoid WHEN 1 
				  THEN 'VOID' 
				   ELSE NULL 
				  END														AS Void,  
                  CASE 
					WHEN (pui.Number_Picked_up = 0 OR pui.OrderId IS NULL) 
					THEN 'Yes' 
					ELSE 'No' 
				  END														AS CanVoid,
				  NULL														AS HasPayment  
              FROM preorders po  
              LEFT JOIN Customers c ON c.Id = po.Customer_Id  
              LEFT JOIN Grades g	ON g.Id = c.Grade_Id  
              LEFT JOIN (  
                         SELECT  poi.PreOrder_Id AS OrderId, COUNT(*) AS Number_Picked_Up  
                         FROM items i  
                          LEFT JOIN Orders o ON o.id = i.Order_Id  
                          LEFT JOIN PreOrderItems poi on poi.Id = i.PreOrderItem_Id  
                          WHERE i.PreOrderItem_Id IS NOT NULL 
						  AND i.isVoid = 0 
						  AND o.isVoid = 0  
                          GROUP BY poi.PreOrder_Id  
                         ) pui		ON pui.OrderId = po.Id  
              WHERE  po.Id IN  (SELECT * FROM  dbo.Report_fn_Split_Int(@Preorder,','))
			 
              UNION  
			 
              SELECT  
                  
                  o.Id								AS Id,  
                  NULL								AS PreSaleTrans_Id,  
                  o.Id								AS OrderId,  
                  g.Name							AS Grade,  
                  c.LastName + ', ' + c.FirstName	AS CustomerName,  
                  c.UserID							AS UserID,  
                  o.GDate							AS PurchasedDate,  
                  CASE when (o.isVoid = 1) THEN 
				  'VOID' 
				  ELSE NULL 
				  END								AS Void,  
                  'Yes'								AS CanVoid,
				 CASE  
                 WHEN (o.MDebit + o.ADebit != 0)  
                 THEN 1
                 WHEN (SUBSTRING(CAST(o.TransType as varchar), 2, 1) != '0')  
                 THEN 1  
                 ELSE 0        		
                 END								AS HasPayment    
              FROM orders o  
              LEFT JOIN Customers c ON o.Customer_Id = c.Id  
              LEFT JOIN Grades g	ON c.Grade_Id = g.Id  
              WHERE  o.Id IN ( SELECT i.Order_Id  
                             FROM Items i  
                             INNER JOIN PreOrderItems poi ON poi.Id = i.PreOrderItem_Id  
                             WHERE poi.PreOrder_Id IN (SELECT * FROM  dbo.Report_fn_Split_Int(@Preorder,',')) ) 

	
		)OrderForVoidList
		ORDER BY Id
END
GO
