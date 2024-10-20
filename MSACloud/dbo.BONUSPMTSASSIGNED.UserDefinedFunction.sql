USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[BONUSPMTSASSIGNED]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BONUSPMTSASSIGNED]
(
	@CLIENTID bigint,
	@CUSTID int,
	@BEGINDATE datetime,
	@ENDDATE datetime
)
RETURNS TABLE
AS
RETURN
(
   SELECT ISNULL(SUM(BonusPaid),0.0) AS BONUS FROM BonusPayments
      WHERE BonusDate >= @BEGINDATE
         AND BonusDate < @ENDDATE
            AND Order_Id IS NULL
               AND Customer_Id = @CUSTID
				AND ClientID = @CLIENTID
)
GO
