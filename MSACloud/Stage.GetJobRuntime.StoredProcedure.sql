USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [Stage].[GetJobRuntime]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stage].[GetJobRuntime] 
	@JobName VARCHAR(50),
	@Duration INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @Duration = DATEDIFF(SECOND, StartTime, GETDATE())
	FROM Stage.JobControl
	WHERE JobName = @JobName
		and JobStatus = 'Running'

	-- SET Duration to 0 if job is not running, so it does not run kill command
	IF @Duration IS NULL 
		SET @Duration = 0
END;
GO
