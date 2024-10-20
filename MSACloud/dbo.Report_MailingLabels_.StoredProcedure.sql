USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_MailingLabels_]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_MailingLabels_]
(
    @clientid int = null
	, @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = NULL
	, @selectedhomerooms varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @activetype int = 2 -- 0=InActive, 1=Active, 2=No Filter
	, @selectedlunchtypes varchar(2048) = null
	, @deletedtype int = 2
)
AS
BEGIN
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
		select isnull(schid, 0) from CustomerRoster
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
       '' AS [break]
	--into MailingLabels_Report
	FROM CustomerRoster cr
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
END
GO
