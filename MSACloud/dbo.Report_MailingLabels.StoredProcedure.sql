USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_MailingLabels]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_MailingLabels]
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
	
	--set @clientid = 9
	--set @selectedcustomers = null
	--set @selectedschools = '(6)'
	--set @selectedhomerooms = null
	--set @selectedgrades = null
	--set @activetype = 2 -- 0=InActive, 1=Active, 2=No Filter
	--set @selectedlunchtypes = null
	--set @deletedtype = 2


    IF (OBJECT_ID('tempdb..#tmpReport_MailingLabel') IS NOT NULL) DROP TABLE #tmpReport_MailingLabel 
    begin            
		CREATE TABLE #tmpReport_MailingLabel (Customer_Id INTEGER, ABalance FLOAT, MBalance FLOAT, BonusBalance FLOAT, Balance FLOAT) 
	end

	insert into #tmpReport_MailingLabel(Customer_Id, ABalance, MBalance, BonusBalance, Balance)
	select Customer_Id, ABalance, MBalance, BonusBalance, Balance
	from dbo.CustomerBalances_V2(@clientid, @selectedcustomers, @selectedschools
		, @selectedgrades, @selectedhomerooms, @selectedlunchtypes
		, @activetype, @deletedtype, NULL
		, NULL, NULL, NULL
		, 1)

	select
		sb.*
		, cr.*
		, '' as [break] 
	into #tmpReport_MailingLabel2
	from dbo.customerroster cr
	LEFT OUTER JOIN #tmpReport_MailingLabel sb ON (sb.Customer_Id = cr.CSTID)
	where (1 = 1)
	and (sb.customer_id is not null)

	select
		sa.* 
	from #tmpReport_MailingLabel2 sa
	left join customer_School cs on (sa.Customer_Id = cs.Customer_id)
	left join schools s on (cs.School_Id = s.ID)

	drop table #tmpReport_MailingLabel
	drop table #tmpReport_MailingLabel2
END
GO
