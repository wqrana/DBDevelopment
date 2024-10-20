USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_QuarterHourDetailed]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_QuarterHourDetailed]
(
    @selectedschools varchar(2048) = NULL
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
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
		SELECT DISTINCT isnull(schid, 0) from CustomerRoster
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
        qhd.Interval, 
        qhd.CategoryName, 
        qhd.ItemName, 
        SUM(qhd.Qty) as Qty, 
        qhd.PaidPrice, 
        SUM(qhd.NetPrice) as NetPrice
		, @fromdate fromdate
		, @todate todate
		, @schoolnames schoolnames
    FROM QuarterHourDetailed qhd
    --WHERE qhs.OrderDate BETWEEN <StartDate> AND <EndDate>
	WHERE (1 = 1)
	AND ((dbo.dateonly(qhd.OrderDate) >= dbo.DateOnly(isnull(@fromdate, qhd.OrderDate))) 
		AND (dbo.dateonly(qhd.OrderDate) <= dbo.DateOnly(isnull(@todate, qhd.OrderDate))))
    --AND qhs.SCHID in (<School ID List>)
	AND (qhd.SCHID in (select schoolid from @tblschoolids))

    GROUP BY qhd.Interval, qhd.CategoryName, qhd.ItemName, qhd.PaidPrice, qhd.SchoolName
	order by qhd.Interval
END
GO
