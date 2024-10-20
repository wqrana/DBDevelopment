USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_BiometricRoster]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[Report_BiometricRoster]
(
    @clientid int = NULL
	, @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @selectedhomerooms varchar(2048) = null
	, @selectedlunchtypes varchar(2048) = null
	, @activetype int = 2
	, @deletedtype int = 2
	, @accountcreatedate datetime = null  
	, @accountcreatedateTo datetime = null -- for Account Creation Date Ranage
	, @createtype int = 0

)
AS
BEGIN
	--set @clientid = 9
	--set @selectedcustomers = null
	--set @selectedschools = null
	--set @selectedgrades = null
	--set @selectedhomerooms = null
	--set @selectedlunchtypes = null
	--set @activetype = 2
	--set @deletedtype = 2
	--set @accountcreatedate = null
	--set @createtype = NULL
	

    IF (OBJECT_ID('tempdb..#StudBals') IS NOT NULL) DROP TABLE #StudBals 
    begin            
		CREATE TABLE #StudBals (Customer_Id INTEGER, ABalance FLOAT, MBalance FLOAT, BonusBalance FLOAT, Balance FLOAT) 
	end

	declare
		@createbEgindate datetime = null
		, @createenddate datetime = null
		, @docreatedate bit = 0

	if(@accountcreatedate is not null)
	begin
		set @docreatedate = 1
		set @createbegindate = @accountcreatedate
		set @createenddate = @accountcreatedate
	end

	if(@accountcreatedate is null)
	begin
		set @createtype= null
	end

	insert into #studbals(Customer_Id, ABalance, MBalance, BonusBalance, Balance)
	select Customer_Id, ABalance, MBalance, BonusBalance, Balance
	from dbo.CustomerBalances_V2(@clientid, @selectedcustomers, @selectedschools
		, @selectedgrades, @selectedhomerooms, @selectedlunchtypes
		, @activetype, @deletedtype, @accountcreatedate
		, @accountcreatedateTo, @createtype, NULL
		, 1)

	select 
		--sb.Customer_Id
		--, sb.ABalance
		--, sb.MBalance
		--, sb.BonusBalance
		--, sb.Balance
		sb.*
		, cr.*
	into #StudBals2
	from dbo.customerroster cr
	LEFT OUTER JOIN #StudBals sb ON sb.Customer_Id = cr.CSTID
	where (1 = 1)
	and (sb.customer_id is not null)
	select 
		* 
	--into BiometricRoster
	from #StudBals2
	order by CreationDate
	drop table #StudBals2
END
GO
