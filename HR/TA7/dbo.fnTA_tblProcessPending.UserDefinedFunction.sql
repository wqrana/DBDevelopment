USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnTA_tblProcessPending]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION [dbo].[fnTA_tblProcessPending]
--GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/02/2019
-- Description:	Gets the users and startdate that are pending computing
--				@UserID = 0 -> ALL
--				@UserID <> 0 -> UserID
-- =============================================
CREATE FUNCTION [dbo].[fnTA_tblProcessPending]
(
	@UserID int
)
RETURNS 
@tblPendingUsers TABLE 
(
	intUserID int,
	dtPunchDate datetime
	) 
-- WITH ENCRYPTION
AS
BEGIN

---- New punches
INSERT INTO @tblPendingUsers
select distinct e_id,CONVERT(date, min(e.e_date)) tenter  from tenter e inner join tuser u on e.e_id = u.id 
	where b_Processed = 0   and e_result = '0' and e_mode in ('1','2','5') and nStatus = 1
	and (e_id = @UserID OR @UserID = 0) AND nPayrollRuleID in (Select id from tPayrollRule)
	group by e.e_id 


-- Un prcessed Punchdata
INSERT INTO @tblPendingUsers
select distinct  e_id, min(DTPunchDateTime) Punchdata from tPunchData e inner join tuser u on e.e_id = u.id 
	where b_Processed = 0   and e_result = '0' and sModType <> 'd' and u.nStatus = 1
	and (e_id = @UserID OR @UserID = 0)  AND nPayrollRuleID in (Select id from tPayrollRule)
	group by e.e_id

--New Transactions
INSERT INTO @tblPendingUsers
select distinct e_id, min(DTPunchDate) tpunchpair from tpunchpair e inner join tuser u on e.e_id = u.id 
	where b_Processed = 0   and u.nStatus = 1
	and (e_id = @UserID OR @UserID = 0)  AND nPayrollRuleID in (Select id from tPayrollRule)
	group by e.e_id

--Unprocessed punchdates
INSERT INTO @tblPendingUsers
select distinct e_id, min(DTPunchDate) tpunchdate from tpunchdate  e inner join tuser u on e.e_id = u.id 
	where b_Processed  = 0 and  DTPunchDate <= datediff(d, 0, getdate()) and u.nStatus = 1 
	and (e_id = @UserID OR @UserID = 0) AND nPayrollRuleID in (Select id from tPayrollRule)
	group by e.e_id

--Missing PunchDates 
INSERT INTO @tblPendingUsers
select id, cast( getdate() as date)NoPunchDate from tuser u where id not in (select e_id from tPunchDate where DTPunchDate = cast( getdate() as date)) and u.nStatus = 1
		and (id = @UserID OR @UserID = 0) AND nPayrollRuleID in (Select id from tPayrollRule)

--TimeSheets Not Created
INSERT INTO @tblPendingUsers
select id,cast( getdate() as date) NoTimeSheets from tuser u where id not in (select e_id from tReportWeek 
	where DTStartDate <= cast( getdate() as date) and   DTEndDate >= cast( getdate() as date)) and u.nStatus = 1 
	and (id = @UserID OR @UserID = 0) AND nPayrollRuleID in (Select id from tPayrollRule)
	
-- Timesheet does not match
INSERT INTO @tblPendingUsers
select rw.e_id , rw.DTStartDate from tReportWeek rw inner join 
(select nWeekID, sum(dblREGULAR) dblREGULAR from tPunchDate group by nWeekID ) PDT
ON rw.nWeekID = pdt.nWeekID
where rw.dblREGULAR <> pdt.dblREGULAR
and DTStartDate > DATEADD(day,-30,getdate())
  
--Pay Cycle Not Processed
INSERT INTO @tblPendingUsers
select distinct rw.e_id, min(DTPunchDate) paycle from tPunchDate pd inner join tReportWeek rw on pd.nWeekID = rw.nWeekID
	inner join tuser u on rw.e_id = u.id
	where pd.sHoursSummary LIKE '%PCHR%'
	and rw.DTEndDate between DATEADD(D,-14, getdate()) AND GETDATE()
	and (rw.e_id = @UserID OR @UserID = 0)  AND u.nPayrollRuleID in (Select id from tPayrollRule)
	group by rw.e_id

--TimeSheets Say Processsing
INSERT INTO @tblPendingUsers
select e_id, DTStartDate ProcTimeSheets from tReportWeek rw inner join tuser u on rw.e_id = u.id
	where DTEndDate >= cast( dateadd(DAY,-30, getdate()) as date)  AND rw.nPayRuleID in (Select id from tPayrollRule) and
	 sHoursSummary LIKE '%Process%' and u.nStatus = 1

DECLARE @PastDaysAmount int = -16
--Select any missing userid, punchdate values from the treportweek,tpunchdate union of dates.
--This will detect both missing dates and missing timesheets
INSERT INTO @tblPendingUsers
select id,min(TheDate) TheDate from DateCalendar dc cross join tuser u
left outer join 
(select pdt.e_id, pdt.DTPunchDate FROM tPunchDate pdt inner join tReportWeek rw on pdt.nWeekID = rw.nWeekID) pdt on dc.TheDate = pdt.DTPunchDate and u.id = pdt.e_id
where TheDate BETWEEN DATEADD("D",@PastDaysAmount,getdate()) AND getdate()  
and nStatus = 1 and isnull(nPayrollRuleID,0) <> 0
and pdt.DTPunchDate is null
group by id

RETURN
END

GO
