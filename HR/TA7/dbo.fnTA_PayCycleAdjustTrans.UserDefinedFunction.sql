USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnTA_PayCycleAdjustTrans]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 8/14/2019
-- Description:	Returns the name of equivalent ADJUST transaction if any
--				41 - Any Transaction Pay Rate
--				42 - ADJUST VACATION
--				43 - ADJSUT SICK
-- =============================================

CREATE FUNCTION [dbo].[fnTA_PayCycleAdjustTrans]
(
	@USERID int,
	@TRANSNAME nvarchar(50)
)
RETURNS nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
	-- Declare the return variable here
	DECLARE @FOUND_TRANS nvarchar(50) 
	DECLARE @ADJUST_TRANS nvarchar(50) 

	--CHECK IF THIS TRANSACTION IS IN tblUserTransactionPayRates
		select @FOUND_TRANS= sTransName from tblUserTransactionPayRates utp where nUserID = @USERID AND sTransName = @TRANSNAME
		if NOT @FOUND_TRANS IS NULL
			select @ADJUST_TRANS = Name from tTransDef where nParentCode = 41 --Transaction in TransPayRates = 41
		ELSE
		BEGIN
		IF (select count(*) from ttransdef where sAccrualImportName = 'SA' and name = @TRANSNAME) >0
			select @ADJUST_TRANS = Name from tTransDef where nParentCode = 43 --SICK = 43 
		ELSE IF (select count(*) from ttransdef where sAccrualImportName = 'VA' and name = @TRANSNAME) > 0
			select @ADJUST_TRANS = Name from tTransDef where nParentCode = 42 --VAC = 42
	--IF THE TRANS WAS NOT IN PAYRATES OR ASSIGNED AS VA OR SA
	IF @ADJUST_TRANS IS NULL
	BEGIN
		SELECT top(1) @ADJUST_TRANS = td2.name from tTransdef td inner join
		(select Name, decPayRateMultiplier from tTransDef where (nIsMoneyTrans =1 OR nPayRateTransaction = 1) And nParentCode  IN (35,36,37,38)) td2 ON td.decPayRateMultiplier = td2.decPayRateMultiplier
		where td.name = @TRANSNAME
		END
	if @ADJUST_TRANS is null set @ADJUST_TRANS  = ''
	END
	-- Return the result of the function
	RETURN @ADJUST_TRANS
	END

GO
