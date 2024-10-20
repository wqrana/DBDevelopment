USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTA_DELETE_PayCyclePeriod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 08/02/2019
-- Description:	Closes a PayCyclePeriod
-- =============================================
CREATE PROCEDURE [dbo].[spTA_DELETE_PayCyclePeriod]
	@PAYWEEKNUM INT,
	@PAYROLLSCHEDULEID INT
-- WITH ENCRYPTION
AS

BEGIN
		DECLARE @PayCycleStatus  as nvarchar(50)

	--Get the paycycle status
		SELECT @PayCycleStatus = sStatus from tblPayCycleLog 
		WHERE  nPayWeekNum = @PAYWEEKNUM AND  [intPayrollScheduleID] = @PAYROLLSCHEDULEID
		if NOT @PayCycleStatus IS NULL
		BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	
	 --   -- DELETE copy of tPunchDatePayCycle
		--DELETE	pdt	FROM tPunchDatePayCycle pdt inner join tReportWeekPayCycle rw on pdt.nPayWeekNum = rw.nPayWeekNum and pdt.e_id = rw.e_id
		--WHERE  rw.[nPayWeekNum] = @PAYWEEKNUM AND rw.[nCompID] = @COMPANYID AND (rw.ndept = @DEPTID OR @DEPTID = 0) AND (rw.[nJobTitleID] = @SUBDEPTID OR @SUBDEPTID =0) AND (rw.[nEmployeeType] = @EMPLOYEETYPEID OR @EMPLOYEETYPEID = 0)

	 --   -- DELETE copy of tPunchDateDetail to tPunchDateDetailPayCycle
		--DELETE pdd		FROM tPunchDateDetailPayCycle pdd inner join tReportWeekPayCycle rw on pdd.nPayWeekNum = rw.nPayWeekNum and pdd.e_id = rw.e_id
		--WHERE  rw.[nPayWeekNum] = @PAYWEEKNUM AND rw.[nCompID] = @COMPANYID AND (rw.ndept = @DEPTID OR @DEPTID = 0) AND (rw.[nJobTitleID] = @SUBDEPTID OR @SUBDEPTID =0) AND (rw.[nEmployeeType] = @EMPLOYEETYPEID OR @EMPLOYEETYPEID = 0)
		
	 --   -- CREATE copy of tRportWeek to tReportWeekPaycycle
		--DELETE 		FROM tReportWeekPayCycle
		--WHERE  [nPayWeekNum] = @PAYWEEKNUM AND [nCompID] = @COMPANYID AND (ndept = @DEPTID OR @DEPTID = 0) AND ([nJobTitleID] = @SUBDEPTID OR @SUBDEPTID =0) AND ([nEmployeeType] = @EMPLOYEETYPEID OR @EMPLOYEETYPEID = 0)

		--  PayCycleLog Entry
		DELETE tblPayCycleLog 
		WHERE  nPayWeekNum = @PAYWEEKNUM AND  [intPayrollScheduleID] = @PAYROLLSCHEDULEID

		COMMIT
	END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
	END
	ELSE
		BEGIN;
		THROW 100000, 'PayCycle does not exist.',1
		END
END


GO
