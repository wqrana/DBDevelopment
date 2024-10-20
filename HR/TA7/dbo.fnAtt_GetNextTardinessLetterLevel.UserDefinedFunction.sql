USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_GetNextTardinessLetterLevel]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     CREATE FUNCTION [dbo].[fnAtt_GetNextTardinessLetterLevel] ( 	     @UserID as int, @StartDate as smalldatetime, @EndDate as smalldatetime )     RETURNS int AS     BEGIN 	    DECLARE @SearchPeriodLength as int  	DECLARE @LevelComputationType as int  	DECLARE @NumLetterLevels as int  	DECLARE @NextEvaluationLevel as int  	    declare @StartOfPeriodDate as smalldatetime      	        select @SearchPeriodLength = nSearchPeriod,@LevelComputationType = nLevelComputationType, @NumLetterLevels = nLetterLevels from viewAtt_UserTardiness vu inner join tTardinessRules ar on vu.nTardinessRulesID = ar.ID     	        set @StartOfPeriodDate = DATEADD(MONTH,-@SearchPeriodLength, @StartDate)               	    if @LevelComputationType = 0 	    begin 		    select @NextEvaluationLevel= count(nWarningLetterID) from tTardinessLetters where nUserID = @USERID and dEndDateEvaluation BETWEEN @StartOfPeriodDate and @ENDDATE 	    end   	    if @LevelComputationType = 1 	    begin 		 	select @NextEvaluationLevel= nEvaluationLevel from tTardinessLetters where nUserID = @USERID and dEndDateEvaluation BETWEEN @StartOfPeriodDate and @ENDDATE	      if @NextEvaluationLevel is null SET @NextEvaluationLevel = 0     end 	    IF @NextEvaluationLevel < @NumLetterLevels 		    begin 		set @NextEvaluationLevel = @NextEvaluationLevel +1 		    end  	    ELSE 		    begin 		set @NextEvaluationLevel = @NumLetterLevels 		    end   	    return @NextEvaluationLevel      END      
GO
