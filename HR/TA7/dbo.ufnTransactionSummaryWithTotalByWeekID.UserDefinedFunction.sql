USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnTransactionSummaryWithTotalByWeekID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     CREATE FUNCTION [dbo].[ufnTransactionSummaryWithTotalByWeekID] (	 	@WeekID as  bigint, 	@Total as nvarchar(30) ) RETURNS TABLE  AS RETURN  ( select e_id as UseriD, @Total as TransType, sum(dblhours) as TransTotal from tPunchDateDetail where nWeekID = @WeekID  AND sType NOT IN ('LATE') group by e_id  UNION select e_id as UseriD, stype as TransType, sum(dblHours) as TransTotal from tPunchDateDetail pdd  where pdd.nWeekID = @WeekID group by e_id, sType  )   
GO
