USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_POS_Detail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/31/2014
-- Description:	Returns Details of the specified pos.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_POS_Detail]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@POSID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		p.Id as POS_Id,
		p.School_Id,
		s.SchoolName as School_Name,
		p.Name as POS_Name,
		p.EnableCCProcessing as Credit_Card_Enabled,
		p.VerifoneUserId as Credit_Card_UserId,
		p.VerifonePassword as Credit_Card_Password
		--select *
	FROM dbo.POS p
		LEFT OUTER JOIN Schools s on s.Id = p.School_Id AND p.ClientID = s.ClientID
	WHERE p.ClientID = @ClientID AND
		p.Id = @POSID
END
GO
