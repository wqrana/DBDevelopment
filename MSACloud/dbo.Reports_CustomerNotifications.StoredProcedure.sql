USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Reports_CustomerNotifications]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Reports_CustomerNotifications]
(
	@clientid int = null
    , @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = NULL
	, @selectedhomerooms varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @activetype int = 2 -- 0=InActive, 1=Active, 2=No Filter
	, @selectedlunchtypes varchar(2048) = null
	, @deletedtype int = 2
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
	--set @clientid = 10
	set @selectedcustomers = null
	set @selectedschools = NULL
	set @selectedhomerooms = null
	set @selectedgrades = null
	--set @activetype = 2 -- 0=InActive, 1=Active, 2=No Filter
	set @selectedlunchtypes = null
	--set @deletedtype = 2
	--set @fromdate = '3/1/2018'
	--set @todate = '4/6/2018'

	declare
		@tblcustomerids as table(id int identity(1, 1)
			, customerid int)
	if(len(ltrim(rtrim(isnull(@selectedcustomers, '')))) > 0)
	begin
		insert into @tblcustomerids(customerid)
		select val from dbo.splitstring(@selectedcustomers, ',')
	end
	else
	begin
		insert into @tblcustomerids(customerid)
		select isnull(cstid, 0) from CustomerRoster
	end

	declare
		@tblschoolids as table(id int identity(1, 1)
			, schoolid int)

	if(len(ltrim(rtrim(isnull(@selectedschools, '')))) > 0)
	begin
		insert into @tblschoolids(schoolid)
		select val from dbo.splitstring(@selectedschools, ',')
	end
	else
	begin
		insert into @tblschoolids(schoolid)
		select DISTINCT ISNULL(schid, 0) from CustomerRoster
	end

	declare
		@tblhomeroomids as table(id int identity(1, 1)
			, homeroomid int)

	if(len(ltrim(rtrim(isnull(@selectedhomerooms, '')))) > 0)
	begin
		insert into @tblhomeroomids(homeroomid)
		select val from dbo.splitstring(@selectedhomerooms, ',')
	end
	else
	begin
		insert into @tblhomeroomids(homeroomid)
		SELECT DISTINCT isnull(hrid, 0) from CustomerRoster
	end

	declare
		@tblgradeids as table(id int identity(1, 1)
			, gradeid int)

	if(len(ltrim(rtrim(isnull(@selectedgrades, '')))) > 0)
	begin
		insert into @tblgradeids(gradeid)
		select val from dbo.splitstring(@selectedgrades, ',')
	end
	else
	begin
		insert into @tblgradeids(gradeid)
		select DISTINCT ISNULL(grid, 0) from CustomerRoster
	end

	declare
		@tbllunchtypeids as table(id int identity(1, 1)
			, lunchtypeid int)

	if(len(ltrim(rtrim(isnull(@selectedlunchtypes, '')))) > 0)
	begin
		insert into @tbllunchtypeids(lunchtypeid)
		select val from dbo.splitstring(@selectedlunchtypes, ',')
	end
	else
	begin
		insert into @tbllunchtypeids(lunchtypeid)
		select DISTINCT ISNULL(lunchtype, 0) from CustomerRoster
	end

	declare
		@isactive bit = null
		, @isdeleted bit = null

	set @isactive = case isnull(@activetype, 2) 
		when 1 then 1
		when 0 then 0
		else null end

	set @isdeleted = case isnull(@deletedtype, 2) 
		when 1 then 1
		when 0 then 0
		else null end

    SELECT cn.*,  
		case
			when RTRIM(cn.Middle) IS NULL or RTRIM(cn.Middle) = '' then UPPER(RTRIM(ISNULL(cn.LastName, '')) + ', ' + RTRIM(ISNULL(cn.FirstName, '')))    
			else UPPER(RTRIM(ISNULL(cn.LastName, '')) + ', ' + RTRIM(ISNULL(cn.FirstName, '')) + ' ' + RTRIM(ISNULL(cn.Middle, '')) + '.') 
		end AS CustomerName, '' as [break] 
		, dbo.dateonly(@fromdate) fromdate, dbo.dateonly(@todate) todate
		--into Report_CustomerNotifications
		FROM CustomerNotification cn 

		WHERE (1 = 1)
		AND (cn.Notification_Id > 0)
		AND (cn.Current_District_Id = isnull(@clientid, cn.Current_District_Id))
		AND ((dbo.dateonly(cn.OrderDate) >= dbo.DateOnly(isnull(@fromdate, cn.Orderdate))) AND (dbo.dateonly(cn.OrderDate) <= dbo.DateOnly(isnull(@todate, cn.Orderdate))))
		and (cn.Cst_Id in (select customerid from @tblcustomerids))
		and (cn.Cur_School_Id in (select schoolid from @tblschoolids))
		and (cn.hrid in (select homeroomid from @tblhomeroomids))
		and (cn.grid in (select gradeid from @tblgradeids))
		AND (cn.CustomerActive = isnull(@isactive, cn.CustomerActive))
		and (isnull(cn.lunchtype, 4) in (select lunchtypeid from @tbllunchtypeids))
		AND (cn.CustomerDeleted = isnull(@isdeleted, cn.CustomerDeleted))
		and (len(ltrim(rtrim(isnull(cn.itemname, '')))) > 0)
		order by cn.orderdate, cn.itemname
		
		----Second query is to get counts
		--select (cn.Notification)
		--, COUNT(cn.Notification) as QTY 
		--from CustomerNotification cn 
		--WHERE (1 = 1)
		--AND (cn.Notification_Id > 0)
		--and (cn.Cur_School_Id in (select schoolid from @tblschoolids))
		--and (cn.hrid in (select homeroomid from @tblhomeroomids))
		--and (cn.grid in (select gradeid from @tblgradeids))
		--AND (cn.CustomerActive = isnull(@isactive, cn.CustomerActive))
		--and (isnull(cn.lunchtype, 4) in (select lunchtypeid from @tbllunchtypeids))
		--AND (cn.CustomerDeleted = isnull(@isdeleted, cn.CustomerDeleted))
		--AND ((dbo.dateonly(cn.OrderDate) >= dbo.DateOnly(isnull(@fromdate, cn.Orderdate))) AND (dbo.dateonly(cn.OrderDate) <= dbo.DateOnly(isnull(@todate, cn.Orderdate))))
		--group by cn.Notification 
END
GO
