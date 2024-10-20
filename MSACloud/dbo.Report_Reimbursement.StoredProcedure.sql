USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_Reimbursement]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_Reimbursement]
(
	@monthrange int = null
	, @monthname varchar(32) = null
	, @year int = null
	, @districtid int = null
	, @locationids varchar(1000) = null
	, @servingschool bit = null
	, @severeneededlisted bit = null
	
	, @lunchpaid numeric(10, 2) = null
	, @lunchreduced numeric(10, 2) = null
	, @lunchfree numeric(10, 2) = null

	, @breakfastpaid numeric(10, 2) = null
	, @breakfastreduced numeric(10, 2) = null
	, @breakfastfree numeric(10, 2) = null

	, @breakfastseverepaid numeric(10, 2) = null
	, @breakfastseverereduced numeric(10, 2) = null
	, @breakfastseverefree numeric(10, 2) = null
)
AS
BEGIN
    declare
		@tblschools as table(id int identity(1, 1), schoolid int)

	declare
		@schoolcount int

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

	set @schoolcount = isnull(@@rowcount, 0)

	;

	with cte as
	(
		select
			rr.OperationDays
			, case when isnull(@servingschool, 1) = 1 then rr.servschid else rr.assignschid end schoolid
			, rr.schoolname
			, rr.District_Id
			, @schoolcount NumberOfLunchSchools
			, case when isnull(@severeneededlisted, 1) = 1 then @schoolcount else 0 end NumberOfSevereSchools
			, case when isnull(@severeneededlisted, 1) = 0 then @schoolcount else 0 end NumberOfBreakSchools
			, rr.[Month]
			, rr.[Year]
			, rr.SortDate
			, rr.EditCheckLunchADA EditCheckLunchADA
			, case when isnull(@severeneededlisted, 1) = 1 then rr.EditCheckLunchADA else rr.EditCheckBreakADA end EditCheckBreakADA
			, case when isnull(@severeneededlisted, 1) = 1 then rr.EditCheckLunchADA else rr.EditCheckSevereADA end EditCheckSevereADA
			, case when isnull(@severeneededlisted, 1) = 1 then (isnull(rr.BreakClaimedPaid, 0) + isnull(rr.SevereBrkClaimedPaid, 0)) else rr.BreakClaimedPaid end BreakClaimedPaid
			, case when isnull(@severeneededlisted, 1) = 1 then (isnull(rr.BreakClaimedReduced, 0) + isnull(rr.SevereBrkClaimedReduced, 0)) else rr.BreakClaimedReduced end BreakClaimedReduced
			, case when isnull(@severeneededlisted, 1) = 1 then (isnull(rr.BreakClaimedFree, 0) + isnull(rr.SevereBrkClaimedFree, 0)) else rr.BreakClaimedFree end BreakClaimedFree
			, case when isnull(@severeneededlisted, 1) = 1 then (isnull(rr.BreakClaimedQty, 0) + isnull(rr.SevereBrkClaimedQty, 0)) else rr.BreakClaimedQty end BreakClaimedQty
			, case when isnull(@severeneededlisted, 1) = 1 then 0 else rr.SevereBrkClaimedPaid end SevereBrkClaimedPaid
			, rr.SevereBrkClaimedReduced
			, rr.SevereBrkClaimedFree SevereBrkClaimedFree
			, case when isnull(@severeneededlisted, 1) = 1 then (isnull(rr.SevereBrkClaimedQty, 0) - isnull(rr.SevereBrkClaimedPaid, 0)) else rr.SevereBrkClaimedQty end SevereBrkClaimedQty
			
			, rr.ApprovedFree
			, rr.ApprovedRed
			, rr.LunchClaimedPaid
			, rr.LunchClaimedReduced
			, rr.LunchClaimedFree
			, rr.LunchClaimedQty

			, rr.TotalClaimedQty

			, @lunchpaid as LunchPaidReimRate
			, @lunchreduced as LunchRedReimRate
			, @lunchfree as LunchFreeReimRate

			, @breakfastpaid as BreakPaidReimRate
			, @breakfastreduced as BreakRedReimRate
			, @breakfastfree as BreakFreeReimRate

			, @breakfastseverepaid as SeverePaidReimRate
			, @breakfastseverereduced as SevereRedReimRate
			, @breakfastseverefree as SevereFreeReimRate
		FROM ReimbursementReport rr
		where (1 = 1)
		and (rr.SortDate between @monthrange and @monthrange)
		and (rr.District_Id = isnull(@districtid, rr.District_Id))
	)
	select 
		MAX(rr.OperationDays) as OperationDays
		, rr.SchoolName
		, rr.District_Id
		, rr.NumberOfLunchSchools
		, rr.NumberOfBreakSchools
		, rr.NumberOfSevereSchools
		, rr.[Month]
		, rr.[Year]
		, rr.SortDate
		, SUM(rr.EditCheckLunchADA) as EditCheckLunchADA

		, SUM(rr.EditCheckLunchADA) as EditCheckBreakADA
		, SUM(rr.EditCheckSevereADA) as EditCheckSevereADA
		, SUM(rr.BreakClaimedPaid) as BreakClaimedPaid
		, SUM(rr.BreakClaimedReduced) as BreakClaimedReduced
		, SUM(rr.BreakClaimedFree) as BreakClaimedFree
		, SUM(rr.BreakClaimedQty) as BreakClaimedQty
		, SUM(rr.SevereBrkClaimedPaid) as SevereBrkClaimedPaid
		, SUM(rr.SevereBrkClaimedReduced) as SevereBrkClaimedReduced
		, SUM(rr.SevereBrkClaimedFree) as SevereBrkClaimedFree
		, SUM(rr.SevereBrkClaimedQty) as SevereBrkClaimedQty

		, SUM(rr.ApprovedFree) as ApprovedFree
		, SUM(rr.ApprovedRed) as ApprovedRed
		, SUM(rr.LunchClaimedPaid) as LunchClaimPaid
		, SUM(rr.LunchClaimedReduced) as LunchClaimedReduced
		, SUM(rr.LunchClaimedFree) as LunchClaimedFree
		, SUM(rr.LunchClaimedQty) as LunchClaimedQty
		
		, SUM(rr.TotalClaimedQty) as TotalClaimedQty
		
		, ROUND(
			CASE 
				WHEN MAX(rr.OperationDays) <= 0 THEN 0 
				ELSE SUM(CAST(rr.LunchClaimedQty as float)) / MAX(CAST(rr.OperationDays as float)) 
			END, 2) as EditCheckADPLunch 

		, ROUND(
			CASE 
				WHEN MAX(rr.OperationDays) <= 0 THEN 0 ELSE SUM(CAST((rr.BreakClaimedQty) as float)) / MAX(CAST(rr.OperationDays as float)) 
	
			END, 2) as EditCheckADPBreak
		, ROUND(
			CASE 
				WHEN MAX(rr.OperationDays) <= 0 THEN 0 ELSE SUM(CAST((rr.SevereBrkClaimedQty) as float)) / MAX(CAST(rr.OperationDays as float)) 

			END, 2) as EditCheckADPSevere

		, ROUND(SUM(rr.LunchClaimedPaid) * @lunchpaid, 2) as LunchPaidReim
		, ROUND(SUM(rr.LunchClaimedReduced) * @lunchreduced, 2) as LunchRedReim
		, ROUND(SUM(rr.LunchClaimedFree) * @lunchfree, 2) as LunchFreeReim
		, ROUND((SUM(rr.LunchClaimedPaid) * @lunchpaid) + (SUM(rr.LunchClaimedReduced) * @lunchreduced) + (SUM(rr.LunchClaimedFree) * @lunchfree), 2) as LunchTotalReim

		, ROUND(SUM(rr.BreakClaimedPaid) * @breakfastpaid, 2) as BreakPaidReim
		, ROUND(SUM(rr.BreakClaimedReduced) * @breakfastreduced, 2) as BreakRedReim
		, ROUND(SUM(rr.BreakClaimedFree) * @breakfastfree, 2) as BreakFreeReim
		, ROUND((SUM(rr.BreakClaimedPaid) * @breakfastpaid) + (SUM(rr.BreakClaimedReduced) * @breakfastreduced) + (SUM(rr.BreakClaimedFree) * @breakfastfree), 2) as BreakTotalReim
		
		, @breakfastpaid breakfastpaidrate
		, @breakfastreduced breakfastreductedrate
		, @breakfastfree breakfastfreerate

		, @breakfastseverepaid breakfastseverepaidrate
		, @breakfastseverereduced breakfastseverereductedrate
		, @breakfastseverefree breakfastseverefreerate
	from cte rr
	where (1 = 1)
	and (schoolid in (select schoolid from @tblschools))

	group by 
		rr.SchoolName
		, rr.District_Id
		, rr.NumberOfLunchSchools
		, rr.NumberOfBreakSchools
		, rr.NumberOfSevereSchools
		, rr.[Month]
		, rr.[Year]
		, rr.SortDate
END
GO
