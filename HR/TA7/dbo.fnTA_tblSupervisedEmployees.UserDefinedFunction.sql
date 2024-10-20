USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnTA_tblSupervisedEmployees]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/8/2021
-- Description:	Function that returns the employees that 
--				a supevisor can view.  Unites search and supervisor view.
--				SUPERVISORVIEW = 0 -All, 1 = Search, 2= SupervisorView				
-- =============================================
CREATE FUNCTION [dbo].[fnTA_tblSupervisedEmployees]
(	
	@SupervisorID as int,
	@SUPERVISORVIEW as int
)
RETURNS 
@tblSupervisedEmployees TABLE 
(
	intUserID  int
) 
AS
BEGIN
--        ALLVIEWS = 0
--        SEARCHVIEW = 1
--        SUPERVISORVIEW = 2
IF @SUPERVISORVIEW = 0
BEGIN
	INSERT INTO @tblSupervisedEmployees
	SELECT distinct u.IntUserID FROM
	(select us.nUserID as IntUserID from tUserSupervisors us inner join tuser su ON us.nSupervisorID = su.id
	where su.id= @SupervisorID and su.nSupervisorViewOptions IN (0,2)
	UNION
	select u.id as intUserID from tuser u inner join 
	tuser su ON 
	(u.nCompanyid = su.nCompanyRest OR su.nCompanyRest = 0)
	AND (u.nDeptID = su.nDeptRest OR su.nDeptRest = 0)
	AND (u.nJobTitleID = su.nCatRest OR su.nCatRest = 0)
	AND (u.nEmployeeType = su.nEmployeeTypeRest OR su.nEmployeeTypeRest = 0)
	where 
	su.id = @SupervisorID AND
	su.nSupervisorViewOptions < 2) u
END
--Search View
IF @SUPERVISORVIEW = 1
BEGIN
	INSERT INTO @tblSupervisedEmployees
	select u.id as intUserID from tuser u inner join 
	tuser su ON 
	(u.nCompanyid = su.nCompanyRest OR su.nCompanyRest = 0)
	AND (u.nDeptID = su.nDeptRest OR su.nDeptRest = 0)
	AND (u.nJobTitleID = su.nCatRest OR su.nCatRest = 0)
	AND (u.nEmployeeType = su.nEmployeeTypeRest OR su.nEmployeeTypeRest = 0)
	where 
	su.id = @SupervisorID AND
	su.nSupervisorViewOptions < 2
END

IF @SUPERVISORVIEW = 2
BEGIN
	INSERT INTO @tblSupervisedEmployees
	select us.nUserID as IntUserID from tUserSupervisors us inner join tuser su ON us.nSupervisorID = su.id
	where su.id= @SupervisorID and su.nSupervisorViewOptions IN (0,2)
END

RETURN
END
GO
