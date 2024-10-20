USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_tblUserCompensationRules]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 3/15/2021
-- Description:	Returns the compensation rule at the selected date
-- =============================================
CREATE FUNCTION [dbo].[fnComp_tblUserCompensationRules]
(
	@SearchDate date,
	@USERID int,
	@ACCRUALTYPE nvarchar(50)
)
RETURNS 
@UserCompensationRules TABLE 
(
	[nUserID] [int] NOT NULL,
	[sAccrualType] [nvarchar](30) NOT NULL,
	[nCompRulesID] [int] NULL,
	[dblAccrualDailyHours] [decimal](18, 5) NULL,
	[dStartOfRuleDate] [datetime] NOT NULL
)
AS
BEGIN
INSERT @UserCompensationRules 
SELECT ucr.[nUserID]
      ,ucr.[sAccrualType]
      ,ucr.[nCompRulesID]
      ,ucr.[dblAccrualDailyHours]
      ,ucr.[dStartOfRuleDate]
  FROM [dbo].[tUserCompensationRules] UCR
  INNER JOIN
(  
SELECT [nUserID]
      ,[sAccrualType]
      ,max([dStartOfRuleDate]) as dStartOfRuleDate
  FROM [dbo].[tUserCompensationRules] 
  WHERE (nUserID =@USERID OR @USERID = 0) and 
  (sAccrualType = @ACCRUALTYPE OR @ACCRUALTYPE = '') 
  AND dStartOfRuleDate <= @SearchDate
  group by nUserID, sAccrualType
  ) d
  ON UCR.nUserID = d.nUserID and UCR.sAccrualType = d.sAccrualType and UCR.dStartOfRuleDate = d.dStartOfRuleDate 
	RETURN 
END
GO
