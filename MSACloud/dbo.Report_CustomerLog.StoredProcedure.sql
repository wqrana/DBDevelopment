USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_CustomerLog]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_CustomerLog]
(
    @clientid int = NULL
    , @selectedcustomers varchar(2048) = null--
	, @selectedschools varchar(2048) = NULL--
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

	--set @clientid = NULL
    --set @selectedcustomers = null--
	--set @selectedschools = '6'--
	--set @selectedhomerooms = null
	--set @selectedgrades = NULL
	--set @activetype = 2 -- 0=InActiveset 1=Activeset 2=No Filter
	--set @selectedlunchtypes = '2'
	--set @deletedtype = 2
	--set @fromdate = '1/1/2018'
	--set @todate = getdate()


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
		select isnull(hrid, 0) from CustomerRoster
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
		select isnull(grid, 0) from CustomerRoster
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
		select isnull(lunchtype, 0) from CustomerRoster
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


    SELECT cr.*,
       CASE
           WHEN RTRIM(cr.Middle) IS NULL
                OR RTRIM(cr.Middle) = '' THEN UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')))
           ELSE UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')) + ' ' + RTRIM(ISNULL(cr.Middle, '')) + '.')
       END AS CustomerName,
       CASE
           WHEN cr.Address2 IS NULL
                OR cr.Address2 = '' THEN UPPER(RTRIM(ISNULL(cr.Address1, '')) + '' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' + CASE
                                                                                                                                                                  WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5)
                                                                                                                                                                  ELSE RTRIM(ISNULL(cr.zip, ''))
                                                                                                                                                              END)
           ELSE UPPER(RTRIM(ISNULL(cr.Address1, '')) + '' + RTRIM(ISNULL(cr.Address2, '')) + '' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' + CASE
                                                                                                                                                                               WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5)
                                                                                                                                                                               ELSE RTRIM(ISNULL(cr.zip, ''))
                                                                                                                                                                           END)
       END AS CustomerAddress,
       '' AS [break],
       CASE
           WHEN RTRIM(Emp.Middle) IS NULL
                OR RTRIM(Emp.Middle) = '' THEN UPPER(RTRIM(ISNULL(Emp.LastName, '')) + ', ' + RTRIM(ISNULL(Emp.FirstName, '')))
           ELSE UPPER(RTRIM(ISNULL(Emp.LastName, '')) + ', ' + RTRIM(ISNULL(Emp.FirstName, '')) + ' ' + RTRIM(ISNULL(Emp.Middle, '')) + '.')
       END AS EmployeeName,
       cl.ChangedDate,
       cl.Notes,
       cl.Comment
		, dbo.dateonly(@fromdate) FromDate
		, dbo.dateonly(@todate) ToDate
	--into CustomerLog_Report
	FROM CustomerRoster cr
	LEFT OUTER JOIN CustomerLog cl ON cl.Customer_Id = cr.CSTID
	LEFT OUTER JOIN Customers Emp ON Emp.Id = cl.Emp_Changed_Id
	WHERE (1 = 1) 
	and (isnull(cr.schid, 0) > 0)
	and (isnull(cr.clientid, 0) = isnull(@clientid, cr.clientid))
	and (isnull(cr.cstid, 0) in (select customerid from @tblcustomerids))
	and (isnull(cr.SCHID, 0) in (select schoolid from @tblschoolids))
	and (isnull(cr.hrid, 0) in (select homeroomid from @tblhomeroomids))
	and (isnull(cr.grid, 0) in (select gradeid from @tblgradeids))
	and (isnull(cr.lunchtype, 0) in (select lunchtypeid from @tbllunchtypeids))
	and (cr.isactive = isnull(@isactive, cr.isactive))
	and (cr.isdeleted = isnull(@isdeleted, cr.isdeleted))
	and ((dbo.dateonly(cl.ChangedDate) >= dbo.dateonly(isnull(@fromdate, cl.ChangedDate))) and (dbo.dateonly(cl.ChangedDate) <= dbo.dateonly(isnull(@todate, cl.ChangedDate))))
	order by 
	--dbo.dateonly(cr.creationdate)
	cr.LunchTypeSort
END
GO
