USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetUpdatedData_Latest]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetUpdatedData_Latest]
	@tableName varchar(50)
AS
BEGIN
	declare @sqlstatement nvarchar(max)

	set @sqlstatement = 'SELECT * FROM ' + @tableName + ' WHERE ISNULL([LastUpdatedUTC], ''1900-01-01'') > ISNULL([SyncDateUTC], ''1900-01-01'')'
	
	execute sp_executesql @sqlstatement
END
GO
