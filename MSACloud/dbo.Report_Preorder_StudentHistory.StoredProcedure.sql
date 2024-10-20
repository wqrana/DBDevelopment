USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_Preorder_StudentHistory]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_Preorder_StudentHistory]
/*	
	exec Report_Preorder_StudentHistory
		@fromdate = '10/1/2017'
		, @todate = '10/31/2017'
		, @datefiltertype = 'SERVING_DATE_FILTER'
		,  @locationids = '2, 61'
*/
	@clientid int = null
	, @customerids varchar(max) = null
	, @fromdate datetime = null
	, @todate datetime = null
	, @datefiltertype varchar(32) = null

	, @locationids varchar(max) = null
	
	, @accountcreationdate datetime = null
	
	, @createtype tinyint = 0

	, @gradeids varchar(max) = null
	, @homeroomids varchar(max) = null--@lunchtypeids
	, @activestatus bit = null
	, @isdeleted bit = null
	, @isfrozen bit = null
	, @lunchtypeids varchar(max) = null
	,@accountcreationdateto datetime = null
AS
BEGIN
	declare
		@currentdate datetime
	set @currentdate = getdate()

	declare
		@tblcustomers as table (id int identity(1, 1)
			, customerid int)

	declare
		@tbllocations as table (id int identity(1, 1)
			, locationid int)
	declare
		@tblgrades as table (id int identity(1, 1)
			, gradeid int)

	declare
		@tblhomerooms as table (id int identity(1, 1)
			, homeroomid int)

	declare
		@tbllunchtypes as table (id int identity(1, 1)
			, lunchtypeid int)

	if(len(ltrim(rtrim(isnull(@customerids, '')))) > 0)
	begin
		insert into @tblcustomers(customerid)
		select val from splitstring(@customerids, ',')
	end
	else
	begin
		insert into @tblcustomers(customerid)
		select id from Customers
	end

	if(len(ltrim(rtrim(isnull(@locationids, '')))) > 0)
	begin
		insert into @tbllocations(locationid)
		select val from splitstring(@locationids, ',')
	end
	else
	begin
		insert into @tbllocations(locationid)
		select schid from PreOrderStudentHistory
	end

	if(len(ltrim(rtrim(isnull(@gradeids, '')))) > 0)
	begin
		insert into @tblgrades(gradeid)
		select val from splitstring(@gradeids, ',')
	end
	else
	begin
		insert into @tblgrades(gradeid)
		select grid from PreOrderStudentHistory
	end

	if(len(ltrim(rtrim(isnull(@homeroomids, '')))) > 0)
	begin
		insert into @tblhomerooms(homeroomid)
		select val from splitstring(@homeroomids, ',')
	end
	else
	begin
		insert into @tblhomerooms(homeroomid)
		select hrid from PreOrderStudentHistory
	end

	if(len(ltrim(rtrim(isnull(@lunchtypeids, '')))) > 0)
	begin
		insert into @tbllunchtypes(lunchtypeid)
		select val from splitstring(@lunchtypeids, ',')
	end
	else
	begin
		insert into @tbllunchtypes(lunchtypeid)
		select id from LunchTypes
	end
	;
	with cte as
	(
		SELECT 
			posh.clientid clientid,
			posh.cstid,
			posh.schid locationid,
			posh.UserID, 
			-- Next field has options on way to display (FML, LFM, ALL_UPPER_CASE, etc.)
			posh.FirstName + posh.Middle + posh.LastName as CustomerName,
			posh.FirstName, posh.Middle MiddleName, posh.LastName,
			posh.Grade, 
			posh.Homeroom, 
			posh.Qty, 
			posh.ItemName, 
			posh.SchoolName,
			case when isnull(@datefiltertype, 'PURCHASE_DATE_FILTER') = 'PURCHASE_DATE_FILTER'  then dbo.dateonly(posh.PurchasedDate) else dbo.dateonly(posh.ServingDate) end HistoryDate
			, isnull(@datefiltertype, 'PURCHASE_DATE_FILTER') HistoryDateType
			, posh.creationdate
			, posh.lunchtype

			--, case when dbo.dateonly(isnull(posh.creationdate, @currentdate)) = dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate))) then 'true' else 'false' end  OnFilter
			--, case when dbo.dateonly(isnull(posh.creationdate, @currentdate)) < dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate))) then 'true' else 'false' end  BeforeFilter
			--, case when dbo.dateonly(isnull(posh.creationdate, @currentdate)) <= dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate))) then 'true' else 'false' end  OnAndBeforeFilter
			--, case when dbo.dateonly(isnull(posh.creationdate, @currentdate)) >= dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate))) then 'true' else 'false' end  OnAndAfterFilter
			--, case when ((dbo.dateonly(isnull(posh.creationdate, @currentdate)) >= dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate)))) 
			--	and (dbo.dateonly(isnull(posh.creationdate, @currentdate)) <= dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate))))) then 'true' else 'false' 
			--	end BetweenFilter
			, case when ((@accountcreationdate is not null and @accountcreationdateto is null) and dbo.dateonly(posh.creationdate) = dbo.dateonly(@accountcreationdate)) then 'true' else 'false' end  OnFilter
			, case when ((@accountcreationdate is not null and @accountcreationdateto is null) and dbo.dateonly(posh.creationdate) < dbo.dateonly(@accountcreationdate)) then 'true' else 'false' end  BeforeFilter
			, case when ((@accountcreationdate is not null and @accountcreationdateto is null) and dbo.dateonly(posh.creationdate) <= dbo.dateonly(@accountcreationdate)) then 'true' else 'false' end  OnAndBeforeFilter
			, case when ((@accountcreationdate is not null and @accountcreationdateto is null) and dbo.dateonly(posh.creationdate) > dbo.dateonly(@accountcreationdate)) then 'true' else 'false' end  AfterFilter
			, case when ((@accountcreationdate is not null and @accountcreationdateto is null) and dbo.dateonly(posh.creationdate) >= dbo.dateonly(@accountcreationdate)) then 'true' else 'false' end  OnAndAfterFilter
			, case when ((@accountcreationdate is not null and  @accountcreationdateto is not null) and ((dbo.dateonly(posh.creationdate) >= dbo.dateonly(@accountcreationdate)) 
				and (dbo.dateonly(posh.creationdate) <= dbo.dateonly(@accountcreationdateto)))) then 'true' else 'false' 
			end BetweenFilter

		FROM PreOrderStudentHistory posh 
			left join PreOrders po on posh.POID = po.Id 
			left join PreOrderItems poi on posh.POIID = poi.Id 
		WHERE 
			po.isVoid = 0 and poi.isVoid = 0
			and (posh.cstid in (select customerid from @tblcustomers))
			and (posh.clientid = isnull(@clientid, posh.clientid))
			and (posh.schid in (select locationid from @tbllocations))
			--and (dbo.dateonly(posh.creationdate) = dbo.dateonly(isnull(@accountcreationdate, posh.creationdate))) -- Match account creation date
			--and (dbo.dateonly(isnull(posh.creationdate, @currentdate)) = dbo.dateonly(isnull(@accountcreationdate, isnull(posh.creationdate, @currentdate)))) -- Match account creation date
			and (isnull(posh.isactive, 1) = isnull(@activestatus, isnull(posh.isactive, 1)))
			and (posh.isdeleted = isnull(@isdeleted, posh.isdeleted))
			and (posh.isfrozen = isnull(@isfrozen, posh.isfrozen))
			and (posh.lunchtype in (select lunchtypeid from @tbllunchtypes))
			and (posh.grid in (select gradeid from @tblgrades))
			and (posh.hrid in (select homeroomid from @tblhomerooms))
			and (posh.lunchtype in (select lunchtypeid from @tbllunchtypes))

			and posh.CreationDate  is not null
	)

    SELECT * 
	--into StudentHistoryPreorderReport
	from cte
	where (1 = 1)
	and (dbo.DateOnly(cte.HistoryDate) >= dbo.DateOnly(isnull(@fromdate, cte.HistoryDate))) and (dbo.DateOnly(cte.HistoryDate) <= dbo.DateOnly(isnull(@todate, cte.HistoryDate)))

	and (OnFilter = case when (@accountcreationdate is not null and @createtype = 0) then 'true' else OnFilter end)
	and (BeforeFilter = case when (@accountcreationdate is not null and @createtype = 1) then 'true' else BeforeFilter end)
	and (OnAndBeforeFilter = case when (@accountcreationdate is not null and @createtype = 2) then 'true' else OnAndBeforeFilter end)
	and (AfterFilter = case when (@accountcreationdate is not null and @createtype = 3) then 'true' else AfterFilter end)
	and (OnAndAfterFilter = case when (@accountcreationdate is not null and @createtype = 4) then 'true' else OnAndAfterFilter end)
	and (BetweenFilter = case when ((@accountcreationdate is not null and @accountcreationdateto is not null) and @createtype = 5) then 'true' else BetweenFilter end)
	order by schoolname, userid, historydate, qty
END
GO
