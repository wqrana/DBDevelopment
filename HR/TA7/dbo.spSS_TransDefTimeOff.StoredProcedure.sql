USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_TransDefTimeOff]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Waqar Qasim
-- Create date: 11/4/2022
-- Description:	Get Transaction with respect to timeOff in timeAide web setup
-- =============================================

CREATE PROCEDURE [dbo].[spSS_TransDefTimeOff]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select transDef.ID as TransId,transDef.Name as TransName ,
	transDef.sTDesc as Description, 
	transDef.sAccrualImportName  as AccrualType,	
	Case
	When ISNULL(transDefTimeOff.intTimeOffRequest,0) = 0 THEN
	0
	ELSE
	1
	End IsTimeOffTrans,
	boolUseSickInFamily,
	decMinimumAccrualTypeBalance,
	decMaximumYearlyTaken
	From tTransDef transDef
	Left Join tblSS_TransdefTimeOffRequest  transDefTimeOff On transDef.Name = transDefTimeOff.strTransName

END
GO
