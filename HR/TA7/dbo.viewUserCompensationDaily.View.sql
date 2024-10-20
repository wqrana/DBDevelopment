USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewUserCompensationDaily]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewUserCompensationDaily]
AS
select distinct  u.id as nUserID, c.TheDate as dEffectiveDate, ucr.sAccrualType, ucd.dBalanceStartDate, ucd.dblAccruedHours, ucd.dblAccrualDailyHours, ucd.dblStartBalance, ucd.dblAccruedBalance, ucd.dblTakenBalance, ucd.sAccrualDays 
from tuser u inner join tUserCompensationRules ucr on u.id = ucr.nUserID cross join DateCalendar c cross apply dbo.fnUserCompensationDaily(u.id, c.TheDate, ucr.sAccrualType) ucd  

GO
