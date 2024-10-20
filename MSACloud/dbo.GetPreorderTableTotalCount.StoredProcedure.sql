USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetPreorderTableTotalCount]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[GetPreorderTableTotalCount]
	@tableName varchar(50),
	@clientID BIGINT,
	@lastSyncDate DATETIME = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @sqlstatement NVARCHAR(1000)
	declare @sqlstatement_deletemsa_schema NVARCHAR(1000)

	BEGIN
	
	set @sqlstatement = 'SELECT COUNT(*)  FROM dbo.' + @tableName + ' WHERE ([LastUpdatedUTC] IS NULL OR [LastUpdatedUTC] > ISNULL(@lastSyncDate, ''1900-01-01'')) AND  [ClientID] = '+ CAST(@clientID as varchar)

	set @sqlstatement_deletemsa_schema = 'SELECT COUNT(*)  FROM DeletedMSA.' + @tableName + '' 
	
	END 

	execute sp_executesql @sqlstatement,N'@lastSyncDate DATETIME',@lastSyncDate
	
	execute sp_executesql @sqlstatement_deletemsa_schema

END
GO
