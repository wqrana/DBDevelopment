USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Report_CustomerSummary]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_CustomerSummary]
(
    @clientid int = null
	, @selectedcustomers varchar(2048) = null
	, @selectedschools varchar(2048) = NULL
	, @selectedhomerooms varchar(2048) = null
	, @selectedgrades varchar(2048) = null
	, @activetype int = 2 -- 0=InActive, 1=Active, 2=No Filter
	, @selectedlunchtypes varchar(2048) = null
	, @deletedtype int = 2
)
AS
BEGIN
	--set @clientid = 9
	--set @selectedcustomers = null
	--set @selectedschools = '(6)'
	--set @selectedhomerooms = null
	--set @selectedgrades = null
	--set @activetype = 2 -- 0=InActive, 1=Active, 2=No Filter
	--set @selectedlunchtypes = null
	--set @deletedtype = 2
    IF (OBJECT_ID('tempdb..#tmpCustomerSummaryReport') IS NOT NULL) DROP TABLE #tmpCustomerSummaryReport 

	CREATE TABLE #tmpCustomerSummaryReport (Customer_Id INTEGER, ABalance FLOAT, MBalance FLOAT, BonusBalance FLOAT, Balance FLOAT) 

	INSERT INTO #tmpCustomerSummaryReport 

	SELECT 
		Customer_Id
		, ABalance
		, MBalance 
		, BonusBalance
		, Balance
	FROM dbo.CustomerBalances_V2(@clientid, @selectedcustomers, @selectedschools
		, @selectedgrades, @selectedhomerooms, @selectedlunchtypes
		, @activetype, @deletedtype, NULL
		, NULL, NULL, NULL
		, 1) 


	--Main query
	SELECT
		sb.ABalance, sb.MBalance, sb.BonusBalance, sb.Balance, sb.BonusBalance AS BBalance, sb.Balance AS TotalBalance 
		, cr.*,  
		case
		  when cr.Address2 IS NULL or cr.Address2 = '' then '' +
			case
				when RTRIM(cr.Middle) IS NULL or RTRIM(cr.Middle) = '' then UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')))
				else UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')) + ' ' + RTRIM(ISNULL(cr.Middle, '')) + '.') 
			end
				+ '' + UPPER(RTRIM(ISNULL(cr.Address1, '')) + '' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' + 
			CASE 
				WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5) 
				ELSE RTRIM(ISNULL(cr.zip, '')) 
			END)  
		  else '' 
		  +  case
			  when RTRIM(cr.Middle) IS NULL or RTRIM(cr.Middle) = '' then UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')))    
			  else UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')) + ' ' + RTRIM(ISNULL(cr.Middle, '')) + '.') 
			 end
		  + '' + UPPER(RTRIM(ISNULL(cr.Address1, '')) + '' + RTRIM(ISNULL(cr.Address2, '')) + '' + RTRIM(ISNULL(cr.city, '')) + ', ' + RTRIM(ISNULL(cr.state, '')) + '  ' + 

			CASE 
				WHEN LEN(RTRIM(ISNULL(cr.zip, ''))) = 6 THEN SUBSTRING(RTRIM(ISNULL(cr.zip, '')), 1, 5) 
				ELSE RTRIM(ISNULL(cr.zip, '')) 
			END) 
		end AS CustomerNameAddress,   

		case
			when RTRIM(cr.Middle) IS NULL or RTRIM(cr.Middle) = '' then UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')))    
			else UPPER(RTRIM(ISNULL(cr.LastName, '')) + ', ' + RTRIM(ISNULL(cr.FirstName, '')) + ' ' + RTRIM(ISNULL(cr.Middle, '')) + '.') 
		end AS CustomerName,   

		'' as [break] ,  
		'Balance' AS BalField, 

		--sb.ABalance, sb.MBalance, sb.BonusBalance AS BBalance, sb.Balance AS TotalBalance, 

		CASE 
			WHEN isnull(sb.Balance, 0.0) < 0.0 THEN 1 
			ELSE 0 
		END AS TotalNegativeBal, 

		CASE 
			WHEN isnull(sb.Balance, 0.0) > 0.0 THEN 1 
			ELSE 0 
		END AS TotalPositiveBal, 

		CASE 
			WHEN isnull(sb.Balance, 0.0) = 0.0 THEN 1 
			ELSE 0 
		END AS TotalZeroBal 
		--into ReportBalanceSummary
		FROM CustomerRoster cr 
		LEFT OUTER JOIN #tmpCustomerSummaryReport sb ON sb.Customer_Id = cr.CSTID 

		WHERE (1 = 1) 
	--and GraduationDate is not null
		and (ABalance is not null)
		and (MBalance is not null)
	order by 
		CustomerName,
		GraduationDate
	--Drop temp table

	IF (OBJECT_ID('tempdb..#tmpCustomerSummaryReport') IS NOT NULL) DROP TABLE #tmpCustomerSummaryReport 
END
GO
