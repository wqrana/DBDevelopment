USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [__ShardManagement].[spGetStoreVersionLocalHelper]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [__ShardManagement].[spGetStoreVersionLocalHelper]
as
begin
	select
		5, StoreVersionMajor, StoreVersionMinor
	from 
		__ShardManagement.ShardMapManagerLocal
end
GO
