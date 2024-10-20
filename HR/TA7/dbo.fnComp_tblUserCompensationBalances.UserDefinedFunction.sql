USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_tblUserCompensationBalances]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 3/15/2021
-- Description:	Returns the compensation rule at the selected date
-- =============================================
CREATE FUNCTION [dbo].[fnComp_tblUserCompensationBalances]
(
		@SEARCHDATE date,
		@USERID int = 0,
		@ACCRUALTYPE nvarchar(50)
)
RETURNS 
	@tUserCompensationBalances TABLE 
(
	[nUserID] [int] NOT NULL,
	[sAccrualType] [nvarchar](30) NOT NULL,
	[dblAccruedHours] [decimal](18, 5) NULL,
	[dBalanceStartDate] [datetime] NOT NULL,
	[dblAccrualDailyHours] [decimal](18, 5) NULL,
	[sAccrualDays] [nvarchar](50) NULL,
	[nSuperID] [int] NULL,
	[dtModifiedDate] [smalldatetime] NULL
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
INSERT @tUserCompensationBalances
SELECT 	UCB.[nUserID] ,
	UCB.[sAccrualType],
	[dblAccruedHours] ,
	UCB.[dBalanceStartDate] ,
	[dblAccrualDailyHours] ,
	[sAccrualDays] ,
	[nSuperID] ,
	[dtModifiedDate] 
  FROM [dbo].[tUserCompensationBalances] UCB
  INNER JOIN
(  
SELECT [nUserID]
      ,[sAccrualType]
      ,max([dBalanceStartDate]) as dBalanceStartDate
  FROM [dbo].[tUserCompensationBalances] 
  WHERE (nUserID =@USERID OR @USERID = 0) and 
  (sAccrualType = @ACCRUALTYPE OR @ACCRUALTYPE = '') 
  AND dBalanceStartDate <= @SearchDate
  group by nUserID, sAccrualType
  ) d
  ON ucb.nUserID = d.nUserID and ucb.sAccrualType = d.sAccrualType and ucb.dBalanceStartDate = d.dBalanceStartDate 


	RETURN 
END
GO
