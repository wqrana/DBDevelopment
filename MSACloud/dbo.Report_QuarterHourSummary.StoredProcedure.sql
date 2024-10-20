USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_QuarterHourSummary]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_QuarterHourSummary]
(
    @selectedschools varchar(2048) = NULL
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
	DECLARE @schoolnames VARCHAR(max)
	--SELECT @List = COALESCE(@List + ',', '') + CAST(OfferID AS VARCHAR)
	--FROM   Emp
	--WHERE  EmpID = 23

	--SELECT @List 

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
		select DISTINCT ISNULL(schid, 0) from CustomerRoster
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
        qhs.Interval, 
        SUM(qhs.Qty) as OrderCount, 
        SUM(qhs.TotalSales) as TotalSales 
		, qhs.SchoolName
		, @fromdate fromdate
		, @todate todate
		, @schoolnames schoolnames
	--into QuarterHourSummary_Report
    FROM QuarterHourSummary qhs 
    --WHERE qhs.OrderDate BETWEEN <StartDate> AND <EndDate>
	WHERE (1 = 1)
	AND ((dbo.dateonly(qhs.OrderDate) >= dbo.DateOnly(isnull(@fromdate, qhs.OrderDate))) 
		AND (dbo.dateonly(qhs.OrderDate) <= dbo.DateOnly(isnull(@todate, qhs.OrderDate))))
    --AND qhs.SCHID in (<School ID List>)
	AND (qhs.SCHID in (select schoolid from @tblschoolids))

    GROUP BY qhs.Interval, qhs.SchoolName
	order by qhs.Interval
END
GO
