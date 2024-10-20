USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_IndianaDOE]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_IndianaDOE]
(
    @fromdate datetime = null
	, @todate datetime = null
	, @selectedschools varchar(2048) = null
)
AS
BEGIN
	--set @fromdate = '12/01/2015'
	--set @todate = '6/30/2018'

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
		select DISTINCT ISNULL(School_Id, 0) from IndianaDOE
	end

	declare
		@accountinfo as table(id int identity(1, 1)
			, Customer_Id int
			, ABalance float
			, MBalance float
			, BonusBalance float
			, LastUpdate datetime)

	insert into @accountinfo(Customer_Id, Abalance, MBalance, BonusBalance, LastUpdate)
	select
		ai.Customer_Id, ai.ABalance, ai.MBalance, ai.BonusBalance, ai.LastUpdatedUTC
	from accountinfo ai
	where (1 = 1)
	and ((dbo.dateonly(ai.LastUpdatedUTC) >= dbo.dateonly(isnull(@fromdate, ai.LastUpdatedUTC)))
		and (dbo.dateonly(ai.LastUpdatedUTC) <= dbo.dateonly(isnull(@todate, ai.LastUpdatedUTC))))

	IF OBJECT_ID('tempdb..#tmpIndianaDOEReport') IS NOT NULL DROP TABLE #tmpIndianaDOEReport


	select
		idoe.OrderDate
		, idoe.GDate
		, idoe.School_Id
		, idoe.SchoolName
		, idoe.OverShort
		, isnull((select isnull(ABalance, 0)+isnull(MBalance, 0)+isnull(BonusBalance, 0) from @accountinfo where (customer_Id = idoe.Customer_Id) 
			and (dbo.dateonly(LastUpdate) = dbo.dateonly(idoe.OrderDate))), 0) TotalBalance
		, idoe.Customer_Id
		, idoe.PaidPrice
		, idoe.Qty
		, (idoe.PaidPrice * idoe.Qty) as TotalReceipts
		, idoe.IsCashSale
		, idoe.IsAccountSale
		, idoe.IsBreakfast
		, idoe.IsLunch
		, idoe.IsStudent
		, idoe.IsAdult
		, idoe.IsAlaCarte
		, idoe.IsRefund
		, idoe.SoldType
		, idoe.TransType
		, idoe.SourceType
		, idoe.PaymentType
		, idoe.SaleType
		, idoe.IsOnlineACHPayment
		, idoe.IsOnlineCCPayment
		, idoe.TType
		, idoe.ADebit
		, idoe.MDebit
		, idoe.TotalDebit

	into #tmpIndianaDOEReport
	
	FROM IndianaDOE idoe
	LEFT JOIN @accountinfo ai on (idoe.Customer_Id = ai.Customer_Id)
	where (1 = 1)
	and (idoe.School_Id in (select schoolid from @tblschoolids))
	and (idoe.soldtype is not null)
	and ((dbo.dateonly(idoe.orderdate) >= dbo.dateonly(isnull(@fromdate, idoe.orderdate)))
		and (dbo.dateonly(idoe.orderdate) <= dbo.dateonly(isnull(@todate, idoe.orderdate))))

	select 
		dbo.dateonly(idr.orderdate) orderdate
		, idr.School_Id
		, idr.SchoolName
		, sum(case when idr.IsCashSale = 1 then (paidprice * qty) else 0 end) TotalCashReceipts
		, sum(case when (idr.IsBreakFast = 1) and (idr.IsCashSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) BreakfastCashSaleSStudent
		, sum(case when (idr.IsBreakFast = 1) and (idr.IsAccountSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) BreakfastAcctSalesStudent
		, sum(case when (idr.IsLunch = 1) and (idr.IsCashSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) LunchCashSalesStudent
		, sum(case when (idr.IsLunch = 1) and (idr.IsAccountSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) LunchAcctSalesStudent
		, sum(case when (idr.PaymentType not in ('0', '4')) -- Second Digit of TransType column 
			and (idr.SourceType <> '4') -- First Digit of TransType column 
			and (idr.SaleType = '3') -- Third Digit of TransType column 
			and (idr.TotalDebit > 0) then idr.TotalDebit else 0 end) PaymentOnAcctStudent
	
		, sum(case when (idr.IsBreakFast = 1) and (idr.IsCashSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) BreakfastCashSalesAdult
		, sum(case when (idr.IsBreakFast = 1) and (idr.IsAccountSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) BreakfastAcctSalesAdult
		, sum(case when (idr.IsLunch = 1) and (idr.IsCashSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) LunchCashSalesAdult
		, sum(case when (idr.IsLunch = 1) and (idr.IsAccountSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) LunchAcctSalesAdult
		,sum(case when idr.PaymentType not in ('0', '4', '5')
			and (idr.SourceType <> '4')
			and (idr.SaleType = '4')
			and (idr.TotalDebit > 0) then idr.TotalDebit else 0 end) PaymentOnAcctAdult
		, sum(case when idr.IsRefund = 1 then idr.TotalDebit else 0 end) Refund
		, sum(idr.OverShort) OverShort

		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsBreakFast = 1) and (idr.IsCashSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) AlaCarteBreakfastCashSalesStudent
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsBreakFast = 1) and (idr.IsAccountSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) AlaCarteBreakfastAcctSalesStudent
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsBreakFast = 1) and (idr.IsCashSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) AlaCarteBreakfastCashSalesAdult
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsBreakFast = 1) and (idr.IsAccountSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) AlaCarteBreakfastAcctSalesAdult

		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsLunch = 1) and (idr.IsCashSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) AlaCarteLunchCashSalesStudent
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsLunch = 1) and (idr.IsAccountSale = 1) and (idr.IsStudent = 1) then (paidprice * qty) else 0 end) AlaCarteLunchAcctSalesStudent
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsLunch = 1) and (idr.IsCashSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) AlaCarteLunchCashSalesAdult
		, sum(case when (idr.IsAlaCarte = 1) and (idr.IsLunch = 1) and (idr.IsAccountSale = 1) and (idr.IsAdult = 1) then (paidprice * qty) else 0 end) AlaCarteLunchAcctSalesAdult

		, sum (case when IsOnlineACHPayment = 1 then idr.TotalDebit else 0 end ) OnlineACHPayment
		, sum (case when idr.IsOnlineCCPayment = 1 then idr.TotalDebit else 0 end ) OnlineCreditCardPayment

		, sum(case when idr.TotalBalance < 0 then idr.TotalBalance else 0 end) NegativeAccounts
		, sum(case when idr.TotalBalance > 0 then idr.TotalBalance else 0 end) PositiveAccounts
		, sum(idr.TotalBalance) AccountBalance
	
	from #tmpIndianaDOEReport  idr

	group by dbo.dateonly(orderdate)
	, idr.School_Id
	, idr.SchoolName

	order by OrderDate
END
GO
