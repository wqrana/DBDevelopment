USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CLREnDecriptSSN]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[fn_CLREnDecriptSSN](@ssnStr [nvarchar](max), @actionType [nvarchar](max))
RETURNS [nvarchar](max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [TimeAide.CLR].[UserDefinedFunctions].[fn_CLREnDecriptSSN]
GO
