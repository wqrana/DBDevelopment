USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[MergeRecentDataSyncStatus]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MergeRecentDataSyncStatus]
	@ClientID BIGINT,
	@ProcessName VARCHAR(35),
	@StartTimeUtc DATETIME,
	@EndTimeUtc DATETIME,
	@BlobURL VARCHAR(255),
	@Success BIT
AS
BEGIN
	MERGE dbo.DataSyncStatus T
	USING (select @ClientID ClientID, @ProcessName ProcessName, @StartTimeUtc StartTimeUtc, @EndTimeUtc EndTimeUtc, @BlobURL BlobURL, @Success Success) S
	ON T.ClientId = S.ClientId
		AND T.ProcessName = S.ProcessName
		AND T.StartTimeUtc = S.StartTimeUtc
	WHEN NOT MATCHED THEN
		INSERT 
			(ClientID, ProcessName, StartTimeUtc, EndTimeUtc, BlobURL, Success)
		VALUES
			(@ClientID, @ProcessName, @StartTimeUtc, @EndTimeUtc, @BlobURL, @Success)
	WHEN MATCHED THEN
		UPDATE SET EndTimeUtc = @EndTimeUtc, BlobURL = @BlobURL, Success = @Success
	;
END
GO
