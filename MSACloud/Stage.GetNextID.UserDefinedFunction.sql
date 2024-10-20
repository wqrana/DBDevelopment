USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [Stage].[GetNextID]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 03/17/2015
-- Description:	Gets next ID value to use for this client and returns and int.
-- =============================================
CREATE FUNCTION [Stage].[GetNextID]
(
	@ClientID bigint,
	@FOBJECTID int, 
	@IDXNEEDED int, 
	@LOCALDB bit = 0
)
RETURNS int
AS
BEGIN
	DECLARE @RETVALUE int

	EXEC dbo.GETNEXTINDEX @ClientID, @FOBJECTID, @IDXNEEDED, @RETVALUE output, @LOCALDB

	RETURN @RETVALUE
END
GO
