USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_PostedOnlinePayments]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_PostedOnlinePayments]
(
    @selectedschools varchar(800) = null
	, @fromdate datetime = null
	, @todate datetime = null
)
AS
BEGIN
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

	select
		op.schid
		, op.SchoolName
		, op.PostedDate
		, op.UserID
		, op.FirstName
		, op.Middle
		, op.LastName
		, op.PaymentTotal
		, op.Comments
		, @fromdate fromdate
		, @todate todate
	from OnlinePayments op
	where (1 = 1)
	and (op.SCHID in (select schoolid from @tblschoolids))
	and ((dbo.dateonly(op.AuthorizedDate) >= dbo.DateOnly(isnull(@fromdate, op.AuthorizedDate)))
		and (dbo.dateonly(op.AuthorizedDate) <= dbo.DateOnly(isnull(@todate, op.AuthorizedDate))))
	order by op.AuthorizedDate
	, op.UserId
END
GO
