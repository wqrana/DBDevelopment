USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[BONUSPMTSONORDER]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BONUSPMTSONORDER]
(
	@CLIENTID bigint,
   @FMYORDERID int
)
RETURNS TABLE
AS
RETURN
(
   SELECT ISNULL(SUM(BONUSPAID), 0.0) AS BONUS
      FROM BONUSPAYMENTS
         WHERE ORDER_ID = @FMYORDERID
			AND ClientID = @CLIENTID
)
GO
