USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewCardFive_Edwards]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewCardFive_Edwards]
AS
SELECT     TOP 100 PERCENT id, SUBSTRING(name, 1,
                          (SELECT     PATINDEX('%,%', tuser.name)) - 1) AS LastName, LTRIM(SUBSTRING(name,
                          (SELECT     PATINDEX('%,%', tuser.name)) + 1, 100)) AS FirstName, objPhoto AS Photo
FROM         dbo.tuser
WHERE     (nPayrollRuleID <= 125) AND (nPayrollRuleID > 0) AND (nStatus >= 0)
ORDER BY name
GO
