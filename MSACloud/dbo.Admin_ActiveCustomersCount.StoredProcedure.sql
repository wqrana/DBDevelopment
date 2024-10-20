USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_ActiveCustomersCount]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid H.
-- Create date: 09/01/2016
-- Description:	Get Customer count
-- =============================================

CREATE PROCEDURE [dbo].[Admin_ActiveCustomersCount]
	-- Add the parameters for the stored procedure here
	@ClientID bigint
AS
BEGIN

	SET NOCOUNT ON;
	

	-- Add the T-SQL statements to compute the return value here
	select count(*) as customersCount from customers where ClientID = @ClientID
	AND isActive = 1 and isDeleted = 0


END
GO
