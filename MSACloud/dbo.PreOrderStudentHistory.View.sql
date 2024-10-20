USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[PreOrderStudentHistory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PreOrderStudentHistory]
as
SELECT
	cr.*,
	poi.Id as POIID,
	po.Id as POID,
	poi.Menu_Id as MENUID,
	po.PreSaleTrans_Id as PRESALETRANID,
	poi.ServingDate,
	poi.PickupDate,
	poi.Disposition,
	poi.Qty,
	poi.PaidPrice,
	poi.isVoid,
	poi.SoldType,
	poi.PickupCount,
	po.PurchasedDate,
	po.TransferDate,
	ISNULL(m.ItemName,'Misc Item $' + LTRIM(STR(poi.PaidPrice,10,2))) as ItemName
FROM PreOrderItems poi 
	INNER JOIN PreOrders po ON po.Id = poi.PreOrder_Id
	INNER JOIN CustomerRoster cr ON cr.CSTID = po.Customer_Id
	LEFT OUTER JOIN Menu m ON m.Id = poi.Menu_Id
GO
