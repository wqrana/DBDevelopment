USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollCompanyPositions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblPayrollCompanyPositions]
(
	@PayrollCompany as nvarchar(50)
)
RETURNS @tblPosition TABLE 
(
intPositionID  int, 
strPositionName nvarchar(50)
)
AS
BEGIN

	--Use the Batch End Date to know YTD
	INSERT INTO @tblPosition
	SELECT intPositionID, strPositionName from tblPosition where intCompanyID in (
		select nCompanyID from tblCompanyPayrollRules cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID
		where strPayrollCompany = @PayrollCompany) ORDER BY strPositionName ASC
	RETURN
END

GO
