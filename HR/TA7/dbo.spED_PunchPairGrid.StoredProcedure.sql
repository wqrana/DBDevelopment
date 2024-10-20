USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_PunchPairGrid]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spED_PunchPairGrid]
AS 
BEGIN
 
DECLARE @COMPANYID int  = 1
DECLARE @STARTDATE date = '1/1/2023'
DECLARE @ENDDATE  date = '3/31/2023'
DECLARE @pvtColSet1 AS NVARCHAR(MAX), @sqlQuery AS NVARCHAR(MAX)

--Select  c.Name Company, e_id as UserID, u.name, sType, HoursWorked  
--From tPunchPair  pp inner join tuser U on pp.e_id = u.id 
--Inner join tCompany C on u.nCompanyID = c.ID
--Where u.nCompanyID = @COMPANYID
--and DTPunchDate BETWEEN @STARTDATE and @ENDDA

--PunchPair pair data 
	SET @pvtColSet1 = STUFF(
		(SELECT ',' +CONCAT('[',sType,']') FROM tPunchPair WHERE sType is not null and trim(sType)<>'' GROUP BY sType FOR XML PATH('')),
		1, 1, '');

SET @sqlQuery = N'
	  SELECT *	  
	  FROM(
		SELECT *	
		FROM (
				Select  c.Name Company, e_id as UserID, u.name, sType, HoursWorked  
				From tPunchPair  pp inner join tuser U on pp.e_id = u.id 
				Inner join tCompany C on u.nCompanyID = c.ID
				Where u.nCompanyID ='+ convert(nvarchar,@COMPANYID) + '
				And DTPunchDate BETWEEN '''+ CONVERT(varchar,@STARTDATE,101)+''' AND '''+ CONVERT(varchar,@ENDDATE,101)+'''
							
		) BalanceData   
		 PIVOT (
			SUM([HoursWorked])
			FOR [sType] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblBalances'

  -- Select @sqlQuery
   Exec sp_executesql @sqlQuery
END
GO
