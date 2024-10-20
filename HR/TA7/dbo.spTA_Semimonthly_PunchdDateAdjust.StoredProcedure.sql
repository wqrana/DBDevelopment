USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTA_Semimonthly_PunchdDateAdjust]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 4/9/2017
-- Description:	Adjusts the REGULAR HOURS in tPunchDate and tPunchDateDetail according to the Semimonthly computations
-- =============================================
CREATE PROCEDURE [dbo].[spTA_Semimonthly_PunchdDateAdjust]
(	@UserID int)
-- WITH ENCRYPTION
AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		--Update the employee's tPunchDateDetail hours according to those computed in tblPayCycleDailyDetail
		UPDATE tPunchDateDetail SET dblHours = pcp.dblHours from tPunchDateDetail pdd inner join tblPayCycleDailyDetail pcp on pdd.e_id = pcp.e_id and pdd.DTPunchDate = pcp.DTPunchDate and pdd.sType = pcp.sType
		where pdd.dblHours <> pcp.dblHours AND pdd.e_id = @UserID
	
		--Update the employee's tPunchDate Regular Hours according to those computed in tblPayCycleDailyDetail
		UPDATE tPunchDate SET dblREGULAR = pcp.dblHours from tPunchDate pdd inner join tblPayCycleDailyDetail pcp on pdd.e_id = pcp.e_id and pdd.DTPunchDate = pcp.DTPunchDate 
		where pdd.dblREGULAR <> pcp.dblHours AND pdd.e_id = @UserID

		COMMIT
	END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
END
GO
