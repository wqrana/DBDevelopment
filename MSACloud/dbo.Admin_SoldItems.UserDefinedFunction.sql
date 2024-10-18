USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_SoldItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Admin_SoldItems] 
(	
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(

 SELECT clientid , MenuItem, Qty, Price,SCHID,  GDate
 FROM   SoldItems 
 where ClientID = @ClientID
 )
GO
