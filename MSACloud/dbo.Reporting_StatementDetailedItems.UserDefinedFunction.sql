USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_StatementDetailedItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abid H
-- Create date: 03/22/2016
-- =============================================
CREATE FUNCTION [dbo].[Reporting_StatementDetailedItems] 
(	
	@ClientID bigint,
		@CUSTLIST varchar(2048) = '',
	@SCHLIST varchar(2048) = '',
	@GRLIST varchar(2048) = '',
	@HRLIST varchar(2048) = '',
	@ACTIVETYPE int = 2,	-- ActiveType: 0-InActive,1-Active,2-All
	@DELETEDTYPE int = 2,	-- DeletedType: 0-NotDeleted,1-Deleted,2-All

	@StartDate datetime = '1/1/1900',
	@EndDate datetime  = '1/1/2050'
)

RETURNS TABLE 
AS
RETURN 
(
SELECT 
    sdi.CSTID, 
    sdi.SCHID, 
    sdi.GDate, 
    sdi.ORDID, 
    sdi.OrderType, 
    sdi.OrderTypeName, 
    sdi.ItemName, 
    sdi.PaidPrice, 
    sdi.Qty, 
    sdi.ExtendedPrice 
FROM StatementDetailItems sdi 
WHERE (sdi.OrderDate BETWEEN @StartDate AND @EndDate) AND 
            (sdi.ClientID = @ClientID) AND 
	sdi.CSTID in (SELECT cust.CSTID FROM CustomerRoster cust WHERE (

	

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
)
GO
