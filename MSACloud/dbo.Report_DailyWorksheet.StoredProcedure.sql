USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_DailyWorksheet]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_DailyWorksheet]
(
    @locationids varchar(1000) = NULL
	, @selecteditemids varchar(40) = NULL
	, @attendancefactor numeric(10, 2) = NULL
	, @fromdate datetime = NULL
	, @todate datetime = NULL
	, @servingschool bit = NULL
)
AS
BEGIN    

	--set @locationids = '6'
	--set @selecteditemids = '24,39, 40'--, 13'
	--set @attendancefactor = 95
	--set @fromdate = '2/1/2018'
	--set @todate = '2/28/2018'
	--set @servingschool = 1

	declare
		@sortdate int
		, @startdate datetime
	set @sortdate = cast(year(@fromdate) as varchar(8)) + cast(month(@fromdate) as varchar(8))
	set @startdate = @fromdate

	-- Setting up selected items
	declare
		@tblmenuids as table(id int identity(1, 1) -- We shall split selected item ids into this table
			, menuid int)

	declare
		@CN_Item_Id_1 int
		, @CN_Item_Name_1 varchar(300)
		, @N_Item_Price_1 numeric(10, 2)

		, @CN_Item_Id_2 int
		, @CN_Item_Name_2 varchar(300)
		, @N_Item_Price_2 numeric(10, 2)

		, @CN_Item_Id_3 int
		, @CN_Item_Name_3 varchar(300)
		, @N_Item_Price_3 numeric(10, 2)

		, @CN_Item_Id_4 int
		, @CN_Item_Name_4 varchar(300)
		, @N_Item_Price_4 numeric(10, 2)

		, @selecteditemscount int -- This will hold total number of items selected in UI.
		, @maxitemsallowed int = 4 -- Maximum number of of items allowed in report.
		, @itemcounter int = 1
		
		, @tempitemid int -- This will help us to hold item id while iterating
		, @tempitemname varchar(300) -- This will help us to hold item name while iterating
		, @tempitemprice numeric(10, 2) -- This will help us to hold item price while iterating
	
	insert into @tblmenuids(menuid)
	select val from dbo.splitstring(@selecteditemids, ',') -- Split comman separated item ids and insert into our temp table
	set @selecteditemscount = @@ROWCOUNT -- Number of items selected by user
	if (isnull(@selecteditemscount, 0) > @maxitemsallowed) -- If user selected more than allowed items
	begin
		set @selecteditemscount = @maxitemsallowed -- Set value to maximum items allowed in report
	end
	set @itemcounter = 1
	while (@itemcounter <= isnull(@selecteditemscount, 0))
	begin
		select @tempitemid = menuid -- Get menu id from our temp table
		from @tblmenuids
		where (1 = 1)
		and (id = @itemcounter)
		if(isnull(@@rowcount, 0) > 0)
		begin
			select 
				@tempitemname = itemname -- Hold item name
				, @tempitemprice = studentfullprice -- Hold item price
			from menu
			where (1 = 1)
			and (id = @tempitemid) -- Values against current item id
			if(isnull(@@rowcount, 0) > 0)
			begin
				set @CN_Item_Id_1 = case when @itemcounter = 1 then isnull(@tempitemid, 0) else @CN_Item_Id_1 end -- When @itemcounter is 1 then copy @tempitemid to variable
				set @CN_Item_Name_1 = case when @itemcounter = 1 then @tempitemname else @CN_Item_Name_1 end -- When @itemcounter is 1 then copy @tempitemname to variable
				set @N_Item_Price_1 = case when @itemcounter = 1 then isnull(@tempitemprice, 0.00) else isnull(@N_Item_Price_1, 0.00) end -- When @itemcounter is 1 then copy @tempitemprice to variable
				--print '@CN_Item_Id_1 : ' + cast(@CN_Item_Id_1 as varchar(max))


				set @CN_Item_Id_2 = case when @itemcounter = 2 then isnull(@tempitemid, 0) else @CN_Item_Id_2 end -- When @itemcounter is 2 then copy @tempitemid to variable
				set @CN_Item_Name_2 = case when @itemcounter = 2 then @tempitemname else @CN_Item_Name_2 end -- When @itemcounter is 2 then copy @tempitemname to variable
				set @N_Item_Price_2 = case when @itemcounter = 2 then isnull(@tempitemprice, 0.00) else isnull(@N_Item_Price_2, 0.00) end -- When @itemcounter is 2 then copy @tempitemprice to variable
				--print '@CN_Item_Id_2 : ' + cast(@CN_Item_Id_2 as varchar(max))

				set @CN_Item_Id_3 = case when @itemcounter = 3 then isnull(@tempitemid, 0) else @CN_Item_Id_3 end -- When @itemcounter is 3 then copy @tempitemid to variable
				set @CN_Item_Name_3 = case when @itemcounter = 3 then @tempitemname else @CN_Item_Name_3 end -- When @itemcounter is 3 then copy @tempitemname to variable
				set @N_Item_Price_3 = case when @itemcounter = 3 then isnull(@tempitemprice, 0.00) else isnull(@N_Item_Price_3, 0.00) end -- When @itemcounter is 3 then copy @tempitemprice to variable
				--print '@CN_Item_Id_3 : ' + cast(@CN_Item_Id_3 as varchar(max))

				set @CN_Item_Id_4 = case when @itemcounter = 4 then isnull(@tempitemid, 0) else @CN_Item_Id_4 end -- When @itemcounter is 4 then copy @tempitemid to variable
				set @CN_Item_Name_4 = case when @itemcounter = 4 then @tempitemname else @CN_Item_Name_4 end -- When @itemcounter is 4 then copy @tempitemname to variable
				set @N_Item_Price_4 = case when @itemcounter = 4 then isnull(@tempitemprice, 0.00) else isnull(@N_Item_Price_4, 0.00) end -- When @itemcounter is 4 then copy @tempitemprice to variable
				--print '@CN_Item_Id_4 : ' + cast(@CN_Item_Id_4 as varchar(max))				
			end
		end
		set @itemcounter = isnull(@itemcounter, 0) + 1
	end
	
	---------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------- Query for CN Common ---------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------
	declare 
		@tblschoolids as table(id int identity(1, 1)
		, schoolid int)

	if(len(ltrim(rtrim(isnull(@locationids, '')))) <= 0)
	begin
		insert into @tblschoolids(schoolid)
		select id from schools
	end
	else
	begin
		insert into @tblschoolids(schoolid)
		select val from dbo.splitstring(@locationids, ',')
	end
	

	SELECT  
        crc.schoolname as Site,  
        crc.Month,  
        crc.NumMonth,  
        crc.Year,  
        crc.SortDate,  
        SUM(crc.EnrollPd) as EnrollPd,  
        SUM(crc.EnrollRed) as EnrollRed,  
        SUM(crc.EnrollFr) as EnrollFr,  
        SUM(crc.EnrollTot) as EnrollTot,  
        CAST(SUM(crc.EnrollPd) as FLOAT) * ( @attendancefactor /100.0) as AttPd,  
        CAST(SUM(crc.EnrollRed) as FLOAT) * ( @attendancefactor /100.0) as AttRed,  
        CAST(SUM(crc.EnrollFr) as FLOAT) * ( @attendancefactor /100.0) as AttFr,  
        CAST(SUM(crc.EnrollPd + crc.EnrollRed + crc.EnrollFr) as FLOAT) * ( @attendancefactor /100.0) as AttTotal,  
		@attendancefactor as AttendanceFactor,  
		--<County> as County,  
		crc.DistrictName as Sponsor,  

		isnull(@CN_Item_Id_1, 0) CN_Item_Id_1,
		@CN_Item_Name_1 as ItemOne,  

		isnull(@CN_Item_Id_2, 0) CN_Item_Id_2,
		@CN_Item_Name_2 as ItemTwo,  

		isnull(@CN_Item_Id_3, 0) CN_Item_Id_3,
		@CN_Item_Name_3 as ItemThree,  

		isnull(@CN_Item_Id_4, 0) CN_Item_Id_4,
		@CN_Item_Name_4 as ItemFour,  

		CASE  
			WHEN  isnull(@N_Item_Price_1, 0.00) = -99 THEN 0.0  
			ELSE  isnull(@N_Item_Price_1, 0.00)   
		END as ItemOnePrice,  
		CASE  
			WHEN  isnull(@N_Item_Price_2, 0.00)  = -99 THEN 0.0  
			ELSE  isnull(@N_Item_Price_2, 0.00)  
		END as ItemTwoPrice,  
		CASE  
			WHEN isnull(@N_Item_Price_3, 0.00)  = -99 THEN 0.0  
			ELSE isnull(@N_Item_Price_3, 0.00)  
		END as ItemThreePrice,  
		CASE  
			WHEN isnull(@N_Item_Price_4, 0.00) = -99 THEN 0.0  
			ELSE isnull(@N_Item_Price_4, 0.00)
		END as ItemFourPrice  
	--into Report_CNReportCommon
    FROM CNReportCommon crc
	WHERE (1 = 1)
	and (crc.SortDate = @sortdate)
	AND crc.SCHID IN (select schoolid from @tblschoolids) 

	GROUP BY 
		crc.Month
		, crc.NumMonth
		, crc.Year
		, crc.SortDate
		, crc.DistrictName 
		, crc.schoolname
	-- Query for CN Common ends here

	---------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------- Query for Pg1 ---------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------
	IF (OBJECT_ID('tempdb..#CNReportPg1DayList') IS NOT NULL) 
	begin
		DROP TABLE #CNReportPg1DayList 
	end
	CREATE TABLE #CNReportPg1DayList (gDate datetime, [Month] int, [Day] int, [Year] int, L1 int DEFAULT 0, L2 int DEFAULT 0, L3 int DEFAULT 0, L4 int DEFAULT 0, 
                            NeedyFree int DEFAULT 0, NeedyReduced int DEFAULT 0, NonNeedyStuWrks int DEFAULT 0, TotalStuSrvd int DEFAULT 0) 


	declare
		@tbldatespg1 as table (id int identity(1, 1)
			, [date] datetime)

	declare
		@tbldatespg2 as table (id int identity(1, 1)
			, [date] datetime)

	declare
		@currentdate datetime
		, @enddate datetime
	set @currentdate = @fromdate
	set @enddate = @todate
	while (@currentdate <= @enddate)
	begin
		insert into @tbldatespg1([date])
		select dbo.dateonly(@currentdate)
		set @currentdate = dateadd(dd, 1, @currentdate)
	end

	insert into @tbldatespg2([date])
	select [date] from @tbldatespg1

	;with pg1 as
	(
		SELECT
			case when  isnull(@servingschool, 1) = 1 then crp1.SCHID else crp1.ASSSCHID end schoolid
			, crp1.gDate
			, DATEPART(mm,crp1.gDate) as [Month]
			, DATEPaRT(dd,crp1.gDate) as [Day]
			, DATEPART(yyyy,crp1.gDate) as [Year]
			, CASE 
				WHEN (crp1.LunchType = 1 OR crp1.CSTID < 0) AND crp1.MenuID IN (@CN_Item_Id_1) THEN crp1.Paid 
				ELSE 0 
			END as L1
			, CASE 
				WHEN (crp1.LunchType = 1 OR crp1.CSTID < 0) AND crp1.MenuID IN (@CN_Item_Id_2) THEN crp1.Paid 
				ELSE 0 
			END as L2
			, CASE 
				WHEN (crp1.LunchType = 1 OR crp1.CSTID < 0) AND crp1.MenuID IN (@CN_Item_Id_3) THEN crp1.Paid 
				ELSE 0 
			END as L3
			, CASE 
				WHEN (crp1.LunchType = 1 OR crp1.CSTID < 0) AND crp1.MenuID IN (@CN_Item_Id_4) THEN crp1.Paid 
				ELSE 0 
			END as L4
			, CASE WHEN LOWER(crp1.CategoryName) = 'breakfast' THEN crp1.NeedyFree ELSE 0 END as NeedyFree
			, CASE WHEN LOWER(crp1.CategoryName) = 'breakfast' THEN crp1.NeedyRed ELSE 0 END as NeedyReduced
			, CASE WHEN (crp1.LunchType = 1) AND (LOWER(crp1.MenuItem) = 'student worker breakfast' OR crp1.STUDWORKER = 1) THEN crp1.NonNeedyStuWrks ELSE 0 END as NonNeedyStuWrks
			, CASE 
				WHEN ((crp1.LunchType = 1 OR crp1.CSTID < 0) 
				AND (crp1.MenuID IN (@CN_Item_Id_1, @CN_Item_Id_2, @CN_Item_Id_3, @CN_Item_Id_4))
				) 
				THEN crp1.TotalStuSrvd 
				WHEN (LOWER(crp1.CategoryName) = 'breakfast') THEN crp1.TotalStuSrvd 
				WHEN (LOWER(crp1.MenuItem) = 'student worker breakfast' AND crp1.STUDWORKER = 1) THEN crp1.TotalStuSrvd 
				ELSE 0 
			END as TotalStuSrvd 
		FROM CNReportPg1 crp1 
		WHERE (1 = 1)
		and ((dbo.dateonly(crp1.OrderDate) >= dbo.dateonly(@fromdate)) and (dbo.dateonly(crp1.OrderDate) <= dbo.dateonly(@todate)))
		AND (crp1.ItemType = 2)
	)
	insert into #CNReportPg1DayList(gdate, [Month], [Day], [Year], L1, L2, L3, L4, NeedyFree, NeedyReduced, NonNeedyStuWrks, TotalStuSrvd)
	select
		crp1.GDate
		, datepart(mm, crp1.gdate) [Month]
		, DATEPART(dd, crp1.gDate) as [Day]
		, DATEPART(yyyy,crp1.gDate) as [Year]
		, SUM(L1) as L1
		, SUM(L2) as L2
		, SUM(L3) as L3
		, SUM(L4) as L4
		, SUM(NeedyFree) as NeedyFree
		, SUM(NeedyReduced) as NeedyReduced
		, SUM(NonNeedyStuWrks) as NonNeedyStuWrks
		, SUM(TotalStuSrvd) as TotalStuSrvd

	from pg1 crp1
	where (1 = 1)
	and (crp1.schoolid in (select schoolid from @tblschoolids))
	group by 
		crp1.gDate
	
	delete from @tbldatespg1 where [date] in (select gdate from #CNReportPg1DayList)	

	insert into #CNReportPg1DayList(gdate, [Month]
		, [Day], [Year]
		, L1, L2
		, L3, L4
		, NeedyFree, NeedyReduced
		, NonNeedyStuWrks, TotalStuSrvd)
	select [date], datepart(mm, [date])
		, datepart(dd, [date]), datepart(yyyy, [date])
		, 0, 0
		, 0, 0
		, 0, 0
		, 0, 0
	from @tbldatespg1

	select 
		* 
	--into Report_CNReportPg1DayList
	from #CNReportPg1DayList
	order by gDate
	--------------------------------------------------- Query for Pg1 end here --------------------------------------------------- 

	---------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------- Query for Pg2 ---------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------
	IF (OBJECT_ID('tempdb..#CNReportPg2DayList') IS NOT NULL) 
		DROP TABLE #CNReportPg2DayList 

	CREATE TABLE #CNReportPg2DayList (gDate datetime, [Month] int, [Day] int, [Year] int, 
		StudentLunchReceipts float DEFAULT 0.0, ExtraMilkReceipts float DEFAULT 0.0, StudentAlaCarteReceipts float DEFAULT 0.0, 
		AdultReceipts float DEFAULT 0.0, TotalReceipts float DEFAULT 0.0, ReceivedOnAccount float DEFAULT 0.0, TotalDeposit float DEFAULT 0.0) 

	;with pg2 as
	(
		SELECT 
			case when  isnull(@servingschool, 1) = 1 then crp2.SCHID else crp2.ASSSCHID end schoolid
			, crp2.gDate
			, CASE 
				WHEN crp2.OrderDate IS NULL THEN DATEPART(mm,crp2.OpenDate) 
				ELSE DATEPART(mm,crp2.OrderDate) 
			END as [Month]
			, DATEPART(dd,crp2.gDate) as [Day]
			, CASE 
				WHEN crp2.OrderDate IS NULL THEN DATEPART(yyyy,crp2.OpenDate) 
				ELSE DATEPART(yyyy,crp2.OrderDate) 
			END as [Year]
			, CASE 
				WHEN (crp2.MenuID IN (@CN_Item_Id_1, @CN_Item_Id_2, @CN_Item_Id_3, @CN_Item_Id_4)) AND 
					(crp2.ItemType = 2) THEN crp2.QualifiedReceipts 
				ELSE 0.0 
			END as StudentLunchReceipts
			, CASE 
				WHEN (crp2.ItemType = 2) THEN crp2.ExtraMilkReceipts 
				ELSE 0.0 
			END as ExtraMilkReceipts
			, CASE 
				WHEN (crp2.ItemType = 2) THEN crp2.StudAlaCarteReceipts 
			END as StudentAlaCarteReceipts, 
			CASE 
				WHEN (crp2.ItemType = 2) THEN crp2.AdultReceipts 
			END as AdultReceipts
			, CASE 
				WHEN (crp2.ItemType < 2) THEN 0.0 
				WHEN (crp2.MenuID NOT IN (@CN_Item_Id_1, @CN_Item_Id_2, @CN_Item_Id_3, @CN_Item_Id_4) AND 
					crp2.QualifiedType = 1) THEN 0.0 
				ELSE crp2.TotalReceipts 
			END as TotalReceipts
			, crp2.ReceivedOnAccount as ReceivedOnAccount
			, 
			crp2.TotalDeposit as TotalDeposit 
		FROM CNReportPg2 crp2 
		WHERE (1 = 1)
		and (
		((dbo.dateonly(crp2.OrderDate) >= dbo.dateonly(@fromdate)) and (dbo.dateonly(crp2.OrderDate) <= dbo.dateonly(@todate)))
			or
			((dbo.dateonly(crp2.OpenDate) >= dbo.dateonly(@fromdate)) and (dbo.dateonly(crp2.OpenDate) <= dbo.dateonly(@todate)))
			)
		--(((dbo.dateonly(crp2.OrderDate) BETWEEN  dbo.dateonly(@fromdate) AND dbo.dateonly(@todate)) OR 
		--		(dbo.dateonly(crp2.OpenDate) BETWEEN  dbo.dateonly(@fromdate) AND dbo.dateonly(@todate))))
		--	--AND crp2.ItemType = 2 
	)
	insert into #CNReportPg2DayList(gDate, [Month]
		, [Day], [Year]
		, StudentLunchReceipts, ExtraMilkReceipts
		, StudentAlaCarteReceipts, AdultReceipts
		, TotalReceipts, ReceivedOnAccount
		, TotalDeposit)
	select 
		crp2.gDate, datepart(mm, crp2.gDate) [Month]
		, datepart(dd, crp2.gDate) [Day], datepart(yyyy, crp2.gDate) [Year]
		, isnull(SUM(StudentLunchReceipts), 0) StudentLunchReceipts, isnull(SUM(ExtraMilkReceipts), 0) ExtraMilkReceipts
		, isnull(SUM(StudentAlaCarteReceipts), 0) StudentAlaCarteReceipts, isnull(SUM(AdultReceipts), 0) AdultReceipts
		, isnull(SUM(TotalReceipts), 0) TotalReceipts, isnull(SUM(ReceivedOnAccount), 0) ReceivedOnAccount
		, isnull(SUM(TotalDeposit), 0) TotalDeposit
	from Pg2 crp2
	where (1 = 1)
	and (crp2.schoolid in (select schoolid from @tblschoolids))
	and (dbo.dateonly(crp2.gdate) >= dbo.dateonly(@fromdate)) and (dbo.dateonly(crp2.gdate) <= dbo.dateonly(@todate))
	group by crp2.gDate
	order by crp2.gDate

	--select * from @tbldatespg2
	--select * from #CNReportPg2DayList order by gdate

	delete from @tbldatespg2 where [date] in (select gdate from #CNReportPg2DayList)
	insert into #CNReportPg2DayList(gDate, [Month]
		, [Day], [Year]
		, StudentLunchReceipts, ExtraMilkReceipts
		, StudentAlaCarteReceipts, AdultReceipts
		, TotalReceipts, ReceivedOnAccount
		, TotalDeposit)
	select [date], datepart(mm, [date])
		, datepart(dd, [date]), datepart(yyyy, [date])
		, 0, 0
		, 0, 0
		, 0, 0
		, 0
	from @tbldatespg2

	select 
		* 
	--into Report_CNReportPg2DayList
	from #CNReportPg2DayList
	order by gDate

END
GO
