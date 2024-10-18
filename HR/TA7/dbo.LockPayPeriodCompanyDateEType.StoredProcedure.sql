USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[LockPayPeriodCompanyDateEType]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LockPayPeriodCompanyDateEType] 
@Company as nvarchar(50),
@ETypeID as int,
@PeriodDate as datetime,
@PayPeriodType as datetime,
@Lock as bit
AS
update tPunchDate set bLocked=@Lock
from tpunchdate p inner join treportweek r on p.nweekid = r.nweekid 
inner join tuser u on r.e_id = u.id
where r.DTStartDate <= @PeriodDate and r.DTEndDate >= @PeriodDate and u.sNotes = @Company  and r.nPayPeriod = @PayPeriodType and r.nEmployeeType=@ETypeID
GO
