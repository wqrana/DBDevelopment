USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_QualifiedMeal]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_QualifiedMeal]
(
    @fromdate datetime = '2/1/2018'
	, @todate datetime = '2/28/2018'
	, @locationids varchar(1000) = '6, 17, 1'
	, @extranmealonly bit = 0
	, @schooltype varchar(80) = 'SERVED'
)
AS
BEGIN
	declare
		@tblschools as table(id int identity(1, 1)
		, schoolid int)

		if(len(ltrim(rtrim(isnull(@locationids, '')))) <= 0)
		begin
			insert into @tblschools(schoolid)
			select id from schools
		end
		else
		begin
			insert into @tblschools(schoolid)
			select val from dbo.splitstring(@locationids, ',')
		end

	declare
		@qtycount int = null
		if(isnull(@extranmealonly, 0) = 1)
		begin
			set @qtycount = 2
		end

	;
	with cte as(
	select
		qm.schid
		, qm.schoolname
		, qm.primschid
		, qm.primaryschool
		, case when isnull(@schooltype, 'SERVED') = 'SERVED' then schid else primschid end schoolfilterid
		, qm.categoryname
		, qm.userid
		, case when qm.firstname is null then qm.lastname else concat(qm.lastname, ', ', qm.firstname) end customername
		, qm.studentlunchtype
		, sum(qm.freecount) freecount
		, sum(qm.reducedcount) reducedcount
		, sum(qm.paidcount) paidcount
		, dbo.dateonly(qm.orderdate) orderdate	
		, qm.menuid
		, qm.menuitem
		, sum(qm.qty) qty
	from QualifiedMeals qm
	where (1 = 1)
	and (dbo.dateonly(qm.orderdate) >= dbo.dateonly(@fromdate) and (dbo.dateonly(qm.orderdate) <= dbo.dateonly(@todate)))

	group by qm.schid
		, qm.schoolname
		, qm.primschid
		, qm.primaryschool
		, qm.categoryname
		, qm.userid
		, case when qm.firstname is null then qm.lastname else concat(qm.lastname, ', ', qm.firstname) end
		, qm.studentlunchtype
		, orderdate
		, qm.menuid
		, qm.menuitem
	
	)
	select * from cte
	where (1 = 1)
	and (schoolfilterid in (select schoolid from @tblschools))
	and (cte.qty >= isnull(@qtycount, cte.qty))
	order by cte.orderdate

END
GO
