USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_SchoolAssignments]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_SchoolAssignments]
(
	@clientid bigint = null
    , @districtids varchar(2048) = NULL
	, @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = NULL
	, @selectedhomerooms varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @activetype int = 2 -- 0=InActive, 1=Active, 2=No Filter
	, @selectedlunchtypes varchar(2048) = null	 --
	, @deletedtype int = 2
	, @accountcreationdate datetime = NULL
	, @accountcreatedateTo datetime = null -- for Account Creation Date Ranage
	, @createtype int = 0 -- On=0,Before=1,On & Before=2,After=3,On & After=4,Between=5
	--, @withbiometrictype int = 2
	--, @allowedbiometrictype int = 2
)
AS
BEGIN
	
	--set @districtids = NULL--'4'
	--set @selectedcustomers = NULL--'(9,11,26)'
	--set @selectedschools = NULL--'(6,1)'
	--set @selectedhomerooms = NULL--'(1,3)'
	--set @selectedgrades = NULL--'(1)'
	--set @activetype = 2
	--set @selectedlunchtypes = null	 --
	--set @deletedtype = 2
	--set @accountcreationdate = NULL
	--set @createtype = 5 -- On=0,Before=1,On & Before=2,After=3,On & After=4,Between=5
	----set @withbiometrictype = 2
	----set @allowedbiometrictype = 2

	IF (OBJECT_ID('tempdb..#tmpReport_SchoolAssignments') IS NOT NULL) DROP TABLE #StudBals 
    begin            
		CREATE TABLE #tmpReport_SchoolAssignments (Customer_Id INTEGER, ABalance FLOAT, MBalance FLOAT, BonusBalance FLOAT, Balance FLOAT) 
	end

	declare
		@createbEgindate datetime = null
		, @createenddate datetime = null
		, @docreatedate bit = 0

	if(@accountcreationdate is not null)
	begin
		set @docreatedate = 1
		set @createbegindate = @accountcreationdate
		set @createenddate = @accountcreationdate
	end

	if(@accountcreationdate is null)
	begin
		set @createtype= null
	end

	insert into #tmpReport_SchoolAssignments(Customer_Id, ABalance, MBalance, BonusBalance, Balance)
	select Customer_Id, ABalance, MBalance, BonusBalance, Balance
	---from dbo.CustomerBalances_V2(NULL, @selectedcustomers, @selectedschools
	from dbo.CustomerBalances_V2(@clientid, @selectedcustomers, @selectedschools
		, @selectedgrades, @selectedhomerooms, @selectedlunchtypes
		, @activetype, @deletedtype, @accountcreationdate
		, @accountcreatedateTo, @createtype, NULL
		, 1)

	select
		sb.*
		, cr.*
		, case
			when RTRIM(cr.Middle) IS NULL or RTRIM(cr.Middle) = '' then UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')))
			else UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')) + ' ' + RTRIM(ISNULL(cr.Middle, '')) + '.') 
		end AS CustomerName
		, case  
			when cr.Address2 IS NULL or cr.Address2 = '' then UPPER(RTRIM(ISNULL(cr.Address1, '')) + ' ' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' 
				+ CASE 
					WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5) 
					ELSE RTRIM(ISNULL(cr.zip, '')) 
				END)  
			else UPPER(RTRIM(ISNULL(cr.Address1, '')) + ' ' + RTRIM(ISNULL(cr.Address2, '')) + '' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' 
				+ CASE 
					WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5) 
					ELSE RTRIM(ISNULL(cr.zip, '')) 
				END) 
		end AS CustomerAddress
		, '' as [break] 
	into #tmpReport_SchoolAssignments2
	from dbo.customerroster cr
	LEFT OUTER JOIN #tmpReport_SchoolAssignments sb ON sb.Customer_Id = cr.CSTID
	where (1 = 1)
	and (sb.customer_id is not null)
	and (cr.DISTID = isnull(@districtids, cr.DISTID))

	select 		
		--case cs.isPrimary 
		--	when 1 then cs.School_Id else NULL end PrimarySchoolId,
		--case cs.isPrimary 
		--	when 1 then s.SchoolName else NULL end PrimarySchoolName,
		--case cs.isPrimary 
		--	when 0 then cs.School_Id else NULL end AdditionalSchoolId,
		--case cs.isPrimary 
		--	when 0 then s.SchoolName else NULL end AdditionalSchoolName,
		sa.* 
	--into Report_SchoolAssignment 
	from #tmpReport_SchoolAssignments2 sa
	left join customer_School cs on (sa.Customer_Id = cs.Customer_id)
	left join schools s on (cs.School_Id = s.ID)
	order by sa.Customer_Id, sa.UserId, sa.CreationDate

	select 
		cs.Customer_Id,
		--case cs.isPrimary 
		--	when 1 then cs.School_Id else NULL end PrimarySchoolId,
		--case cs.isPrimary 
		--	when 1 then s.SchoolName else NULL end PrimarySchoolName,
		case cs.isPrimary 
			when 0 then cs.School_Id else NULL end AdditionalSchoolId,
		case cs.isPrimary 
			when 0 then s.SchoolName else NULL end AdditionalSchoolName
	--into Report_SchoolAssignment_AdditionalSchools
	from #tmpReport_SchoolAssignments2 sa
	left join customer_School cs on (sa.Customer_Id = cs.Customer_id)
	left join schools s on (cs.School_Id = s.ID)
	where (1 = 1)
	and (cs.isPrimary = 0)
	order by cs.Customer_Id	

	
	drop table #tmpReport_SchoolAssignments
	drop table #tmpReport_SchoolAssignments2
END
GO
