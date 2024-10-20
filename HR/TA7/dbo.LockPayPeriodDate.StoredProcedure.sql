USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[LockPayPeriodDate]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LockPayPeriodDate]
@PeriodDate as datetime,
@PayPeriodType as datetime,
@Lock as bit
AS
DECLARE @ToDate as datetime

select @ToDate = (select max(r.DTEndDate) from treportweek r where r.DTStartDate <= @PeriodDate and r.DTEndDate >= @PeriodDate and r.nPayPeriod = @PayPeriodType)

update tPunchDate set bLocked=@Lock from  tpunchdate p inner join treportweek r on p.nweekid = r.nweekid 
where r.nPayPeriod = @PayPeriodType and DTPunchDate <= @ToDate and bLocked = 0
GO
