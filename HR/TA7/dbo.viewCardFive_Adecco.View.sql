USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewCardFive_Adecco]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewCardFive_Adecco]
AS
SELECT TOP 100  id, SUBSTRING(tuser.name,1, (SELECT PATINDEX('%,%', tuser.name))-1) AS LastName,LTRIM(SUBSTRING(tuser.name,(SELECT PATINDEX('%,%', tuser.name))+1,100)) AS FirstName, objPhoto as Photo  FROM tuser 
WHERE     (dbo.tuser.nPayrollRuleID = 127) OR
                      (dbo.tuser.nPayrollRuleID = 130) AND (dbo.tuser.nStatus >= 0) AND (SELECT PATINDEX('%,%', tuser.name))>0
ORDER BY dbo.tuser.name
GO
