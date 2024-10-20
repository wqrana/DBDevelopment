USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetPreOrderDetailOnDateRange]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================  
-- Author      : Adeel Siddiqui  
-- Create date : 05-MAR-2018  
-- Description : Return PreOrder detail on the basis of @PreSale_Id  
-- ================================================================  
Create PROCEDURE [dbo].[GetPreOrderDetailOnDateRange]   
 -- Add the parameters for the stored procedure here  
 @DateFrom date,  
 @DateTo date
AS  
BEGIN  
select PO.*,POI.Id as PreOrderItemsID,POI.IsVoid as POIIsVoid,PreSale_Id from PreOrderItems POI   
inner join PreOrders PO on PO.ID=POI.PreOrder_ID  
where
POI.ServingDate between @DateFrom and @DateTo
END
GO
