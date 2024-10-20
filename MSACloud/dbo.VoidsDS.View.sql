USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[VoidsDS]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VoidsDS]

AS
select 
	ISNULL(ROW_NUMBER() OVER (order by SortDate),999) as ROWID 
	,* from 
(
select 	* ,
	0 as Type,
	orderdate as SortDate
from voids 
UNION ALL
select 	*,
	1 as Type,
	voidtime as SortDate
from voids
) sub
GO
