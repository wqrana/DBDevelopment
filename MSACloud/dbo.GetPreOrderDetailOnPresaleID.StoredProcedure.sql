USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetPreOrderDetailOnPresaleID]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================
-- Author      : Adeel Siddiqui
-- Create date : 15-DEC-2017
-- Description : Return PreOrder detail on the basis of @PreSale_Id
-- ================================================================
CREATE PROCEDURE [dbo].[GetPreOrderDetailOnPresaleID] 
	-- Add the parameters for the stored procedure here
	@PreSale_Id bigint
AS
BEGIN
select PO.*,POI.Id as PreOrderItemsID,POI.IsVoid as POIIsVoid,PreSale_Id from PreOrderItems POI 
inner join PreOrders PO on PO.ID=POI.PreOrder_ID
where PreSale_Id =@PreSale_Id
END
GO
