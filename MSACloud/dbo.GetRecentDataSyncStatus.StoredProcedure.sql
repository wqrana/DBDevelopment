USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetRecentDataSyncStatus]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetRecentDataSyncStatus]
	@ClientID BIGINT,
	@ProcessName VARCHAR(35),
	@LastStartTimeUtc DATETIME
AS
BEGIN
	SELECT TOP 1 ClientID, ProcessName, Id, StartTimeUtc, EndTimeUtc, BlobURL, Success
	  FROM dbo.DataSyncStatus
	 WHERE ClientID = @ClientID
	   AND ProcessName = @ProcessName
	   AND Success = 1
	   AND BlobURL is not null
	   AND StartTimeUtc >= (
			SELECT MAX(StartTimeUtc)
			 FROM dbo.DataSyncStatus
			WHERE ClientID = @ClientID
			  AND ProcessName = @ProcessName
			  AND Success = 1
			  AND BlobURL is not null
			  AND StartTimeUtc <= @LastStartTimeUtc
		   )
END
GO
