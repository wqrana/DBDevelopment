USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[PreOrderItemStatus]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PreOrderItemStatus]
AS
SELECT
	poi.Id as POIID,
	po.Id as POID,
	poi.PreSale_Id as PRESALEID,
	po.PreSaleTrans_Id as PRESALETRANSID,
	poi.Menu_Id as MENUID,
	s.Id as SCHID,
	ISNULL(m.ItemName,'Misc Item $' + LTRIM(STR(poi.PaidPrice,10,2))) as ItemName,
	poi.ServingDate,
	po.PurchasedDate,
	poi.Qty,
	poi.PickupCount,
	(poi.Qty - poi.PickupCount) as StillToCollect,
	poi.PaidPrice,
	(poi.Qty * poi.PaidPrice) as ItemTotal,
	(poi.PickupCount * poi.PaidPrice) as PickedupTotal,
	((poi.Qty - poi.PickupCount) * poi.PaidPrice) as OutstandingTotal,
	CASE
		WHEN (poi.Qty - poi.PickupCount) <= 0 THEN 'COLLECTED'
		WHEN (poi.PickupCount > 0) THEN 'PARTIALLY COLLECTED'
		ELSE 'NOT COLLECTED'
	END as CollectStatus,
	CASE
		WHEN (poi.Qty - poi.PickupCount) <= 0 THEN 2
		WHEN (poi.PickupCount > 0) THEN 1
		ELSE 0
	END as CollectStatusID
FROM PreOrderItems poi
	INNER JOIN PreOrders po ON po.Id = poi.PreOrder_Id
	INNER JOIN Customers c ON c.Id = po.Customer_Id
	INNER JOIN Customer_School cs ON cs.Customer_Id = c.Id and cs.isprimary = 1
	INNER JOIN Schools s ON s.Id = cs.School_Id
	LEFT OUTER JOIN Menu m ON m.Id = poi.Menu_Id
WHERE po.isVoid = 0 AND poi.isVoid = 0
GO
