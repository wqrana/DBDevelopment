USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_CustomerActivation]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_CustomerActivation]
(
	@clientid int = NULL
    , @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = NULL
	, @selectedhomerooms varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @activetype int = 2 -- 0=InActive, 1=Active, 2=No Filter
	, @selectedlunchtypes varchar(2048) = null
	, @deletedtype int = 2
	, @activationfrom datetime = null
	, @activationto datetime = null
	, @deactivationfrom datetime = null
	, @deactivationto datetime = null
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
	--set @activationfrom = null--'9/18/2017'
	--set @activationto = null
	--set @deactivationfrom = null
	--set @deactivationto = null

	--set @activationfrom = '6/27/2017'
	--set @activationto = '7/10/2017'
	--set @deactivationfrom = '3/2/2018'
	--set @deactivationto = '3/15/2018'

    IF (OBJECT_ID('tempdb..#tmpReport_CustomerActivation') IS NOT NULL) DROP TABLE #tmpReport_CustomerActivation 
    begin            
		CREATE TABLE #tmpReport_CustomerActivation (Customer_Id INTEGER, ABalance FLOAT, MBalance FLOAT, BonusBalance FLOAT, Balance FLOAT) 
	end

	insert into #tmpReport_CustomerActivation(Customer_Id, ABalance, MBalance, BonusBalance, Balance)
	select Customer_Id, ABalance, MBalance, BonusBalance, Balance
	from dbo.CustomerBalances_V2(@clientid, @selectedcustomers, @selectedschools
		, @selectedgrades, @selectedhomerooms, @selectedlunchtypes
		, @activetype, @deletedtype, NULL
		, NULL, NULL, NULL
		, 1)

	select 
		RCA.*
		, c.Id
		, c.LunchType
		, CASE c.LunchType
			WHEN 1 THEN 'Paid'
			WHEN 2 THEN 'Reduced'
			WHEN 3 THEN 'Free'
			WHEN 5 THEN 'Meal Plan'
			ELSE 'Adult'
		END AS LunchTypeStatus
		, CASE
			WHEN RTRIM(c.Middle) IS NULL
				OR RTRIM(c.Middle) = '' THEN UPPER(RTRIM(ISNULL(c.LastName, '')) + ', ' + RTRIM(ISNULL(c.FirstName, '')))
			ELSE UPPER(RTRIM(ISNULL(c.LastName, '')) + ', ' + RTRIM(ISNULL(c.FirstName, '')) + ' ' + RTRIM(ISNULL(c.Middle, '')) + '.')
		END AS CustomerName
		, c.FirstName
		, c.Middle
		, c.LastName
		, g.[Name] Grade
		, cs.School_Id
		, s.SchoolName
		, c.HomeRoom_Id HomeroomId
		, hr.[Name] Homeroom
		, c.UserId
		, REPLACE(st.householdId, -1, 'DC') householdId
		, CASE WHEN c.ReactiveDate Is not null then dbo.dateonly(c.ReactiveDate) else dbo.dateonly(c.CreationDate) end activeDate
		, dbo.dateonly(c.deactiveDate) deactiveDate	
	into #tmpReport_CustomerActivation2
	from customers c	
	LEFT JOIN (select * from Customer_School cs where (cs.isPrimary = 1) )cs ON (c.Id = cs.Customer_Id)
	LEFT JOIN #tmpReport_CustomerActivation RCA on (c.Id = RCA.Customer_Id)
	LEFT JOIN Schools s on (cs.School_Id = s.Id)
	LEFT JOIN Grades g on (c.Grade_Id = g.Id)
	LEFT JOIN Homeroom hr on (c.Homeroom_Id = hr.ID)
	LEFT JOIN STUDENT st ON (c.Id = st.Customer_Id)
	where (1 = 1)
	and (RCA.Customer_Id is not null)

	select
		* 
	--into CustomerActivation_Report
	from #tmpReport_CustomerActivation2 ca
	where (1 = 1)
	and (dbo.dateonly(ca.activeDate) >= dbo.dateonly(isnull(@activationfrom, ca.activeDate))) and (dbo.dateonly(ca.activeDate) <= dbo.dateonly(isnull(@activationto, ca.activeDate))) 
	and (dbo.dateonly(ca.deactiveDate) >= dbo.dateonly(isnull(@deactivationfrom, ca.deactiveDate))) and (dbo.dateonly(ca.deactiveDate) <= dbo.dateonly(isnull(@deactivationto, ca.deactiveDate))) 

	ORDER BY ca.deactiveDate

	drop table #tmpReport_CustomerActivation2

	--SELECT DeactiveDate,* FROM CUSTOMERS WHERE ID = 45
END
GO
