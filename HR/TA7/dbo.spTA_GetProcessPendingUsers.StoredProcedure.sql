USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTA_GetProcessPendingUsers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               CREATE PROCEDURE [dbo].[spTA_GetProcessPendingUsers] 	@USERID int AS BEGIN     UPDATE tenter set b_Processed = 1 where e_date < convert(varchar,DATEADD(month,-1,getdate()),112) and b_Processed = 0     UPDATE tenter set b_Processed = 1 where e_id not in (Select id from tuser) and b_Processed = 0     UPDATE tenter set b_Processed = 1 from tenter e inner join tuser u on e.e_id = u.id  	where b_Processed = 0   and nStatus  <> 1 	   UPDATE tPunchData set b_Processed = 1 where DTPunchDate< DATEADD(month,-1,getdate()) and b_Processed = 0     UPDATE tPunchData  SET  b_Processed = 1 from tPunchData e inner join tuser u on e.e_id = u.id  	where b_Processed = 0   and u.nStatus <> 1     UPDATE tPunchPair  SET  b_Processed = 1 from tPunchPair e inner join tuser u on e.e_id = u.id  	where b_Processed = 0   and u.nStatus <> 1     UPDATE tPunchDate SET b_Processed = 1 from tPunchDate e inner join tuser u on e.e_id = u.id  	where b_Processed = 0   and u.nStatus <> 1        SELECT intUserID, min(dtPunchDate) dtPunchDate, max(dtPunchDate) dtEndDate FROM [dbo].[fnTA_tblProcessPending] (@USERID) GROUP BY intUserID   ORDER BY dtPunchDate   END 
GO
