USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[IndianaDOE]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[IndianaDOE] as
select
	o.OrderDate	
	--, isnull((select ABalance from @accountinfo where (customer_Id = o.Customer_Id)), 0) ABalance
	--, isnull((select MBalance from @accountinfo where (customer_Id = o.Customer_Id)), 0) MBalance
	--, isnull((select BonusBalance from @accountinfo where (customer_Id = o.Customer_Id)), 0) BonusBalance
	--, isnull((select isnull(ABalance, 0)+isnull(MBalance, 0)+isnull(BonusBalance, 0) from @accountinfo where (customer_Id = o.Customer_Id) 
	--	and (dbo.dateonly(LastUpdate) = dbo.dateonly(o.OrderDate))), 0) TotalBalance
	--, cr.OverShort
	, o.GDate
	, o.School_Id
	, s.SchoolName
	, cr.OverShort
	, o.Customer_Id
	, it.PaidPrice
	, it.Qty
	, (it.PaidPrice * it.Qty) as TotalReceipts
	, cast(case when o.Customer_Id in (-2,-3) then 'true' else 'false' end as bit)IsCashSale
	, cast(case when o.Customer_Id > 0  then 'true' else 'false' end as bit)IsAccountSale
	, cast(case when ((it.soldtype = 10 or ct.canFree = 1 or ct.canReduce = 1) and (m.ItemType = 2)) then 'true' else 'false' end as bit)IsBreakfast
	, cast(case when (it.soldtype = 10 or ct.CanFree = 1 or ct.CanReduce = 1) and (isnull(m.ItemType, 0) in (0, 1)) then 'true' else 'false' end as bit)IsLunch	
	, cast(case when substring(cast(o.TransType as varchar(30)), 3, 1) in ('1', '3') then 'true' else 'false' end as bit)IsStudent
	, cast(case when substring(cast(o.TransType as varchar(30)), 3, 1) in ('2', '4') then 'true' else 'false' end as bit)IsAdult
	, cast(case it.SoldType
		when 20 then 'true' else 'false'
		end as bit) IsAlaCarte
	, cast(case when substring(cast(o.TransType as varchar(30)), 2, 1) = '4' then 'true' else 'false' end as bit)IsRefund
	, it.SoldType
	, o.TransType
	, substring(cast(o.TransType as varchar(30)), 1, 1) SourceType
	, substring(cast(o.TransType as varchar(30)), 2, 1) PaymentType
	, substring(cast(o.TransType as varchar(30)), 3, 1) SaleType
	
	, cast(case when (substring(cast(o.TransType as varchar(30)), 1, 2)) = '46' then 'true' else 'false' end as bit) IsOnlineACHPayment
	, cast(case when (substring(cast(o.TransType as varchar(30)), 1, 2)) = '43' then 'true' else 'false' end as bit) IsOnlineCCPayment
	, substring(cast(o.TransType as varchar(30)), 3, 1) TType	
	, o.ADebit
	, o.MDebit
	, (o.ADebit+o.MDebit) TotalDebit
FROM Orders o
left join Schools s on (o.School_Id = s.ID)
inner join transactions t on (o.Id = t.Order_Id)
inner join cashresults cr on (cr.Id = t.CashRes_Id)
--LEFT JOIN @accountinfo ai on (o.Customer_Id = ai.Customer_Id)
INNER JOIN Items it ON it.Order_Id = o.Id
LEFT OUTER JOIN Menu m ON m.Id = it.Menu_Id
LEFT OUTER JOIN Category cat ON cat.Id = m.Category_Id
LEFT OUTER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
where (1 = 1)
and (it.soldtype is not null)
--and ((dbo.dateonly(o.orderdate) >= dbo.dateonly(isnull(@fromdate, o.orderdate)))
--	and (dbo.dateonly(o.orderdate) <= dbo.dateonly(isnull(@todate, o.orderdate))))
GO
