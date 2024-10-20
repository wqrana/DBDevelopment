USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_DailyMealClaim]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_DailyMealClaim]
(
    @locationids varchar(1000) = NULL--'6,1'
	, @AttendanceFactor numeric(10, 2) = NULL--95
	, @SNPTotalMembership numeric(10, 2) = NULL--0
	, @SNPUNumber numeric(10, 2) = NULL--0
	--, @AttendAdjElig numeric(10, 2) = 0
	, @fromdate datetime = NULL--'2/1/2018'
	, @todate datetime = NULL--'2/28/2018'
	, @byservingdate bit = NULL--1
)
AS
BEGIN
	
	--set @locationids = '6'
	--set @AttendanceFactor = 95
	--set @SNPTotalMembership = 0
	--set @SNPUNumber = 0
	----, @AttendAdjElig numeric(10, 2) = 0
	--set @fromdate = '2/1/2018'
	--set @todate = '2/28/2018'
	--set @byservingdate = 1

	set @SNPTotalMembership = isnull(@SNPTotalMembership, 0)
	set @SNPUNumber = isnull(@SNPUNumber, 0)


    declare
		@tblschoolids as table(id int identity(1, 1), schoolid int)

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


	/* Commons for report */
	SELECT 
	--* into DailyMealSales_Common from ( select
		DigitYear, 
		NameMonth, 
		MonthSort, 
		SCHID,
		SchoolName, 
		SUM(FreeElig) as FreeElig, 
		SUM(RedElig) as RedElig, 
		SUM(PaidElig) as PaidElig,
		(@AttendanceFactor) as AttendFactor,

		(@SNPTotalMembership)  as SNPTotalMember,
		(@SNPUNumber) as SNPUNumber,
		--(@AttendAdjElig) as AttendAdjElig, 
		@SNPTotalMembership * (@AttendanceFactor *100) AttendAdjElig,

		MAX(LunchServDays) as LunchServDays, 
		MAX(BreakServDays) as BreakServDays, 
		MAX(SnackServDays) as SnackServDays 
	FROM 
	(select
		-- Primary School 
		-- PRIMSCHID as SCHID, 
		-- OR
		-- Serving School
		-- SCHID, 
		SCHID,
		s.SchoolName,
		NameMonth, DigitYear, MonthSort, 
		MAX(FreeElig) as FreeElig, MAX(RedElig) as RedElig, MAX(PaidElig) as PaidElig, 
		SUM(LunchServDays) as LunchServDays, SUM(BreakServDays) as BreakServDays, SUM(SnackServDays) as SnackServDays 
	from DailyMealClaimCommon  dmcc
	left join schools s on (dmcc.schid = s.id)
	where (dmcc.schid in (select schoolid from @tblschoolids))

	group by 
					
	-- Primary School
	-- PRIMSCHID, 
	-- Serving School
	SCHID, 
	schoolname,
	NameMonth, DigitYear, MonthSort) sdmcc 
	WHERE (1 = 1)
	--and (CAST(CAST(MonthSort as varchar) + '/1/' + CAST(DigitYear as varchar) as datetime) BETWEEN @fromdate AND @todate) 
	and ((monthsort = DATEPART(m, @fromdate)) and (digityear = DATEPART(yyyy, @fromdate)))
	-- Location Filter
	AND sdmcc.SCHID IN (select schoolid from @tblschoolids)
	GROUP BY DigitYear, NameMonth, MonthSort, SCHID, SchoolName
	--) x
	;
	/* Page 1 query */
	with pg1 as
	(
		SELECT 
						GDate as ORDERDATE, 
						--case when isnull(@byservingdate, 1) = 1 then dmc.PRIMSCHID else dmc.SCHID END schoolid,
						dmc.schid schoolid,
						Month, 
						Year, 
						SUM(PaidElig) as PaidElig, 

				ROUND((SUM(PaidElig) * (@AttendanceFactor) /100),0) as PaidAFElig, 
				SUM(RedElig) as RedElig, 
				ROUND((SUM(RedElig) * (@AttendanceFactor /100.0)),2) as RedAFElig, 
				SUM(FreeElig) as FreeElig, 
				ROUND((SUM(FreeElig) * (@AttendanceFactor/100.0)),2) as FreeAFElig, 
				sum(PaidLunchClaim) as PaidLunchClaim, 
						sum(RedLunchClaim) as RedLunchClaim, 
						sum(FreeLunchClaim) as FreeLunchClaim, 
						sum(PaidBreakClaim) as PaidBreakClaim, 
						sum(RedBreakClaim) as RedBreakClaim, 
						sum(FreeBreakClaim) as FreeBreakClaim, 
						sum(PaidSnackClaim) as PaidSnackClaim, 
						sum(RedSnackClaim) as RedSnackClaim, 
						sum(FreeSnackClaim) as FreeSnackClaim, 
						sum(TotalLunchClaim) as TotalLunchClaim, 
						sum(TotalBreakClaim) as TotalBreakClaim, 
						sum(TotalSnackClaim) as TotalSnackClaim, 
						sum(AdultLunchPaid) as AdultLunchPaid, 
						sum(AdultBreakPaid) as AdultBreakPaid, 
						sum(EmployeeMeals) as EmployeeMeals 
					FROM DailyMealClaims dmc 
					WHERE (dmc.ORDERDATE BETWEEN @fromdate AND @todate ) 
						---- If Location by Primary school
						--AND dmc.PRIMSCHID IN (<School_List>)
						---- If Location by Serving School
						--AND dmc.SCHID IN (<School_List>)
					GROUP BY dmc.Year, dmc.Month, dmc.GDate, dmc.SCHID
					HAVING sum(TotalLunchClaim) > 0 OR sum(TotalBreakClaim) > 0 OR sum(TotalSnackClaim) > 0 
	)
	select * 
	--into DailyMealSales_Pg1
	from pg1
	where (1 = 1)
	and (pg1.schoolid in (select schoolid from @tblschoolids))

	;
	with pg2 as(
		SELECT 
			ORDERDATE,
			dms.schid schoolid,
			Month, 
			Year, 
			SUM(StudLunchSales) as StudLunchSales, 
			SUM(StudBreakSales) as StudBreakSales, 
			SUM(StudSnackSales) as StudSnackSales, 
			SUM(AdultLunchSales) as AdultLunchSales, 
			SUM(AdultBreakSales) as AdultBreakSales, 
			SUM(AlaCarteSales) as AlaCarteSales, 
			SUM(OtherIncome) as OtherIncome, 
			SUM(CashSubTotal) as CashSubTotal, 
			SUM(OverUnder) as OverUnder, 
			SUM(TotalDeposit) as TotalDeposit 
		FROM DailyMealSales dms 
		WHERE (dms.ORDERDATE BETWEEN  @fromdate AND  @todate) 

		---- Location Filter
		---- Primary School
		--AND dms.PRIMSCHID IN (<School_List>)
		---- Serving School
		--AND dms.SCHID IN (<School_List>)
					
		GROUP BY dms.Year, dms.Month, dms.ORDERDATE , dms.schid
		HAVING SUM(StudLunchSales) > 0 OR SUM(StudBreakSales) > 0 OR SUM(StudSnackSales) > 0 OR 
			SUM(AdultLunchSales) > 0 OR SUM(AdultBreakSales) > 0 OR SUM(AlaCarteSales) > 0 OR 
			SUM(OtherIncome) <> 0 OR SUM(CashSubTotal) <> 0 OR SUM(OverUnder) <> 0 OR SUM(TotalDeposit) <> 0 
	)
	select * 
	--into DailyMealSales_Pg2
	from pg2
	where (1 = 1)
	and (pg2.schoolid in (select schoolid from @tblschoolids))


END
GO
