USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_PreorderCollectionTotals]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_PreorderCollectionTotals]
	@fromdate datetime = null
	, @todate datetime = null
	, @reportdatetype varchar(200) = null
	, @locationids varchar(max) = null
AS
BEGIN
	declare
		@tbllocations as table(id int identity(1, 1)
			, locationid int)

	if(len(ltrim(rtrim(isnull(@locationids, '')))) > 0)
	begin
		insert into @tbllocations(locationid)
		select val from splitstring(@locationids, ',')
	end
	else
	begin
		insert into @tbllocations(locationid)		
		select schid from PreOrderItemStatus
	end
	; 

	with cte as
	(
		select 
			pois.ItemName
			, case when isnull(@reportdatetype, 'SERVING_DATE_FILTER') = 'PURCHASE_DATE_FILTER'  then dbo.dateonly(pois.PurchasedDate) else dbo.dateonly(pois.ServingDate) end ReportDate
			, case when isnull(@reportdatetype, 'SERVING_DATE_FILTER') = 'PURCHASE_DATE_FILTER' then '(By Purchase Date)' else '(By Serving Date)' end ReportDateType
			, pois.Qty as QTY
			, pois.PickupCount as PickupCount
			, pois.StillToCollect as StillToCollect
			, pois.PaidPrice PaidPrice
			, (pois.Qty * pois.PaidPrice) as ItemTotal
			, (pois.PickupCount * pois.PaidPrice) as PickedupTotal
			, ((pois.Qty - pois.PickupCount) * pois.PaidPrice) as OutstandingTotal
			, pois.schid

		FROM PreOrderItemStatus pois  
			left join PreOrders po on pois.POID = po.Id  
			left join PreOrderItems poi on pois.POIID = poi.Id  
		WHERE  
			(po.isVoid = 0) AND (poi.isVoid = 0)
			AND (pois.schid in (select locationid from @tbllocations))
	)
	select 
		ItemName
		, ReportDate
		, ReportDateType
		, SUM(Qty) Qty
		, SUM(PickupCount) PickupCount		
		, SUM(StillToCollect) StillToCollect
		, SUM(PaidPrice) PaidPrice
		, SUM(ItemTotal) ItemTotal
		, SUM(PickedupTotal) PickedupTotal
		, SUM(OutstandingTotal) OutstandingTotal
		, schid
	from cte
	where (dbo.DateOnly(cte.reportdate) >= dbo.DateOnly(isnull(@fromdate, cte.reportdate))) and (dbo.DateOnly(cte.reportdate) <= dbo.DateOnly(isnull(@todate, cte.reportdate)))
	group by ItemName, ReportDate, ReportDateType, schid
	order by reportdate

 --   SELECT  
	--	pois.ItemName,
	
	--	-- if running by PurchaseDate
	--	CAST(CONVERT(varchar,pois.PurchasedDate,101) as datetime) as ReportDate, '(By Purchase Date)' as ReportDateTitle,
	--	-- else running by ServingDate
	--	pois.ServingDate as ReportDate, '(By Serving Date)' as ReportDateTitle, 

	--	SUM(pois.Qty) as QTY,  
	--	SUM(pois.PickupCount) as PickupCount,  
	--	SUM(pois.StillToCollect) as StillToCollect,  
	--	pois.PaidPrice,  
	--	SUM(pois.Qty * pois.PaidPrice) as ItemTotal,  
	--	SUM(pois.PickupCount * pois.PaidPrice) as PickedupTotal,  
	--	SUM((pois.Qty - pois.PickupCount) * pois.PaidPrice) as OutstandingTotal  
	--FROM PreOrderItemStatus pois  
	--	left join PreOrders po on pois.POID = po.Id  
	--	left join PreOrderItems poi on pois.POIID = poi.Id  
	--WHERE  
	--	po.isVoid = 0 AND poi.isVoid = 0 
	--group by itemname, pois.PurchasedDate, pois.ServingDate
END
GO
