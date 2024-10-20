USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_CustomerRosterSummary]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid H
-- Create date: 03/21/2016
--select * from Reporting_CustomerRosterSummary(44,'','','','','',2,2,'ALL','ALL',-10000.0,10000.0,-10000.0,10000.0,0,'1/1/1900','1/1/1900',0,NULL,1,'1/1/1900')
-- =============================================
CREATE FUNCTION [dbo].[Reporting_CustomerRosterSummary] 
(	
	@ClientID bigint,
	@CUSTLIST varchar(2048) = '',
	@SCHLIST varchar(2048) = '',
	@GRLIST varchar(2048) = '',
	@HRLIST varchar(2048) = '',
	@LTLIST varchar(2048) = '',
	@ACTIVETYPE int = 2,	-- ActiveType: 0-InActive,1-Active,2-All
	@DELETEDTYPE int = 2,	-- DeletedType: 0-NotDeleted,1-Deleted,2-All
	@ZEROBALANCES  varchar(200) = 'ALL',
	@ACCOUNTTYPE varchar(200) = 'ALL',
	
	@RangeStart float = 0,
	@RangeEnd float = 99999,
	@GreaterThan float = 0,
	@LessThan float = 99999,


	@DOCREATEDATE bit = 0,
	@CREATEDATEBEGIN datetime = '1/1/1900',
	@CREATEDATEEND datetime = '1/1/1900',
	@CREATETYPE int = 0,
	@BALCALCENDDATE datetime = NULL,
	@INCLUDEBALS bit = 1,
	@StartDate datetime  = '1/1/1900'

)
RETURNS TABLE 
AS
RETURN 
(

SELECT
    cr.CSTID, 
	cr.SCHID, 
	cr.DISTID, 
	cr.DistrictName, 
	cr.SchoolName,
    cr.SchoolAddress1,
	cr.SchoolAddress2,
	cr.SchoolCity,
	cr.SchoolState,
	cr.SchoolZip,
	CASE cr.isStudent 
		WHEN 1 THEN 'To the Parent(s)/Guardian(s) of:' 
		ELSE '' 
	END as Greeting, 
	cr.LastName, 
	cr.FirstName, 
	cr.Middle, 
	cr.UserID,  
	cr.Address1,
	cr.Address2,
	cr.City,
	cr.State,
	cr.zip,
	cr.Grade, 
	cr.Homeroom, 
	cr.EMail, 
	0 as EMailSent, 
	ISNULL(SUM((ca.adebit + ca.mdebit) - (ca.acredit + ca.mcredit + ca.bcredit)),0.0) as BeginningBalance,
	cr.isActive,
	cr.isDeleted,
	cr.LunchType,
	case
    when (cr.AllowAlaCarte = 0 OR cr.CashOnly = 1) then 1
    else 0
    end as isFrozen,
	ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance,0) + ISNULL(sb.BonusBalance,0) as balanceSum,
	upper(lastname) +', ' + upper(firstname) as lastfirst

