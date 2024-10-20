USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[CashCounted]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CashCounted]
(
	@ClientID bigint,
	@STARTDATE datetime,
	@ENDDATE datetime,
	@SCHLIST varchar(2048) = '',
	@CASHIERID int = -1
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @RESULT float 
	SET @RESULT = 0.0
 
	SELECT
		@RESULT = SUM(cr.CloseAmount - cr.OpenAmount) 
		/*
		-1 as id, 
		(0.0) as TotalPmnt, (0.0) as AcPmnt, (0.0) as CreditPmnt, (0.0) as CsPmnt, 
		sum(cr.closeamount - cr.openamount) as CashCounted, 
		sum(cr.closeamount - cr.openamount) as Total 
		*/
	FROM  CashResults cr
		LEFT OUTER JOIN POS P ON cr.POS_Id = P.Id AND cr.ClientID = P.ClientID
	WHERE cr.ClientID = @ClientID 
		AND (cr.Finished = 1)
		AND (cr.OpenDate >= @STARTDATE) AND (cr.OpenDate <= @ENDDATE)
		AND ((@CASHIERID = -1) OR (cr.Emp_Cashier_Id = @CASHIERID))
		AND ((LEN(@SCHLIST) = 0) OR
				(
					(PATINDEX('(' + CAST(p.School_Id as varchar) + ',%', @SCHLIST) > 0) AND
					(PATINDEX('%,' + CAST(p.School_Id as varchar) + ',%', @SCHLIST) > 0) AND
					(PATINDEX('(' + CAST(p.School_Id as varchar) + ')', @SCHLIST) > 0) AND
					(PATINDEX('%,' + CAST(p.School_Id as varchar) + ')', @SCHLIST) > 0)
				)
			)

	-- Return the result of the function
	RETURN ROUND(ISNULL(@RESULT,0.0),2)

END
GO
