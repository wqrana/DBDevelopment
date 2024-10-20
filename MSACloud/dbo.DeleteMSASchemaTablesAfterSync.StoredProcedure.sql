USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[DeleteMSASchemaTablesAfterSync]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Farrukh M (AllShore)
-- Create date: 06/20/2016
-- Description:	This procedure is used to delete records from Delete MSA tables after merge preorder tables.
-- =============================================

CREATE PROCEDURE [dbo].[DeleteMSASchemaTablesAfterSync]
	-- Add the parameters for the stored procedure here
	@TableName varchar(50),
	@CliendID bigint
	
AS
BEGIN
	DECLARE @sqlStatement NVARCHAR(500)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT off;

    -- Insert statements for procedure here
	
	SET @sqlStatement = 'DELETE FROM '+ @TableName +' WHERE ClientID = ' + convert(VARCHAR, @CliendID);

	execute sp_executesql @sqlStatement;
	
END
GO
