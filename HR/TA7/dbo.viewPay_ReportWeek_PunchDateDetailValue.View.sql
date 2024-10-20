USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_ReportWeek_PunchDateDetailValue]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW  [dbo].[viewPay_ReportWeek_PunchDateDetailValue] AS SELECT pay.nUserID as UserID, pay.sTransName as TransName, pay.dblHour as TransHours, pay.decHourlyRate as PayRate, pay.decMoneyValue as TransValue,  pdd.nWeekID as PeriodID, pdd.e_id, pdd.DTPunchDate, pdd.dblHours, pdd.sType, rw.e_idno, rw.e_name, rw.sPayRuleName, rw.nPayWeekNum, rw.DTStartDate, rw.DTEndDate, rw.dblREGULAR, rw.dblONEHALF, rw.dblDOUBLE, rw.sHoursSummary,  rw.nDept, rw.sDeptName, rw.nCompID, rw.sCompanyName, rw.nEmployeeType, rw.sEmployeeTypeName, rw.nJobTitleID, rw.sJobTitleName, rw.nPayPeriod,  rw.nReviewStatus, rw.nReviewSupervisorID, rw.sSupervisorName, rw.dblMEAL, rw.dblOTHERS, rw.nLocked,rw.nWeekID, u.nStatus from tPunchDateDetail pdd inner join treportweek rw  on pdd.nWeekID = rw.nWeekID inner join tuser u on pdd.e_id = u.id cross apply ( select * from [dbo].[fnPay_PayTable_DefaultMoneyAmount] ( pdd.e_id,  pdd.stype,pdd.dblHours)  ) as Pay        



GO
