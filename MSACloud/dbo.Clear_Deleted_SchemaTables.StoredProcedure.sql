USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Clear_Deleted_SchemaTables]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 31-Oct-2016
-- Description:	Delete all records from Deleted schema after syncing with local is completed.
-- This sp is used by the pos backend WEBAPI after syncing data via posdownstreamsync service.
-- =============================================
CREATE PROCEDURE  [dbo].[Clear_Deleted_SchemaTables]
@ClientID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @SqlStatement NVARCHAR(MAX)
	SELECT @SqlStatement = 
		COALESCE(@SqlStatement, '') + 'DELETE FROM [Deleted].' + QUOTENAME(TABLE_NAME) 
		+ ' WHERE ClientID = '+ CONVERT(VARCHAR, @ClientID) + ' AND UpdatedBySync = 1 AND cloudIdSync = 1;' + CHAR(13)
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = 'Deleted'

	--PRINT @SqlStatement
	EXEC SP_ExecuteSql @SqlStatement

    
END
GO
