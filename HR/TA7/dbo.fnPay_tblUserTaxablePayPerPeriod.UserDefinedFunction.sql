USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserTaxablePayPerPeriod]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/19/2019
-- Description:	Returns the Taxable Pay Per Time Period
--				 Takes into account the maximum pay for each withholding for SINOT, Choferil
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblUserTaxablePayPerPeriod]
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

--Check for WH that is configured as disability/SINOT
if @WithholdingName = 'SINOT'
BEGIN
	select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,'') from tblWithholdingsItems wi inner join tblWithholdingsItems_PRPayExport prp on wi.strWithHoldingsName = prp.strWithholdingsName
	where prp.boolDisability = 1
	--If none is configured, try the defaults
	iF @WithholdingName = ''
		select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,'')  from tblWithholdingsItems wi where strWithHoldingsName = 'SINOT'
	iF @WithholdingName = ''
		select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,'')  from tblWithholdingsItems wi where strWithHoldingsName = 'DISABILITY'
END
DECLARE @Paylimit decimal(18,5)

SELECT @Paylimit = decMaximumSalaryLimit from tblCompanyWithholdings where strWithHoldingsName = @WithholdingName and strCompanyName = @PAYROLLCOMPANY
if @Paylimit = 0 SET @Paylimit = 10000000.00

INSERT INTO @tblUserTaxablePayPerPeriod
select left(replace(sSSN,'-',''),9) as  UserID, 

max(strUserName) UserName, @WithholdingName, @Paylimit PayLimit,

sSSN SSN,

sum( [dbo].[fnPay_BatchTaxablePay_SSN](strBatchID, sSSN )) PeriodPay ,

iif(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay_SSN](@PayrollCompany,sSSN, dateadd(day,datediff(day,1,@STARTDATE),0) )) PreviousPay ,

isnull([dbo].[fnPay_YTDUserTaxablePay_SSN](@PayrollCompany,sSSN, @ENDDATE ),0) EndPay ,

----Check that employee qualifies for the Withholding.
CASE 
	WHEN (select decCompanyPercent from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName AND intuserid = max(u.intuserid))<> 0 THEN
		CASE  WHEN IIF(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay_SSN](@PayrollCompany,sSSN, dateadd(day,datediff(day,1,@STARTDATE),0) )) > @Paylimit THEN '0.00'
		  ELSE
			CASE 
				WHEN isnull([dbo].[fnPay_YTDUserTaxablePay_SSN](@PayrollCompany,sSSN, @ENDDATE ),0) <= @Paylimit THEN   sum( [dbo].[fnPay_BatchTaxablePay_SSN](strBatchID, sSSN)) --All taxable pay counts
				ELSE  @paylimit - IIF(FORMAT (@STARTDATE,'MMdd') = '0101',0,[dbo].[fnPay_YTDUserTaxablePay_SSN](@PayrollCompany,sSSN, dateadd(day,datediff(day,1,@STARTDATE),0) ))
			END
		END 
	ELSE
		 0.00
END 
as TaxablePay,

iif((select decCompanyPercent from tblUserWithholdingsItems where strWithHoldingsName = @WithholdingName AND intuserid = max(u.intuserid)) <> 0, 1,0)  bitWithholdingApplies

 	
	--All Employees
	FROM viewpay_UserBatchStatus u where strCompanyName = @PayrollCompany 
	and dtpaydate between @STARTDATE AND @ENDDATE
	and decBatchUserCompensations <> 0
 group by sSSN
RETURN
END


GO
