USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetUpdatedData]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUpdatedData]
	@tableName varchar(50),
	@lastSync datetime
AS
BEGIN
	declare @sqlstatement varchar(max)

	set @sqlstatement = 'SELECT TOP 100000 * FROM ' + @tableName + ' WHERE [LastUpdatedUTC] > '''+ convert(nvarchar, @lastSync, 1) + ''''	

	if COL_LENGTH(@tableName, 'UpdatedBySync') is not null
		set @sqlstatement = @sqlstatement + ' AND IsNull([UpdatedBySync], 0) = 0'	
	
	execute sp_executesql @sqlstatement
END
GO
