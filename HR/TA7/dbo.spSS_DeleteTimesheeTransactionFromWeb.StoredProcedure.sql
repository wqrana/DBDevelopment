USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_DeleteTimesheeTransactionFromWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		WaqarQ
-- Create date: 02/21/2024
-- Description:	delete the transaction detail in tpunchpair from timesheet editor in web
-- =============================================
CREATE PROCEDURE [dbo].[spSS_DeleteTimesheeTransactionFromWeb]
	@TransactionIds as nvarchar(100)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @query as nvarchar(500)
	DECLARE	@transTbl as table(tppID int)	
	DECLARE	@DeletedtransTbl as table(e_id int,e_name nvarchar(30),DTPunchDate datetime,nWeekID bigint,HoursWorked float,sType nvarchar(30) )
	DECLARE @e_id as int
	DECLARE @maxtransDate as datetime
	Set @query= N'Select tppID 
	From tPunchPair
	Where tppID in ('+@TransactionIds+')'
	
	Insert 
	Into @transTbl
	Exec (@query)

	--select * from @transDateTbl
	BEGIN

	 DELETE 
	
	 FROM [dbo].[tPunchPair] 
	 OUtPUT deleted.e_id,deleted.e_name,deleted.DTPunchDate,deleted.nWeekID,deleted.HoursWorked,deleted.sType
	 INTO @DeletedtransTbl
	 WHERE tppID in (select tppID from @transTbl)

	 Select @e_id = max(e_id) , @maxtransDate = max(DTPunchDate)
	 From @DeletedtransTbl

	 Update pd
	 set b_Processed=0
	 From tPunchpair pd
	 Inner Join ( Select min(e_id) e_id,min(DTPunchDate) NextPunchDate 
				  from tPunchpair ppinner 
			      Where DTPunchDate >=@maxtransDate and e_id=@e_id ) maxPPTrans
				  On pd.e_id=maxPPTrans.e_id And maxPPTrans.NextPunchDate = pd.DTPunchDate

    if @@ROWCOUNT<1
	begin
		Update pd
		 set b_Processed=0
		 From tPunchpair pd
		 Inner Join ( Select min(e_id) e_id,max(DTPunchDate) NextPunchDate 
					  from tPunchpair ppinner 
					  Where  e_id=@e_id ) maxPPTrans
					  On pd.e_id=maxPPTrans.e_id And maxPPTrans.NextPunchDate = pd.DTPunchDate
	
	end
	Select * 
	From @DeletedtransTbl

	END
END
GO
