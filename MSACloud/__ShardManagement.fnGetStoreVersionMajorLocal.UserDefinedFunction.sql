USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [__ShardManagement].[fnGetStoreVersionMajorLocal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [__ShardManagement].[fnGetStoreVersionMajorLocal]()
returns int
as
begin
	return (select StoreVersionMajor from __ShardManagement.ShardMapManagerLocal)
end
GO
