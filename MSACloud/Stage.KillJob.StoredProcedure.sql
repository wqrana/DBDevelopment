USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [Stage].[KillJob]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stage].[KillJob]
	@JobName varchar(50)
AS
BEGIN
	declare @sessionId int
		, @StartDatetime datetime = GETDATE()
		, @LastRecordLoaded int
		, @JobID int
		, @SchemaName varchar(50) = 'Stage'
		, @ThisProcedureName varchar(50) = 'KillJob'
	
	BEGIN TRY
		select top 1 @sessionId = session_id
		from (
				SELECT  requests.session_id, 
						requests.status, 
						requests.command, 
						requests.statement_start_offset,
						requests.statement_end_offset,
						requests.total_elapsed_time,
						details.text
				FROM    sys.dm_exec_requests requests
				CROSS APPLY sys.dm_exec_sql_text (requests.plan_handle) details
				WHERE requests.session_id > 50
			) t
		where text like 'create%' + @SchemaName + '.' + @JobName + '%'
		  and text not like 'create%' + @SchemaName + '.' + @ThisProcedureName + '%'

		if @sessionId > 0
		begin
			declare @killstatement nvarchar(100)
			set @killstatement = 'KILL ' + cast(@sessionId as varchar(30))
			exec sp_executesql @killstatement
		end
	END TRY
	BEGIN CATCH
		-- Consume
	END CATCH;

	select @JobID = JobID, @LastRecordLoaded = coalesce(LastRecordLoaded, -1) from Stage.JobControl where JobName = @JobName

	Update Stage.JobControl
	set EndTime = GetDate()
	   ,JobStatus = 'Failed'
	   ,LastRecordLoaded = @LastRecordLoaded
	where JobName = @JobName

	insert into Stage.MetricsLog (MetricName, NumValue, StartTimestampUTC, EndTimestampUTC)
	values(@SchemaName + '.' + @JobName + ' timed out and marked as Failed', @JobID, @StartDatetime, getdate());
END
GO
