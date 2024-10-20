USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetRecordsHavingMSADistIDIsEqualToLocalID]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Farrukh M (Allshore)
-- Create date: 06/22/16
-- Description:	get records with Dist_Menu_Id from MSA (Menu table) = Local_Id from POS (Menu table)
-- =============================================
CREATE PROCEDURE [dbo].[GetRecordsHavingMSADistIDIsEqualToLocalID]
	-- Add the parameters for the stored procedure here
	@MSARecordsHavingCloudPOSIDIsNull dbo.MSARecordsHavingCloudPOSIDIsNull READONLY, 
	@TableName varchar(50),
	@ClientID BIGINT
AS
BEGIN
	
	DECLARE @sqlStatement AS nvarchar(max)  

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SET @sqlStatement =	'SELECT ClientID,Local_Id,Id FROM ' + @TableName + ' WHERE ISNULL(Local_ID,0) in (Select * from @MSARecordsHavingCloudPOSIDIsNull) and ClientID = ' + CONVERT(VARCHAR(50),@ClientID) 

	Print @sqlStatement
	EXEC sp_executesql @sqlStatement, N'@MSARecordsHavingCloudPOSIDIsNull dbo.MSARecordsHavingCloudPOSIDIsNull READONLY',@MSARecordsHavingCloudPOSIDIsNull;

END
GO
