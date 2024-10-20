USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_EditCheckWorksheet]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_EditCheckWorksheet]
(
	@categoryid int = null
	, @attendancefactor numeric(10, 2) null
	, @fromdate datetime = null
	, @todate datetime = null
	, @schooltype varchar(80) = null
	, @locationids varchar(1000) = null
)
AS
BEGIN
    IF (OBJECT_ID('tempdb..#StudentCount') IS NOT NULL)  
	DROP TABLE #StudentCount  
	SELECT  
		d.Id as District_Id,  
		sc.Id as School_Id,  
		SUM(CASE WHEN (cst.LunchType = 3) THEN 1 ELSE 0 END) as FreeCount,  
		SUM(CASE WHEN (cst.LunchType = 2) THEN 1 ELSE 0 END) as ReducedCount,  
		SUM(CASE WHEN (cst.LunchType = 1) THEN 1 ELSE 0 END) as PaidCount,  
		SUM(CASE WHEN (cst.LunchType BETWEEN 1 AND 3) THEN 1 ELSE 0 END) as StudCount  
		INTO #StudentCount  
	FROM Schools sc  
		LEFT OUTER JOIN Customer_School c ON ((sc.id = c.school_id) AND (c.isPrimary = 1))  
		LEFT OUTER JOIN Customers cst ON cst.id = c.customer_id  
		LEFT OUTER JOIN District d ON d.id = sc.District_Id  
	WHERE (cst.isStudent = 1) AND (Cst.isActive = 1) AND (Cst.isDeleted = 0) AND (Cst.Id > 0)  
	GROUP BY d.Id, sc.Id

	declare
		@tbllocationids as table(id int identity(1, 1)
			, locationid int)
	if(len(ltrim(rtrim(isnull(@locationids, '')))) <= 0)
	begin
		insert into @tbllocationids(locationid)
		select id from Schools
	end
	else
	begin
		insert into @tbllocationids(locationid)
		select val from dbo.SplitString(@locationids, ',')
	end

	;
	with cte as
	(
		select 
			ecw.gdate,
			ecw.districtid,
			ecw.districtname,
			ecw.assignschid,
			ecw.serveschid,
			ecw.catid,
			ecw.categoryname,
			case when isnull(@schooltype, 'SERVED') = 'SERVED' then ecw.serveschid else ecw.assignschid end schoolid,
			ecw.SchoolName,
			ecw.schoolid school_id,
			ecw.[month],
			ecw.[Year],
			case when ecw.catid = @categoryid then ecw.claimedfree else 0 end claimedfree,
			(select max(eligfree)
				from editcheckworksheet ecws
				where (1 = 1)
				--and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) = @schoolid)
				and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) in (select locationid from @tbllocationids))
				and (dbo.dateonly(ecws.gdate) >= dbo.dateonly(isnull(@fromdate, ecws.gdate)) and (dbo.dateonly(ecws.gdate) <= (dbo.dateonly(isnull(@todate, ecws.gdate)))))
			) eligfree,
			case when ecw.catid = @categoryid then ecw.claimedreduced else 0 end claimedreduced,
			(select max(EligReduced)
				from editcheckworksheet ecws
				where (1 = 1)
				--and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) = @schoolid)
				and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) in (select locationid from @tbllocationids))
				and (dbo.dateonly(ecws.gdate) >= dbo.dateonly(isnull(@fromdate, ecws.gdate)) and (dbo.dateonly(ecws.gdate) <= (dbo.dateonly(isnull(@todate, ecws.gdate)))))
			) EligReduced,
			case when ecw.catid = @categoryid then ecw.claimedpaid else 0 end claimedpaid, 
			(select max(EligPaid)
				from editcheckworksheet ecws
				where (1 = 1)
				--and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) = @schoolid)
				and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) in (select locationid from @tbllocationids))
				and (dbo.dateonly(ecws.gdate) >= dbo.dateonly(isnull(@fromdate, ecws.gdate)) and (dbo.dateonly(ecws.gdate) <= (dbo.dateonly(isnull(@todate, ecws.gdate)))))
			) EligPaid,
			case when ecw.catid = @categoryid then (ecw.claimedfree + ecw.claimedreduced + ecw.claimedpaid) else 0 end totalclaimed,
			(select max(EligQty)
				from editcheckworksheet ecws
				where (1 = 1)
				--and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) = @schoolid)
				and ((case when @schooltype = 'SERVED' then ecws.serveschid else ecws.assignschid end) in (select locationid from @tbllocationids))
				and (dbo.dateonly(ecws.gdate) >= dbo.dateonly(isnull(@fromdate, ecws.gdate)) and (dbo.dateonly(ecws.gdate) <= (dbo.dateonly(isnull(@todate, ecws.gdate)))))
			) EligQty
		from EditCheckWorksheet ecw
		where (1 = 1)
		and (dbo.dateonly(ecw.gdate) >= dbo.dateonly(isnull(@fromdate, ecw.gdate)))
		and (dbo.dateonly(ecw.gdate) <= dbo.dateonly(isnull(@todate, ecw.gdate)))
		and (catid = isnull(@categoryid, catid))	
	)
	select 
		cte.gdate,
		cte.districtid,
		cte.districtname,
		cte.schoolid,
		cte.schoolname,
		cte.school_id,
		cte.[month],
		cte.[year],
		cte.catid,
		cte.categoryname,

		sum(cte.claimedfree)claimedfree,
		case when isnull(cte.claimedfree, 0) <= 0 then sc.freecount else cte.claimedfree end eligfree,
		(cast(((case when isnull(cte.claimedfree, 0) <= 0 then sc.freecount else cte.claimedfree end)) as float)* @attendancefactor/100) eligAfree,

		sum(cte.ClaimedReduced)ClaimedReduced,
		case when isnull(cte.EligReduced, 0) <= 0 then sc.ReducedCount else cte.EligReduced end EligReduced,
		(cast(((case when isnull(cte.EligReduced, 0) <= 0 then sc.ReducedCount else cte.EligReduced end)) as float)* @attendancefactor/100) EligAFReduced,

		sum(cte.ClaimedPaid)ClaimedPaid,
		case when isnull(cte.EligPaid, 0) <= 0 then sc.PaidCount else cte.EligPaid end EligPaid,
		(cast(((case when isnull(cte.EligPaid, 0) <= 0 then sc.PaidCount else cte.EligPaid end)) as float)* @attendancefactor/100) EligAFPaid,

		sum(cte.totalclaimed)totalclaimed,
		case when isnull(cte.EligQty, 0) <= 0 then sc.StudCount else cte.EligQty end EligQty,
		(cast(((case when isnull(cte.EligQty, 0) <= 0 then sc.StudCount else cte.EligQty end)) as float)* @attendancefactor/100) EligAFQty
	from cte
	LEFT OUTER JOIN #StudentCount sc on sc.School_Id = cte.schoolid
	where (1 = 1)
	--and ((cte.schoolid is not null) and (cte.schoolid = @schoolid))
	and ((cte.schoolid is not null) and (cte.schoolid in (select locationid from @tbllocationids)))

	group by 
		cte.gdate,
		cte.districtid,
		cte.districtname,
		cte.schoolid,
		cte.schoolname,
		cte.school_id,
		cte.[month],
		cte.[year],
		cte.catid,
		cte.categoryname,
	
		cte.claimedfree,
		sc.freecount,

		cte.eligreduced,
		sc.reducedcount,

		cte.eligpaid,
		sc.paidcount,

		cte.EligQty,
		sc.StudCount

END
GO
