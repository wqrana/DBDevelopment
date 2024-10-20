USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewCardFive_CTS]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewCardFive_CTS]
AS
SELECT     TOP 100 PERCENT id, SUBSTRING(name, 1,
                          (SELECT     PATINDEX('%,%', tuser.name)) - 1) AS LastName, LTRIM(SUBSTRING(name,
                          (SELECT     PATINDEX('%,%', tuser.name)) + 1, 100)) AS FirstName, objPhoto AS Photo
FROM         dbo.tuser
WHERE     (dbo.tuser.nPayrollRuleID = 126) OR
                      (dbo.tuser.nPayrollRuleID = 129) AND (dbo.tuser.nStatus >= 0) AND (SELECT PATINDEX('%,%', tuser.name))>0
ORDER BY dbo.tuser.name
GO
