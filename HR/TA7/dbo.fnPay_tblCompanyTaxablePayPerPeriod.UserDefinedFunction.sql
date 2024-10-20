USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyTaxablePayPerPeriod]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 06/21/2019
-- Description:	Company Contribution Taxable pay for SUTA, others
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCompanyTaxablePayPerPeriod]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date,
	@WithholdingName nvarchar(50)
)
RETURNS @tblUserTaxablePayPerPeriod TABLE 
(
	intUserID int,
	strUserName nvarchar(50),
	strWithholdingName	nvarchar(50), 
	decPayLimit  decimal(18,2),
	strSSN nvarchar(50), 
	decPeriodPay decimal(18,2),
	decPreviousPay decimal(18,2),
	decEndPay decimal(18,2),
	decTaxablePay decimal(18,2),
	bitWithholdingApplies bit
)
-- WITH ENCRYPTION
AS
BEGIN


DECLARE @Paylimit decimal(18,5)

SELECT @Paylimit = decMaximumSalaryLimit from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName
if @Paylimit = 0 SET @Paylimit = 10000000.00

INSERT INTO @tblUserTaxablePayPerPeriod
select intuserid UserID, max(strUserName) UserName, @WithholdingName, @Paylimit PayLimit,
max(sSSN) SSN,
sum( [dbo].[fnPay_BatchTaxablePay](strBatchID, intUserID)) PeriodPay ,


iif(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay](@PayrollCompany,intUserID, dateadd(day,datediff(day,1,@STARTDATE),0) )) PreviousPay ,


isnull([dbo].[fnPay_YTDUserTaxablePay](@PayrollCompany,intUserID, @ENDDATE ),0) EndPay ,

--Check that employee qualifies for the Withholding.  Must have the deduction in that time period, otherwise TaxablePay = 0
CASE 
	WHEN ((select decCompanyPercent from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName AND intuserid = u.intuserid) <> 0) THEN
		CASE  WHEN IIF(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay](@PayrollCompany,intUserID, dateadd(day,datediff(day,1,@STARTDATE),0) )) > @Paylimit THEN '0.00'
		  ELSE
			CASE 
				WHEN isnull([dbo].[fnPay_YTDUserTaxablePay](@PayrollCompany,intUserID, @ENDDATE ),0) <= @Paylimit THEN   sum( [dbo].[fnPay_BatchTaxablePay](strBatchID, intUserID)) --All taxable pay counts
				ELSE  @paylimit - IIF(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay](@PayrollCompany,intUserID, dateadd(day,datediff(day,1,@STARTDATE),0) ))
			END
		END 
	ELSE
		 0.00
END as TaxablePay,

iif((select decCompanyPercent from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName AND intuserid = u.intuserid) <> 0, 1,0) bitWithholdingApplies


	--All Employees
	FROM viewpay_UserBatchStatus u where strCompanyName = @PayrollCompany 
	and dtpaydate between @STARTDATE AND @ENDDATE

 group by intUserID
RETURN
END

GO
