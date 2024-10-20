USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_CompensationBalances]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/5/2020
-- Description:	Returns the accrual balances of the Types in @accrualType
--				Takes into account CompV1 and CompV2
---------------Modification History------------------
-- Author:		Waqar Q
-- Modification date: 8/30/2021
-- Description:	add 'fnComp_RemainingBalance' function to return the remaining balance of the Types in @accrualType
--			
-- =============================================

CREATE PROCEDURE [dbo].[spSS_CompensationBalances]
	@UserID as int,	
	@AccrualType as nvarchar(500),
	@SearchDate as date
AS
BEGIN
	SET NOCOUNT ON;
		--	VALIDATE REQUEST
	BEGIN TRANSACTION;
	SAVE TRANSACTION TransStart;
	BEGIN TRY

	IF (select top(1) nConfigParam from tSoftwareConfiguration where nConfigID = 1055) = 1
	--Compensation V2
		select ar.nUserID UserID, ar.sAccrualType AccrualType, 
		dbo.fnComp_EndOfDayBalance(ar.nUserID,ar.sAccrualType  ,@SearchDate) Balance,
		[dbo].[fnComp_RemainingBalance](ar.nUserID,ar.sAccrualType  ,@SearchDate) RemainingBalance, 
		@SearchDate SearchDate from tUserCompensationRules ar 
		inner join dbo.fn_StringSplit(@AccrualType,',') acc on ar.sAccrualType = acc.Item
		where ar.nUserID = @UserID and sAccrualType IN ('SA','VA')	
	ELSE
	--Compensation V1
		select ar.nUserID UserID, ar.sAccrualType AccrualType,  
		dbo.fnCompensationEndOfDayBalance(@SearchDate,ar.nUserID,ar.sAccrualType ) Balance,
		[dbo].[fnComp_RemainingBalance](ar.nUserID,ar.sAccrualType  ,@SearchDate) RemainingBalance,
		@SearchDate SearchDate from tUserCompensation ar 
		inner join dbo.fn_StringSplit(@AccrualType,',') acc on ar.sAccrualType = acc.Item
		where ar.nUserID = @UserID and sAccrualType IN ('SA','VA')	

	COMMIT TRANSACTION TransStart

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION TransStart;
	END CATCH
	
END
GO
