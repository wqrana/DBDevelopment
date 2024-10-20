USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_PaymentTransfers]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_PaymentTransfers]
(
    @selectedschools varchar(2048) = NULL
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
	--SET @selectedschools = '6'
	--set @fromdate = '2/10/2018'
	--set @todate = '5/23/2018'

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
        pt.TransactionDate, 
        pt.TransactionID, 
        pt.FromUserID, 
        pt.ToUserID, 
		pt.FromFirstName,
		pt.FromMiddle,
		pt.FromLastName,
		pt.ToFirstName,
		pt.ToMiddle,
		pt.ToLastName,
        pt.FromPayment, 
        pt.ToPayment, 
        pt.FromSchoolName, 
        pt.ToSchoolName, 
        pt.FromHomeroom, 
        pt.ToHomeroom, 
        pt.FromGrade, 
        pt.ToGrade,
		dbo.dateonly(@fromdate) FromDate,
		dbo.dateonly(@todate) ToDate
	--into PaymentTransfersReport
    FROM PaymentTransfers pt 
	WHERE (1 = 1)
	AND ((dbo.dateonly(pt.TransactionDate) >= dbo.DateOnly(isnull(@fromdate, pt.TransactionDate))) 
	AND (dbo.dateonly(pt.TransactionDate) <= dbo.DateOnly(isnull(@todate, pt.TransactionDate))))
	AND ((pt.FromSCHID in (select schoolid from @tblschoolids)) OR (pt.ToSCHID in (select schoolid from @tblschoolids)))
--    WHERE (pt.TransactionDate BETWEEN <StartDate> AND <EndDate>)

--if (RptOpts->LocationSelection != )
--cSQL +=  AND ((pt.FromSCHID IN  + RptOpts->LocationSelection + ) OR (pt.ToSCHID IN  + RptOpts->LocationSelection + )) 
END
GO
