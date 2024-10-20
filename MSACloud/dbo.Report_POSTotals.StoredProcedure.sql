USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_POSTotals]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_POSTotals]
(
    @selectedschools varchar(2048) = NULL
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
	--SET @selectedschools = '6,1'
	--set @fromdate = '1/5/2018'
	--set @todate = '2/12/2018'

    DECLARE @schoolnames VARCHAR(max)
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
		select distinct isnull(schid, 0) from CustomerRoster
	end

	if(len(ltrim(rtrim(isnull(@selectedschools, '')))) <= 0)
	begin
		set @schoolnames = 'District Wide'
	end
	else
	begin
		select @schoolnames = COALESCE(@schoolnames + '/', '') +  s.SchoolName
		from Schools s
		where (s.id in (select schoolid from @tblschoolids))
		order by s.SchoolName
	end

	SELECT 
        pt.GDate, 
        pt.SchoolID, 
        pt.SchoolName, 
        pt.DistrictName, 
        pt.POSName, 
        SUM(pt.BonusBucks) as BonusBucks, 
        SUM(pt.AlaCarteSales) as AlaCarte, 
        SUM(pt.MealPlanSales) as MealPlan, 
        SUM(pt.CashPayments) as CashPayments, 
        SUM(pt.CheckPayments) as CheckPayment, 
        SUM(pt.CreditPayments) as CreditPayments, 
        SUM(pt.Refunds) as Refunds, 
        SUM(pt.TotalPayments) as TotalPayments, 
        SUM(pt.CashSales) as CashSales, 
        SUM(pt.AcctSales) as AccountSales, 
        SUM(pt.TotalSales) as TotalSales, 
        SUM(pt.CashPaymentsCount) as CashPaymentsCount, 
        SUM(pt.CheckPaymentsCount) as CheckPaymentsCount, 
        SUM(pt.CreditPaymentsCount) as CreditPaymentsCount, 
        SUM(pt.RefundsCount) as RefundsCount, 
        SUM(pt.CashSalesCount) as CashSalesCount, 
        SUM(pt.AcctSalesCount) as AccountSalesCount, 
        SUM(pt.TotalPaymentCount) as TotalPaymentCount, 
        SUM(pt.TotalSalesCount) as TotalSalesCount, 
        SUM(pt.MealCount) as MealCount 
		, @schoolnames SchoolNames
		, @fromdate FromDate
		, @todate ToDate
    FROM POSTotals pt 
    WHERE (1 = 1)
	AND ((dbo.dateonly(pt.OrderDate) >= dbo.DateOnly(isnull(@fromdate, pt.OrderDate))) 
	AND (dbo.dateonly(pt.OrderDate) <= dbo.DateOnly(isnull(@todate, pt.OrderDate))))
	AND (pt.SCHID in (select schoolid from @tblschoolids))

	GROUP BY pt.GDate, pt.SchoolID, pt.SchoolName, pt.DistrictName, pt.POSName 

	order by pt.districtname, pt.GDate
END
GO
