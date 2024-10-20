USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_DetailedDailyCashier]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report_DetailedDailyCashier] 
(
    @fromdate datetime = null
	, @todate datetime = null
	--, @selectedschoolids varchar(800) = null
	, @sessiontype tinyint = NULL -- POS Session Only = 1, Admin Session Only = 2, Both = 3
	, @calculatetax bit = null
)
AS
BEGIN
 --   set @fromdate = '4/13/2017'
	--set @todate = '6/30/2018'
	--set @selectedschoolids = null
	--set @sessiontype = null
	--set @calculatetax = 0

	--declare
	--	@tblschoolids as table (id int identity(1,1)
	--		, schoolid int)
	--if(len(ltrim(rtrim(isnull(@selectedschoolids, '')))) > 0)
	--begin
	--	insert into @tblschoolids(schoolid)
	--	select val from dbo.SplitString(@selectedschoolids, ',')
	--end
	--else
	--begin
	--	insert into @tblschoolids(schoolid)
	--	select id from Schools
	--end
	;

	with cte as
	(
	SELECT 
		dc.CASHRESID,     
		dc.SCHID, 
		dc.SchoolID, 
		dc.SchoolName, 
		dc.POSName, 
		dc.UserID, 
		--<Employee_Name>,
		dc.FirstName,
		dc.Middle,
		dc.LastName,
		--case when dc.POSID <> -3 THEN 1 ELSE 0 end IsPosSession,
		--case when dc.POSID = -3 THEN 1 ELSE 0 end IsAdminSession,
		dc.POSID, 
		case when dc.POSID <> -3 then 1 else
			case when dc.POSID = -3 then 2 else 3 end 
			end SessionType,
		case when dc.POSID <> -3 then 'POS' else
			case when dc.POSID = -3 then 'Admin' else NULL end
			end SessionTypeName,
	
		dc.OpenDate, 
		dc.CloseDate, 
		dc.OpenAmount, 
		dc.CloseAmount, 
		dc.Deposit, 
		dc.Additional, 
		dc.PaidOuts, 
		dc.OverShort, 
		SUM(dc.CashTaken) as CashTaken, 
		SUM(dc.ChecksTaken) as ChecksTaken, 
		SUM(dc.CreditTaken) as CreditTaken, 
		SUM(dc.Refunds) as Refunds, 
		SUM(dc.TotalTaken) as TotalTaken, 
		SUM(dc.CashSalesCount) as CashSalesCount, 
		SUM(dc.CashSales) as CashSales, 
		SUM(dc.AccountSalesChargedCount) as AccountSalesChargedCount, 
		SUM(dc.AccountSalesCharged) as AccountSalesCharged, 
		SUM(dc.AccountSalesPartialCount) as AccountSalesPartialCount, 
		SUM(dc.AccountSalesPartial) as AccountSalesPartial, 
		SUM(dc.AccountSalesFullCount) as AccountSalesFullCount, 
		SUM(dc.AccountSalesFull) as AccountSalesFull, 
		SUM(dc.AccountSalesAboveCount) as AccountSalesAboveCount, 
		SUM(dc.AccountSalesAbove) as AccountSalesAbove, 
		case when isnull(@calculatetax, 0) = 1 then sum(dc.TaxCollected) else 0.00 end TaxCollected,
		case when isnull(@calculatetax, 0) = 1 then sum(dc.TotalSales + dc.TaxCollected) else SUM(dc.TotalSales) end TotalSales,
		SUM(dc.TotalSalesCount) as TotalSalesCount,
		dbo.DateOnly(@fromdate) FromDate, 
		dbo.DateOnly(@todate) ToDate
		FROM DailyCashierDetailed dc 
		WHERE (1 = 1)
		--and (dc.SCHID in (select schoolid from @tblschoolids))
		AND ((dbo.dateonly(isnull(dc.OpenDate, dc.OrderDate)) >= dbo.dateonly(isnull(@fromdate, isnull(dc.OpenDate, dc.OrderDate)))) 
			AND (dbo.dateonly(isnull(dc.OpenDate, dc.OrderDate)) <= dbo.dateonly(isnull(@todate, isnull(dc.OpenDate, dc.OrderDate)))))
		AND 
		((dc.OpenAmount <> 0) OR (dc.CloseAmount <> 0) OR (dc.PaidOuts <> 0) OR (dc.Additional <> 0) OR (dc.CashSalesCount <> 0) OR 
			(dc.CashSales <> 0) OR (dc.AccountSalesChargedCount <> 0) OR (dc.AccountSalesCharged <> 0) OR (dc.AccountSalesPartialCount <> 0) OR 
			(dc.AccountSalesPartial <> 0) OR (dc.AccountSalesFullCount <> 0) OR (dc.AccountSalesFull <> 0) OR (dc.AccountSalesAboveCount <> 0) OR 
			(dc.AccountSalesAbove <> 0) OR (dc.TaxCollected <> 0) OR (dc.TotalSalesCount <> 0) OR (dc.TotalSales <> 0) OR (dc.TotalTaken <> 0)) 

		GROUP BY 
			dc.CASHRESID, 
			dc.POSID, 
			dc.SCHID, 
			dc.SchoolID, 
			dc.SchoolName, 
			dc.POSName, 
			dc.UserID,  +
			--FormatEmployeeName(, dc, false, true) + , 
			dc.FirstName,
			dc.Middle,
			dc.LastName,		
			dc.OpenDate, 
			dc.CloseDate, 
			dc.OpenAmount, 
			dc.CloseAmount, 
			dc.Deposit, 
			dc.Additional, 
			dc.PaidOuts, 
			dc.OverShort 
	)
	select 
		*
	from cte
	where (1 = 1)
	and (isnull(cte.SessionType, 3) = isnull(@sessiontype, isnull(cte.SessionType, 3)))
	ORDER BY SchoolName, POSName
END
GO