FROM CustomerRoster cr 
	LEFT OUTER JOIN CustomerBalances(@ClientID, @CUSTLIST, @SCHLIST, @GRLIST, @HRLIST, @LTLIST, @ACTIVETYPE, @DELETEDTYPE, @DOCREATEDATE, @CREATEDATEBEGIN, @CREATEDATEEND, @CREATETYPE, @BALCALCENDDATE, @INCLUDEBALS) sb ON (sb.Customer_Id = cr.CSTID) 
	LEFT OUTER JOIN CustomerActivity ca ON ((ca.ClientID = @ClientID) AND (ca.Customer_Id = cr.CSTID) AND ((ca.GDate < @StartDate) 
	                        OR (ca.TransType = 1700)
   					) AND ((ca.isVoid = 0) OR (ca.TransType = 1500))) 
     WHERE 
	 -----
	 --Zero Balaces check
	 (
	 (cr.LunchType <> 3) AND (ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance,0) + ISNULL(sb.BonusBalance,0) <> 0) AND (@ZEROBALANCES  = 'ALLEXCEPTFREEWITHZEROBALANCES')
	 OR
	 (ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance,0) + ISNULL(sb.BonusBalance,0) <> 0) AND (@ZEROBALANCES  = 'ALLEXCEPTZEROBALANCES')
	 OR
	 (@ZEROBALANCES = 'ALL')
	 )
	 ---------
	 --Account Type Check
	 AND
	 ( 
		(@ACCOUNTTYPE = 'Positive' AND ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance, 0) > 0) OR --
		(@ACCOUNTTYPE = 'Negative' AND ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance, 0) + ISNULL(sb.BonusBalance,0) < 0)  OR
		(@ACCOUNTTYPE = 'Both')  OR
		(@ACCOUNTTYPE = 'Range' AND ISNULL(sb.ABalance,0) + ISNULL(sb.MBalance, 0) + ISNULL(sb.BonusBalance , 0) >= @RangeStart AND ISNULL(sb.ABalance, 0) + ISNULL(sb.MBalance,0) + ISNULL(sb.BonusBalance,0) <= @RangeEnd)  OR
		(@ACCOUNTTYPE = 'GreaterThan' AND ISNULL(sb.ABalance, 0) + ISNULL(sb.MBalance,0) + ISNULL(sb.BonusBalance, 0) > @GreaterThan)  OR
		(@ACCOUNTTYPE = 'LessThan' AND ISNULL(sb.ABalance, 0) + ISNULL(sb.MBalance, 0) + ISNULL(sb.BonusBalance, 0) < @LessThan)  OR
		(@ACCOUNTTYPE = 'ALL')
	 )
	 ------

	 AND cr.CSTID in (SELECT cust.CSTID FROM CustomerRoster cust WHERE (
	 ------------------
	 cust.ClientID = @ClientID 
	 AND ((cust.CSTID IN (SELECT Value FROM Reporting_fn_Split(@CUSTLIST, ',')) AND @CUSTLIST <> '') OR  (@CUSTLIST = ''))
	 AND ((cust.SCHID IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ',')) AND @SCHLIST <> '') OR  (@SCHLIST = ''))
	 AND ((cust.GRID IN (SELECT Value FROM Reporting_fn_Split(@GRLIST, ',')) AND @GRLIST <> '') OR  (@GRLIST = ''))
	 AND ((cust.HRID IN (SELECT Value FROM Reporting_fn_Split(@HRLIST, ',')) AND @HRLIST <> '') OR  (@HRLIST = ''))
	 AND (cust.isActive = @ACTIVETYPE and (@ACTIVETYPE <> 2 ) OR (@ACTIVETYPE = 2))
	 AND (cust.isDeleted = @DELETEDTYPE and (@DELETEDTYPE <> 2 ) OR (@DELETEDTYPE = 2))
	 

	 -------------
	
	 )) 

     GROUP BY 
              cr.CSTID, 
              cr.SCHID, 
              cr.DISTID, 
              cr.DistrictName,
              cr.SchoolName,
              cr.SchoolAddress1,
			  cr.SchoolAddress2,
			  cr.SchoolCity,
			  cr.SchoolState,
  			  cr.SchoolZip,
              CASE cr.isStudent
                 WHEN 1 THEN 'To the Parent(s)/Guardian(s) of:' 
                 ELSE '' 
               END,
               cr.LastName,
               cr.FirstName, 
               cr.Middle, 
               cr.UserID,
			   cr.Address1,
			   cr.Address2,
			   cr.City,
	           cr.State,
	           cr.zip,
               cr.Grade, 
               cr.Homeroom, 
               cr.EMail,
			   cr.isActive,
				cr.isDeleted,
				cr.LunchType,
				isFrozen,
				cr.AllowAlaCarte ,
				cr.CashOnly,
				sb.ABalance,
				sb.MBalance, 
				sb.BonusBalance
				
)
GO
